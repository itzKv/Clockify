import 'package:clockify/core/session/business/repositories/session_repository.dart';
import 'package:clockify/core/session/data/datasources/session_local_data_source.dart';
import 'package:clockify/core/session/data/models/session_model.dart';

class SessionRepositoryImpl extends SessionRepository {
  final SessionLocalDataSource localDataSource;

  SessionRepositoryImpl({required this.localDataSource});
  
  @override
  Future<void> clearSession() async {
    return localDataSource.clearSession();
  }

  @override
  Future<SessionModel?> getSession() {
    return localDataSource.getSession();
  }

  @override
  Future<void> saveSession(SessionModel session) async {
    await localDataSource.saveSession(session);
  }
}