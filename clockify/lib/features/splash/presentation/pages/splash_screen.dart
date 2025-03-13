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
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    // Define the animation sequence for scaling and rotating
    _animation = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween(begin: 0.0, end: 1.0), // Rotate
        weight: 120,
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: 1.0, end: 1.5), // Scale up
        weight: 20,
      ),
    ]).animate(_controller);

    // Navigate to LoginScreen after delay
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.scale,
          alignment: Alignment.center,
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
            return Transform.scale(
              scale: 1 + (_animation.value * 0.8), // Scale animation
              child: Transform.rotate(
                angle: _animation.value * 2 * 3.1416, // Rotate animation
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
