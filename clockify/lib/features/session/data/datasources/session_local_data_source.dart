import 'package:clockify/features/session/data/models/session_model.dart';
import 'package:hive/hive.dart';

abstract class SessionLocalDataSource {
   Future<void> saveSession(SessionModel session);
   Future<SessionModel?> getSession();
   Future<void> clearSession();
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  final Box<SessionModel> sessionBox;

  SessionLocalDataSourceImpl(this.sessionBox);

  @override
  Future<void> saveSession(SessionModel session) async {
    await sessionBox.put('session', session);
  }

  @override
  Future<SessionModel?> getSession() async {
    return sessionBox.get('session');
  }

  @override
  Future<void> clearSession() async {
    await sessionBox.delete('session');
  }
}