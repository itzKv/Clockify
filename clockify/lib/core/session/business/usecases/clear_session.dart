import 'package:clockify/core/session/business/repositories/session_repository.dart';

class ClearSession {
  final SessionRepository repository;

  ClearSession(this.repository);

  Future<void> call() async {
    await repository.clearSession();
  }
}