import 'dart:async';
import 'package:clockify/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    // Scale animation (bouncing effect)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Fade animation (opacity from 0 to 1)
    _fadeAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Navigate to LoginScreen after delay
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: LoginScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller when screen is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff25367B),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Image.asset(
            'assets/images/Logo.png',
            height: 80,
            width: 300,
          ),
        ),
      ),
    );
  }
}
