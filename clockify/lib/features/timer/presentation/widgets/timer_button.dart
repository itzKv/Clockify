import 'package:clockify/features/timer/presentation/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TimerButton extends StatelessWidget {
  const TimerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Skeletonizer(
      enabled: false, // Ganti ini dengan provider kalau ada loading state
      child: SizedBox(
        width: double.infinity,
        child: timerProvider.isTimerStarted
            ? (timerProvider.isTimerStopped ? _buildSaveDeleteButtons(context, timerProvider) : _buildStopResetButtons(timerProvider))
            : _buildStartButton(timerProvider),
      ),
    );
  }

  Widget _buildSaveDeleteButtons(BuildContext context, TimerProvider timerProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton(
          text: "SAVE",
          onPressed: () {
            // Logic untuk simpan activity
          },
          gradient: const LinearGradient(colors: [Color(0xff45CDDC), Color(0xff2EBED9)]),
          textColor: Colors.white,
        ),
        const SizedBox(width: 16),
        _buildButton(
          text: "DELETE",
          onPressed: timerProvider.resetTimer,
          backgroundColor: Colors.white,
          textColor: const Color(0XFFA7A6C5),
        ),
      ],
    );
  }

  Widget _buildStopResetButtons(TimerProvider timerProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton(
          text: "STOP",
          onPressed: timerProvider.stopTimer,
          gradient: const LinearGradient(colors: [Color(0xff45CDDC), Color(0xff2EBED9)]),
          textColor: Colors.white,
        ),
        const SizedBox(width: 16),
        _buildButton(
          text: "RESET",
          onPressed: timerProvider.resetTimer,
          backgroundColor: Colors.white,
          textColor: const Color(0XFFA7A6C5),
        ),
      ],
    );
  }

  Widget _buildStartButton(TimerProvider timerProvider) {
    return _buildButton(
      text: "START",
      onPressed: timerProvider.startTimer,
      gradient: const LinearGradient(colors: [Color(0xff45CDDC), Color(0xff2EBED9)]),
      textColor: Colors.white,
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    Gradient? gradient,
    Color? backgroundColor,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: gradient,
          color: backgroundColor,
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(10, 0, 0, 0),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0.0, 2.0),
            )
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
