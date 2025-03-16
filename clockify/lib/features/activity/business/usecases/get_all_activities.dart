import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllActivities {
  final ActivityRepository repository;

  GetAllActivities(this.repository);

  Future<Either<Failure, List<ActivityEntity>>> call() async {
    return await repository.getAllActivities();
  }
}