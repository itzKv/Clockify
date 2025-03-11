import 'package:clockify/features/activity/business/repositories/activity_repository.dart';

class DeleteActivity {
  final ActivityRepository repository;

  DeleteActivity(this.repository);

  Future<void> call(String activityId) async {
    await repository.deleteActivity(activityId);
  }
}