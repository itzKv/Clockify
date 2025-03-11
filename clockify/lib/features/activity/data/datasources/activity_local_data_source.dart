import 'package:clockify/features/activity/data/models/activity_model.dart';
import 'package:hive/hive.dart';

abstract class ActivityLocalDataSource {
  Future<void> saveActivity(ActivityModel activity);
  Future<List<ActivityModel>> getAllActivities();
  Future<List<ActivityModel>> getActivityByDescription(String description);
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
  Future<void> saveActivity(ActivityModel activity) async {
     await activityBox.put(activity.id, activity);
  }
}