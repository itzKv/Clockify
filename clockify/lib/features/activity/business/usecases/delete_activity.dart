import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteActivity {
  final ActivityRepository repository;

  DeleteActivity(this.repository);

  Future<Either<Failure, void>> call(String uuid) async {
    return await repository.deleteActivity(uuid);
  }
}