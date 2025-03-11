import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/repositories/activity_repository.dart';

class SaveActivity {
  final ActivityRepository repository;

  SaveActivity(this.repository);

  Future<void> call(ActivityEntity activityEntity) async {
    return repository.saveActivity(activityEntity);
  }
}