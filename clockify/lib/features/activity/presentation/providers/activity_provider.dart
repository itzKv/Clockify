import 'dart:math';

import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/usecases/delete_activity.dart';
import 'package:clockify/features/activity/business/usecases/get_activity_by_description.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/activity/business/usecases/save_activity.dart';
import 'package:flutter/material.dart';
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

  List<ActivityEntity> _activities = [];
  List<ActivityEntity> _filteredActivities = [];
  bool _isFiltering = false;

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

  void filterByLatestDate() {
    _isFiltering = true;
    _filteredActivities = List.from(_activities)..sort((a, b) => b.startTime.compareTo(a.startTime));
    notifyListeners();
  }
  
  Future<void> filterByNearby() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _isFiltering = true;
      _filteredActivities = List.from(_activities)..sort(
        (a, b) {
          double distanceA = _calculateDistance(position.latitude, position.longitude, a.locationLat!, a.locationLng!);
          double distanceB = _calculateDistance(position.latitude, position.longitude, b.locationLat!, b.locationLng!);
          return distanceA.compareTo(distanceB); // Sort by nearest first
        },
      );

      notifyListeners();
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  void resetFilters() {
    _isFiltering = false;
    _filteredActivities = [];
    notifyListeners();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth radius in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

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