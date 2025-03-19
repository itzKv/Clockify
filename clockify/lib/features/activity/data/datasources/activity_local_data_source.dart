import 'package:clockify/features/activity/data/models/activity_model.dart';
import 'package:hive/hive.dart';

abstract class ActivityLocalDataSource {
  Future<void> createActivity(ActivityModel activity);
  Future<List<ActivityModel>> getAllActivities();
  Future<List<ActivityModel>> getActivityByDescription(String description);
  Future<void> saveAllActivities(List<ActivityModel> activities);
  Future<void> deleteActivity(String id);
}

class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  final Box<ActivityModel> activityBox;

  ActivityLocalDataSourceImpl(this.activityBox);
  
  @override
  Future<void> deleteActivity(String id) async {
    await activityBox.delete(id);
  }
  
  @override
  Future<List<ActivityModel>> getActivityByDescription(String description) async {
    return activityBox.values
      .where((activity) => activity.description.toLowerCase().contains(description.toLowerCase()))
      .toList();
  }
  
  @override
  Future<List<ActivityModel>> getAllActivities() async {
    return activityBox.values.toList();
  }

  @override
  Future<void> saveAllActivities(List<ActivityModel> activities) async {
    for (var activity in activities) {
      if (!activityBox.containsKey(activity.uuid)) {
        await activityBox.put(activity.uuid, activity);
      }
    }
  }
  
  @override
  Future<void> createActivity(ActivityModel activity) async {
     await activityBox.put(activity.uuid, activity);
  }
}