import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/usecases/delete_activity.dart';
import 'package:clockify/features/activity/business/usecases/get_activity_by_description.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/activity/business/usecases/save_activity.dart';
import 'package:flutter/material.dart';

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
  List<ActivityEntity> _searchedActivities = [];
  bool _isSearching = false;

  List<ActivityEntity> get activities => _isSearching ? _searchedActivities : _activities;
  bool get isSearching => _isSearching;

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
      _isSearching = false;
      _searchedActivities = [];
    } else {
      _isSearching = true;
      final result = await _getActivityByDescription(description);
      _searchedActivities = result;
    }
    notifyListeners();
  }
}