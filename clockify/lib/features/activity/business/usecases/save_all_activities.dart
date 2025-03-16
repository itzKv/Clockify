import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';

class SaveAllActivities {
  final ActivityRepository repository;

  SaveAllActivities(this.repository);

  Future<void> call(List<ActivityEntity> activities) async {
    return await repository.saveAllActivities(activities);
  }
}