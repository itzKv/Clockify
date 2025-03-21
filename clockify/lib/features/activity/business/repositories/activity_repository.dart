import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ActivityRepository {
  Future<Either<Failure, void>> createActivity(ActivityEntity activity);
  Future<void> saveAllActivities(List<ActivityEntity> activities);
  Future<Either<Failure, List<ActivityEntity>>> getAllActivities(GetAllActivitiesParams getAllActivitiesParams);
  Future<Either<Failure, void>> deleteActivity(String uuid);
  Future<Either<Failure, void>> updateActivity(UpdateActivityParams updateActivityParams);
}