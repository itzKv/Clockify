import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateActivity {
  final ActivityRepository repository;

  UpdateActivity(this.repository);

  Future<Either<Failure, void>> call(UpdateActivityParams updateActivityParams) async {
    return await repository.updateActivity(updateActivityParams);
  }
}