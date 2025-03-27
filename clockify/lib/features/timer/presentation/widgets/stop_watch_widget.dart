import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatchWidget extends StatelessWidget {
  final StopWatchTimer stopWatchTimer;

  const StopWatchWidget({super.key, required this.stopWatchTimer});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: StreamBuilder<int>(
        stream: stopWatchTimer.rawTime, 
        builder: (context, snapshot) {
          final displayTime = StopWatchTimer.getDisplayTime(
            snapshot.data ?? 0,
            hours: true,
            minute: true,
            second: true,
            milliSecond: false,
          );

          // Replace the format
          final formattedTime = displayTime.replaceAll(":", " : ");

          return Text(
            formattedTime,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w700
            ),
          );
        }
      )
    );
  }
}