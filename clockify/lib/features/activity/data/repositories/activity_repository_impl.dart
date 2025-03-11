import 'package:dartz/dartz.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';
import 'package:clockify/features/activity/data/datasources/activity_local_data_source.dart';
import 'package:clockify/features/activity/data/models/activity_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDataSource localDataSource;

  ActivityRepositoryImpl({required this.localDataSource});

  @override
  Future<ActivityEntity?> getActivityById(String id) async {
    final model = await localDataSource.getActivityById(id);
    return model?.toEntity();
  }

  @override
  Future<List<ActivityEntity>> getAllActivities() async {
    final models = await localDataSource.getAllActivities();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveActivity(ActivityEntity activity) async {
    final model = ActivityModel.fromEntity(activity);
    await localDataSource.saveActivity(model);
  }
  
  @override
  Future<void> deleteActivity(String id) {
    return localDataSource.deleteActivity(id);
  }

  
}