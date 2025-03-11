import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';

class GetAllActivities {
  final ActivityRepository repository;

  GetAllActivities(this.repository);

  Future<List<ActivityEntity>> call() async {
    return repository.getAllActivities();
  }
}