import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:intl/intl.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  bool _isTimerStarted = false;
  bool _isTimerStopped = false;
  DateTime? _startTime;
  DateTime? _endTime;
  List<Map<String, DateTime>> timerList = [];
  final DateFormat timeFormatter = DateFormat('HH:mm:ss'); 
  final DateFormat dateFormatter = DateFormat('d MMM yy'); 

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();  // Need to call dispose function.
  }

  Widget _stopWatch() {
    return SizedBox(
      height: 64,
      child: StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime, 
        builder: (context, snapshot) {
          final displayTime = StopWatchTimer.getDisplayTime(snapshot.data ?? 0);
          return Text(
            displayTime,
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

  Widget _listOfTimer() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Start Time
          SizedBox(
            height: 128,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Start Time",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),

                _startTime != null
                    ? (() {
                        final String formattedStartTime = timeFormatter.format(_startTime!);
                        final String formattedStartDate = dateFormatter.format(_startTime!);

                        return SizedBox(
                          height: 72,
                          width: 128,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formattedStartTime,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  formattedStartDate,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })()
                    : SizedBox(
                        height: 72,
                        width: 128,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 36,
                              child: Text(
                                '-',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 36,
                              child: Text(
                                '-',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),

          // --- End Time
          SizedBox(
            height: 128,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "End Time",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),

                _endTime != null
                    ? (() {
                        final String formattedStartTime = timeFormatter.format(_endTime!);
                        final String formattedStartDate = dateFormatter.format(_endTime!);

                        return SizedBox(
                          height: 72,
                          width: 128,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formattedStartTime,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  formattedStartDate,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })()
                      : SizedBox(
                        height: 72,
                        width: 128,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 36,
                              child: Text(
                                '-',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 36,
                              child: Text(
                                '-',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
              ),
            ),
          ],
        ),
      );
    }
  
  Widget _button() {
    return SizedBox(
      width: double.infinity,
      child: _isTimerStarted
        ? (_isTimerStopped
          ? SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- SAVE
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Color(0xff45CDDC), Color(0xff2EBED9)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(10, 0, 0, 0),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0.0, 2.0),
                        )
                      ]
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isTimerStarted = !_isTimerStarted;
                          _isTimerStopped = !_isTimerStopped;
                          timerList.add({ 'startTime': _startTime!, 'endTime': _endTime! });
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "SAVE",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // DELETE Button
                Expanded(
                  child: Container(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onResetTimer();
                        setState(() {
                          _isTimerStarted = false;
                          _isTimerStopped = false;
                          _startTime = null;
                          _endTime = null;
                          if (timerList.isNotEmpty) {
                            timerList.removeLast();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "DELETE",
                        style: TextStyle(color: Color(0XFFA7A6C5), fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
          : SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- STOP
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Color(0xff45CDDC), Color(0xff2EBED9)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(10, 0, 0, 0),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0.0, 2.0),
                        )
                      ]
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onStopTimer();
                        setState(() {
                          _isTimerStopped = !_isTimerStopped;
                          _endTime = DateTime.now();
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "STOP",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // RESET Button
                Expanded(
                  child: Container(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onResetTimer();
                        setState(() {
                          _isTimerStarted = false;
                          _isTimerStopped = false;
                          _startTime = null;
                          _endTime = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "RESET",
                        style: TextStyle(color: Color(0XFFA7A6C5), fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        )
        : Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Color(0xff45CDDC), Color(0xff2EBED9)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(10, 0, 0, 0),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0.0, 2.0),
                )
              ]
            ),
            child: ElevatedButton(
              onPressed: () {
                _stopWatchTimer.onResetTimer();
                _stopWatchTimer.onStartTimer();
                setState(() {
                  _isTimerStarted = !_isTimerStarted;
                  _endTime = null;
                  _startTime = DateTime.now();
                });
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "START",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          )
    );
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      // Stop watch
      _stopWatch(),

      // List of timer
      _listOfTimer(),

      // Location

      // Description

      // Button
      _button()
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children
        )
      )
    );
  }
}