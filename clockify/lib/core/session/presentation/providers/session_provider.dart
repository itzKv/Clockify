import 'package:clockify/core/session/business/usecases/clear_session.dart';
import 'package:clockify/core/session/business/usecases/get_session.dart';
import 'package:clockify/core/session/business/usecases/save_session.dart';
import 'package:clockify/core/session/data/models/session_model.dart';
import 'package:flutter/material.dart';
class SessionProvider extends ChangeNotifier {
  final SaveSession saveSession;
  final GetSession getSession;
  final ClearSession clearSession;

  SessionModel? _session;
  SessionModel? get session => _session;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  SessionProvider({
    required this.saveSession,
    required this.getSession,
    required this.clearSession,
  }) {
    checkSession(); // Auto-check session 
  }

  Future<void> loadUserSession() async {
    _session = await getSession.call();
    _isAuthenticated = _session != null && _isSessionValid(_session!);
    debugPrint("Loaded session: $_session"); 
    notifyListeners();
  }

  Future<void> saveUserSession(SessionModel session) async {
    await saveSession.call(session);
    _session = session;
    _isAuthenticated = true;
    debugPrint("Saved session: $_session"); // Debug output
    notifyListeners();
  }

  Future<void> clearUserSession() async {
    await clearSession.call();
    _session = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkSession() async {
    SessionModel? session = await getSession.call();
    if (session != null && _isSessionValid(session)) {
      _session = session;
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
      _session = null;
    }
    notifyListeners();
  }

  bool _isSessionValid(SessionModel session) {
    return session.expiryDate.isAfter(DateTime.now());
  }
}