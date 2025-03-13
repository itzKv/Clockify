import 'package:clockify/core/params/params.dart';
import 'package:clockify/features/session/business/usecases/clear_session.dart';
import 'package:clockify/features/session/business/usecases/get_session.dart';
import 'package:clockify/features/session/business/usecases/save_session.dart';
import 'package:clockify/features/session/data/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SessionProvider extends ChangeNotifier {
  final SaveSession saveSession;
  final GetSession getSession;
  final ClearSession clearSession;
  
  String? _currentUser;
  String? get currentUser => _currentUser;

  final Map<String, String> _fakeUsers = {
    "user@example.com": "password!123",
    "test@demo.com": "securePass!1123",
  };

  SessionModel? _currentSession;
  SessionModel? get currentSession => _currentSession;

  SessionProvider({
    required this.saveSession,
    required this.getSession,
    required this.clearSession,
    // required this.authenticateUser,
  });

  void loadSession() {
    _currentSession = getSession();
    notifyListeners();
  }

  // Login Page
  bool checkEmail(String email) {
    return _fakeUsers.containsKey(email);
  }

  /// **Check if Password Matches for Given Email**
  bool checkPassword(String email, String password) {
    if (_fakeUsers[email] == password) {
      _currentUser = email;
      Hive.box('sessionBox').put('currentUser', email); // Save session
      notifyListeners();
      return true;
    }
    return false;
  }

  final MockApiService _apiService = MockApiService();
  Future<bool> login(String email, password) async {
    UserParams? user = await _apiService.getUserByEmail(email);
  
    if (user != null && user.password == password) {
      _currentUser = user.email;
      Hive.box('sessionBox').put('currentUser', user.email); // Save session
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> createSession(SessionModel session) async {
    await saveSession(session);
    _currentSession = session;
    notifyListeners();
  }

  Future<void> logout() async {
    await clearSession();
    _currentSession = null;
    notifyListeners();
  }
}