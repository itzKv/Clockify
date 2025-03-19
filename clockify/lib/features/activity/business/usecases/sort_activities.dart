import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';
import 'package:dartz/dartz.dart';

class SortActivities {
  final ActivityRepository repository;

  SortActivities(this.repository);

  Future<Either<Failure, List<ActivityEntity>>> call(String params, List<double>? location) async {
    return await repository.sortActivites(params, location);
  }
}