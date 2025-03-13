import 'package:clockify/features/session/business/repositories/session_repository.dart';
import 'package:clockify/features/session/data/models/session_model.dart';

class SaveSession {
  final SessionRepository repository;

  SaveSession(this.repository);

  Future<void> call(SessionModel session) {
    return repository.saveSession(session);
  }
}