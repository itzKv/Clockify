import 'package:clockify/core/session/data/models/session_model.dart';

abstract class SessionRepository {
  Future<void> saveSession(SessionModel session);
  Future<SessionModel?> getSession();
  Future<void> clearSession();
  // Future<Either<Failure, UserParams>> authenticateUser(String email, {String? password, String? confirmPassword});
}