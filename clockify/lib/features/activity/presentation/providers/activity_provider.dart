import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/usecases/delete_activity.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/activity/business/usecases/save_activity.dart';
import 'package:flutter/material.dart';

class ActivityProvider extends ChangeNotifier {
  final GetAllActivities _getAllActivities;
  final SaveActivity _saveActivity;
  final DeleteActivity _deleteActivity;

  ActivityProvider({
    required GetAllActivities getAllActivities,
    required SaveActivity saveActivity,
    required DeleteActivity deleteActivity,
  })  : _getAllActivities = getAllActivities,
        _saveActivity = saveActivity,
        _deleteActivity = deleteActivity;

  List<ActivityEntity> _activities = [];

  List<ActivityEntity> get activities => _activities;

  Future<void> fetchActivities() async {
    _activities = await _getAllActivities();
    notifyListeners();
  }

  void addActivity(ActivityEntity activity) {
    _saveActivity(activity);
    notifyListeners();
  }

  Future<void> deleteActivity(String id) async {
    await _deleteActivity(id);
    fetchActivities();
  }
}