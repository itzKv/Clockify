import 'package:clockify/features/activity/data/models/activity_model.dart';
import 'package:hive/hive.dart';

abstract class ActivityLocalDataSource {
  Future<void> saveActivity(ActivityModel activity);
  Future<List<ActivityModel>> getAllActivities();
  Future<ActivityModel?> getActivityById(String id);
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
  Future<ActivityModel?> getActivityById(String id) async {
    return activityBox.get(id);
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