import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';
import 'package:dartz/dartz.dart';

class GetActivityByDescription {
  final ActivityRepository repository;

  GetActivityByDescription(this.repository);

  Future<Either<Failure, List<ActivityEntity>>> call(String description) async {
    return repository.getActivityByDescription(description);
  }
}