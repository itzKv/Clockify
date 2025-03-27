import 'package:clockify/features/timer/presentation/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerInfoWidget extends StatelessWidget {
  const TimerInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Column(
      children: [
        Text(
          "Start Time: ${timerProvider.startTime ?? '-'}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          "End Time: ${timerProvider.endTime ?? '-'}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
