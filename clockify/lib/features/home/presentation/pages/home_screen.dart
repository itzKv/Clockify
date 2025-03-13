import 'package:clockify/features/activity/presentation/pages/activity_screen.dart';
import 'package:clockify/features/timer/presentation/pages/timer_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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