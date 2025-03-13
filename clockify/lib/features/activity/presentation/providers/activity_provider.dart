import 'dart:math';
import 'dart:async';
import 'dart:isolate';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/usecases/delete_activity.dart';
import 'package:clockify/features/activity/business/usecases/get_activity_by_description.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/activity/business/usecases/save_activity.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class ActivityProvider extends ChangeNotifier {
  final GetAllActivities _getAllActivities;
  final SaveActivity _saveActivity;
  final DeleteActivity _deleteActivity;
  final GetActivityByDescription _getActivityByDescription; // Searching

  ActivityProvider({
    required GetAllActivities getAllActivities,
    required SaveActivity saveActivity,
    required DeleteActivity deleteActivity,
    required GetActivityByDescription getActivityByDescription,
  })  : _getAllActivities = getAllActivities,
        _saveActivity = saveActivity,
        _deleteActivity = deleteActivity,
        _getActivityByDescription = getActivityByDescription;

  List<ActivityEntity> _activities = []; // Original Data
  List<ActivityEntity> _filteredActivities = []; // Filtered Data
  bool _isFiltering = false;
  String _searchQuery = "";
  String _seletedFilter = "Latest Date";

  List<ActivityEntity> get activities => _isFiltering ? _filteredActivities : _activities;
  bool get isSearching => _isFiltering;

  Future<void> fetchActivities() async {
     try {
      final result = await _getAllActivities();
      _activities = result;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching activities: $e");
    }
  }

  void addActivity(ActivityEntity activity) {
    _saveActivity(activity);
    notifyListeners();
  }

  Future<void> deleteActivity(String id) async {
    await _deleteActivity(id);
    fetchActivities();
  }

  Future<void> getActivityByDescription(String description) async {
    if (description.isEmpty) {
      _isFiltering = false;
      _filteredActivities = [];
    } else {
      _isFiltering = true;
      final result = await _getActivityByDescription(description);
      _filteredActivities = result;
    }
    notifyListeners();
  }

  void searchActivity(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void setFilter(String filter) {
    _seletedFilter = filter;
    _applyFilters();
  }

  void _applyFilters() {
    // 1. Apply Searching Filter 
    _filteredActivities = _activities.where((activity) {
      return activity.description.toLowerCase().contains(_searchQuery);
    }).toList();

    // 2. Sort based on the selected filter
    if (_seletedFilter == "Latest Date") {
      filterByLatestDate();
    } else if (_seletedFilter == "Nearby") {
      filterByNearby();
    }

    _isFiltering = _searchQuery.isNotEmpty || _seletedFilter != "Latest Date";
    notifyListeners();
  }

  void filterByLatestDate() {
    _isFiltering = true;
    _filteredActivities.sort((a, b) => b.endTime.compareTo(a.endTime));
    notifyListeners();
  }
  
  Future<void> filterByNearby() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _isFiltering = true;

      // Run on a different isolate. Meaning that it will not consume another time.
      _filteredActivities = await compute(_sortActivitiesByDistance, {
        "activities": _activities,
        "lat": position.latitude,
        "lng": position.longitude,
      });

      notifyListeners();
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  // Helper function for isolating processing
  List<ActivityEntity> _sortActivitiesByDistance(Map<String, dynamic> data) {
    List<ActivityEntity> activities = List.from(data['activities']);
    double lat = data["lat"];
    double lng = data["lng"];

    return activities..sort((a,b) {
      double distanceA = _calculateDistance(lat, lng, a.locationLat!, a.locationLng!);
      double distanceB = _calculateDistance(lat, lng, b.locationLat!, b.locationLng!);
      return distanceA.compareTo(distanceB);
    });
  }

  void resetFilters() {
    _isFiltering = false;
    _filteredActivities = [];
    notifyListeners();
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double R = 6371; // Earth radius in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lng2 - lng1);

    double a = 
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
        (sin(dLon / 2) * sin(dLon / 2));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }
}