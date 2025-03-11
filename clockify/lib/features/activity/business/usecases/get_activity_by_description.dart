import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';

class GetActivityByDescription {
  final ActivityRepository repository;

  GetActivityByDescription(this.repository);

  Future<List<ActivityEntity>> call(String description) async {
    return repository.getActivityByDescription(description);
  }
}