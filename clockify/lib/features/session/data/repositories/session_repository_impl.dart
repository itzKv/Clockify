import 'package:clockify/core/errors/failure.dart';
import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/session/business/repositories/session_repository.dart';
import 'package:clockify/features/session/data/datasources/session_local_data_source.dart';
import 'package:clockify/features/session/data/models/session_model.dart';
import 'package:dartz/dartz.dart';

class SessionRepositoryImpl extends SessionRepository {
  final SessionLocalDataSource localDataSource;

  SessionRepositoryImpl({required this.localDataSource});
  
  @override
  Future<void> clearSession() {
    return localDataSource.clearSession();
  }

  @override
  SessionModel? getSession() {
    return localDataSource.getSession();
  }

  @override
  Future<void> saveSession(SessionModel session) async {
    await localDataSource.saveSession(session);
  }

  // @override
  // Future<Either<Failure, UserParams>> authenticateUser(String email, {String? password, String? confirmPassword}) async {
  //   await localDataSource.authenticateUser
  // }  
}