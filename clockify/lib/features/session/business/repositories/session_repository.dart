import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/session/data/models/session_model.dart';
import 'package:dartz/dartz.dart';

abstract class SessionRepository {
  Future<void> saveSession(SessionModel session);
  SessionModel? getSession();
  Future<void> clearSession();
  // Future<Either<Failure, UserParams>> authenticateUser(String email, {String? password, String? confirmPassword});
}