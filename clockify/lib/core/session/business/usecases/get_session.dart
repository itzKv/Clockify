import 'package:clockify/core/session/business/repositories/session_repository.dart';
import 'package:clockify/core/session/data/models/session_model.dart';

class GetSession {
  final SessionRepository repository;

  GetSession(this.repository);

  Future<SessionModel?> call() async {
    return await repository.getSession();
  }
}