import 'dart:math';
import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/usecases/delete_activity.dart';
import 'package:clockify/features/activity/business/usecases/get_activity_by_description.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/activity/business/usecases/create_activity.dart';
import 'package:clockify/features/activity/business/usecases/sort_activities.dart';
import 'package:clockify/features/activity/business/usecases/update_activity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ActivityProvider extends ChangeNotifier {
  final GetAllActivities _getAllActivities;
  final CreateActivity _createActivity;
  final UpdateActivity _updateActivity;
  final DeleteActivity _deleteActivity;
  final GetActivityByDescription _searchActivity; // Searching
  final SortActivities _sortActivities;
  final Duration _debounceDuration = Duration(milliseconds: 300);
  

  ActivityProvider({
    required GetAllActivities getAllActivities,
    required CreateActivity createActivity,
    required UpdateActivity updateActivity,
    required DeleteActivity deleteActivity,
    required GetActivityByDescription getActivityByDescription,
    required SortActivities sortActivities,
  })  : _getAllActivities = getAllActivities,
        _createActivity = createActivity,
        _updateActivity = updateActivity,
        _deleteActivity = deleteActivity,
        _searchActivity = getActivityByDescription,
        _sortActivities = sortActivities;

  bool _isLoading = false;
  bool _isFiltering = false;
  double? _latitude;
  double? _longitude;
  Timer? _debounce;

  List<ActivityEntity> _activities = []; // Original Data
  List<ActivityEntity> _filteredActivities = []; // Filtered Data

  List<ActivityEntity> get activities => _isFiltering ? _filteredActivities : _activities;
  bool get isLoading => _isLoading;
  bool get isSearching => _isFiltering;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  void setLocation(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
    notifyListeners();
  }

  // ============================================================ USE CASES ======================================================================

  Future<void> fetchActivities() async {
    _isLoading = true;
    notifyListeners();

    final result = await _getAllActivities();
    result.fold(
      (failure) {
        debugPrint("Failure fetching Activities: ${failure.errorMessage}");
        _isLoading = false;
        notifyListeners();
        throw Exception("Failed to fetching activity: ${failure.errorMessage}");
      },
      (result) {
        debugPrint("Success Fethcing Activities: $result");
        _activities = result;
      } 
    );

    _isLoading = false;
    await sortingActivities("Latest Date", null);
  }

  Future<void> addActivity(ActivityEntity activity) async {
    _isLoading = true;
    notifyListeners();

    final result = await _createActivity(activity);
    result.fold(
      (failure) {
        debugPrint("Failure Creating Activities: ${failure.errorMessage}");
        throw Exception("Failed to creating activity: ${failure.errorMessage}");
      },
      (_) async {
        debugPrint("Success Creating Activities");
        await fetchActivities(); // Fetch again to refresh the Storage and UI.
      }
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateActivity(ActivityEntity activity) async {
    _isLoading = true;
    notifyListeners();

    final result = await _updateActivity(activity);
    result.fold(
      (failure) {
        debugPrint("Failure updating Activities: ${failure.errorMessage}");
        throw Exception("Failed to updating activity: ${failure.errorMessage}");
      },
      (_) async {
        debugPrint("Success updating Activities");
        await fetchActivities(); // Fetch again to refresh the Storage and UI.
      }
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteActivity(String id) async {
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
        await fetchActivities(); // Fetch again to refresh the Storage and UI.
      }
    );
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchActivity(BuildContext context, String description) async {
    _isLoading = true;
    notifyListeners();
    // Reset debouncer everytime input changes
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () async {
      if (description.isEmpty) {
        _isFiltering = false;
        _filteredActivities = [];
      } else {
        _isFiltering = true;
        final result = await _searchActivity.call(description);

        (result).fold(
          (failure) {
            debugPrint("Failure search activity: ${failure}");
            if (failure is ServerFailure && failure.errorData != null) {
              debugPrint("Error JSON: ${failure.errorData}");
              debugPrint("Error ms: ${failure.errorMessage}");

              if (failure.errorMessage.contains("No post found!")) {
                debugPrint("Showing Snackbar of Fail");

                _filteredActivities = [];
                notifyListeners();

                final snackBar = SnackBar(
                  elevation: 0,
                  duration: Duration(seconds: 3, microseconds: 300),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: "Oops! No activity found", 
                    titleTextStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w700
                    ),
                    message: "Try adjusting your search or adding a new activity!", 
                    messageTextStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w400
                    ),
                    contentType: ContentType.failure
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              }
            }
            return;
          },
          (searchedActivities) {
            _filteredActivities = searchedActivities;
          })
        ;
      }
      
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> sortingActivities(String params, List<double>? location) async {
    _isLoading = true;
    notifyListeners();

    final result = await _sortActivities(params, location);
    result.fold(
      (failure) {
        _isFiltering = false;
        _isLoading = false;
        notifyListeners();
        debugPrint("Failure sort Activities by latest date: ${failure.errorMessage}");
        throw Exception("Failed to sort activities by latest date: ${failure.errorMessage}");
      },
      (sortedList) {
        _isFiltering = true;
        _filteredActivities = sortedList;
        _isLoading = false;
        notifyListeners();
        debugPrint("Success Sort Activities by $params: $result");
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