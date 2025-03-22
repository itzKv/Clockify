import 'dart:async';

import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/usecases/delete_activity.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/activity/business/usecases/create_activity.dart';
import 'package:clockify/features/activity/business/usecases/update_activity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ActivityProvider extends ChangeNotifier {
  final GetAllActivities _getAllActivities;
  final CreateActivity _createActivity;
  final UpdateActivity _updateActivity;
  final DeleteActivity _deleteActivity;
  final Duration _debounceDuration = Duration(milliseconds: 300);
  

  ActivityProvider({
    required GetAllActivities getAllActivities,
    required CreateActivity createActivity,
    required UpdateActivity updateActivity,
    required DeleteActivity deleteActivity,
  })  : _getAllActivities = getAllActivities,
        _createActivity = createActivity,
        _updateActivity = updateActivity,
        _deleteActivity = deleteActivity;

  bool _isLoading = false;
  double? _latitude;
  double? _longitude;
  Timer? _debounce;
  String _dropDownValue = "latestdate";

  List<ActivityEntity> _activities = []; // Original Data

  List<ActivityEntity> get activities => _activities;
  bool get isLoading => _isLoading;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String get dropDownValue => _dropDownValue;

  set dropDownValue(String newValue) {
    _dropDownValue = newValue;
    notifyListeners();
  }

  void setLocation(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
    notifyListeners();
  }

  // ============================================================ USE CASES ======================================================================
          
  Future<void> fetchActivities(BuildContext context, GetAllActivitiesParams getAllActivitiesParams) async {
    // Cancel any ongoing debounce timer
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _isLoading = true;
      notifyListeners();

      final result = await _getAllActivities(getAllActivitiesParams);
      result.fold(
        (failure) {
          debugPrint("Failure fetching Activities: ${failure.errorMessage}");
          _activities = [];
        },
        (fetchedActivities) {
          debugPrint("Success Fetching Activities: $fetchedActivities");
          _activities = fetchedActivities.isEmpty ? [] : fetchedActivities;
        },
      );

      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addActivity(BuildContext context, ActivityEntity activity) async {
    _isLoading = true;
    notifyListeners();

    // Reset debouncer everytime input changes
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () async {

    final result = await _createActivity(activity);
    result.fold(
      (failure) {
        debugPrint("Failure Creating Activities: ${failure.errorMessage}");
      },
      (_) async {
        debugPrint("Success Creating Activities");
        await fetchActivities(context, GetAllActivitiesParams(choice: dropDownValue.toLowerCase().trim())); // Fetch again to refresh the Storage and UI.
      }
    );

    _isLoading = false;
    notifyListeners();
  }
    );
  }

  Future<void> updateActivity(BuildContext context, UpdateActivityParams updateActivityParams) async {
    _isLoading = true;
    notifyListeners();

    final result = await _updateActivity.call(updateActivityParams);
    result.fold(
      (failure) {
        debugPrint("Failure updating Activities: ${failure.errorMessage}");
        return;
      },
      (_) async {
        debugPrint("Success updating Activities");
        await fetchActivities(context, GetAllActivitiesParams(choice: dropDownValue.toLowerCase().trim())); // Fetch again to refresh the Storage and UI.
      }
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteActivity(BuildContext context, String id) async {
    _isLoading = true;
    notifyListeners();

    final result = await _deleteActivity(id);
    result.fold(
      (failure) {
        debugPrint("Failure Deleting Activities: ${failure.errorMessage}");
        throw Exception("Failed to delete activity: ${failure.errorMessage}");
      },
      (_) async {
        debugPrint("Success Deleting Activities");
        await fetchActivities(context, GetAllActivitiesParams(choice: _dropDownValue.toLowerCase().trim())); // Fetch again to refresh the Storage and UI.
      }
    );
    
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}