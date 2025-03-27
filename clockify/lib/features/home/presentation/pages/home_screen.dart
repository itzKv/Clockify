import 'dart:async';
import 'dart:io';

import 'package:clockify/features/activity/presentation/pages/activity_screen.dart';
import 'package:clockify/features/auth/presentation/pages/login_screen.dart';
import 'package:clockify/core/session/presentation/providers/session_provider.dart';
import 'package:clockify/features/timer/presentation/pages/timer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Timer? _logoutTimer;

  void _onPopInvokedWithResult(bool didPop, dynamic result) {
    if (didPop) return; // Block back navigation

    _showExitDialog();
  }

  Future<void> _showExitDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit App"),
        content: Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => exit(0), // Close the app
            child: Text(
              "Exit",
              style: TextStyle(
                color: Colors.red
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkSession() async {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    await sessionProvider.checkSession();

    if (!sessionProvider.isAuthenticated) {
      _logout();
    }
  }

  void _logout({ bool showExpiredDialog = false }) async {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    sessionProvider.clearUserSession(); 
    if (showExpiredDialog) {
      await _showSessionExpiredDialog();
    }
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  void _startAutoLogoutTimer() {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    if (sessionProvider.session != null) {
      final expiryDate = sessionProvider.session!.expiryDate;
      final timeRemaining = expiryDate.difference(DateTime.now());
      print("Time Remaining: $timeRemaining");

      if (timeRemaining.isNegative) {
        _logout(showExpiredDialog: true);
      } else {
        _logoutTimer = Timer(timeRemaining, () => _logout(showExpiredDialog: true));
      }
    }
  }

  Future<void> _showSessionExpiredDialog() async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing it
      builder: (context) => AlertDialog(
        title: Text('Session Expired'),
        content: Text('Your session has expired. Please log in again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkSession();
    _startAutoLogoutTimer();
  }

  @override
  void dispose() {
    _logoutTimer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Block navigates back
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: Center(
                  child: Image.asset('assets/images/Logo-2.png'),
                ),
              ),

              SizedBox(height: 16,),

              // Navigation Text Button
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // Navigation Item
                  children: [
                    _buildNavItem("TIMER", 0),
                    _buildNavItem("ACTIVITY", 1),
                  ],
                ),
              ),            
              // Content
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    TimerScreen(),
                    ActivityScreen()
                  ],
                ) ,
              )
            ],
          ),
        )
      )
    );
  }

  Widget _buildNavItem(String text, int index) {
    bool isSelected = _selectedIndex == index;

    return TextButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected ? Color(0xffF8D068) : Color(0xffA7A6C5),
            ),
          ),
          SizedBox(height: 2), 
          if (isSelected) 
            Container(
              width: 40,
              height: 1.5, 
              color: Color(0xffF8D068),
            ),
        ],
      ),
    );
  }
}