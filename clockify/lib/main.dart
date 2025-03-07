import 'package:clockify/core/themes/theme.dart';
import 'package:clockify/features/login/presentation/pages/login_screen.dart';
import 'package:clockify/features/password/presentation/pages/password_screen.dart';
import 'package:clockify/features/create_account/presentation/pages/create_account_screen.dart';
import 'package:clockify/features/splash/presentation/pages/splash_screen.dart';
import 'package:clockify/features/timer/presentation/pages/timer_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  // await Hive.openBox('appBox');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/createAccount': (context) => CreateAccountScreen(),
        '/password': (context) => PasswordScreen(),
        '/timer': (context) => TimerScreen(),
      },
      theme: appTheme,
    );
  }
}
