import 'package:clockify/features/activity/presentation/providers/activity_provider.dart';
import 'package:clockify/features/timer/presentation/providers/timer_provider.dart';
import 'package:clockify/features/timer/presentation/widgets/description_widget.dart';
import 'package:clockify/features/timer/presentation/widgets/location_info_widget.dart';
import 'package:clockify/features/timer/presentation/widgets/timer_button.dart';
import 'package:clockify/features/timer/presentation/widgets/timer_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final StopWatchTimer stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TimerProvider>(context, listen: false).fetchLocation());
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Skeletonizer(
                  enabled: activityProvider.isLoading,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const TimerInfoWidget(),
                        const SizedBox(height: 16),
                        const DescriptionWidget(),
                        const SizedBox(height: 16),
                        const LocationInfo(),
                        const SizedBox(height: 16),
                        const TimerButton(),
                      ],
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}