import 'package:clockify/features/session/business/repositories/session_repository.dart';
import 'package:clockify/features/session/data/models/session_model.dart';

class GetSession {
  final SessionRepository repository;

  GetSession(this.repository);

  SessionModel? call() {
    return repository.getSession();
  }
}