import 'package:clockify/core/presentation/widgets/success_dialog_alert.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/presentation/providers/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

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
  final DateFormat timeFormatter = DateFormat('HH:mm:ss'); 
  final DateFormat dateFormatter = DateFormat('d MMM yy'); 
  late double? _locationLat;
  late double? _locationLng;
  late String _locationAddress = "Fetching location ...";
  final TextEditingController _descriptionController = TextEditingController();
  final Uuid _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _getLocation(); // Get the location after load screen
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();  // Need to call dispose function.
  }

  bool _validateInput() {
    debugPrint("This one is running");
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Description must not be empty."), backgroundColor: Colors.red,),
      );

      return false;
    }
    debugPrint("description is not empty");

    return true;
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission are permanently disabled.");
    }

    // Get the location
    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _getLocation() async {
    try {
      Position position = await _getCurrentPosition();
      setState(() {
        _locationLat = position.latitude;
        _locationLng = position.longitude;
        _locationAddress = '$_locationLat , $_locationLng';
      });
    } catch (e) {
       setState(() {
        _locationAddress = 'Error: $e'; 
       });
    }
  }

  Widget _stopWatch() {
    return SizedBox(
      height: 64,
      child: StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime, 
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

  Widget _timerInfo() {
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
  
  Widget _locationInfo() {
    return Container(
      height: 48,
      width: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xff434B8C),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: Color(0xffF8D068),
              size: 20,
            ),
            Text(
              _locationAddress,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400
              ),
            ),
          ],) 
      ),
    );
  }

  Widget _description() {
    return Container(
      height: 96,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xffF5F6FC),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: TextFormField(
          controller: _descriptionController,
          maxLines: null, // Expand not horizontally, but vertically.
          decoration: InputDecoration(
            hintText: "Write your activity here ...",
            hintStyle: TextStyle(
              color: Color(0xffA7A6C5),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff25367B),
            fontWeight: FontWeight.w400
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _button(ActivityProvider activityProvider) {
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
                        if (_validateInput()) {
                          setState(() {
                            _isTimerStarted = !_isTimerStarted;
                            _isTimerStopped = !_isTimerStopped;
                            
                            final activity = ActivityEntity(
                              id: _uuid.v4(),
                              startTime: _startTime!,
                              endTime: _endTime!,
                              description: _descriptionController.text,
                              locationLat: _locationLat,
                              locationLng: _locationLng,
                              createdAt: _startTime!,
                              updatedAt: _endTime!,
                            );

                            // Reset stopwatch
                            _stopWatchTimer.onResetTimer();
                            _startTime = null;
                            _endTime = null;
                            _descriptionController.text = "";

                            // Save
                            try {
                              activityProvider.addActivity(activity);

                              // Sucess then show dialog
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false, // Prevent any dismmising by tapping outside
                                  builder: (context) {
                                    Future.delayed(Duration(seconds: 3), () async {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context); // Close the dialog
                                      }
                                    });

                                    return SuccessDialog(
                                      title: "Activity Saved", 
                                      message: "Your activity has been saved."
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              debugPrint("Error saving activity: $e");
                            }
                          });
                        }
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
                          _descriptionController.text = "";
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
    final activityProvider = Provider.of<ActivityProvider>(context);

    var children = [
      // Stop watch
      SizedBox(height: 72),
      _stopWatch(),
      SizedBox(height: 72),

      // List of timer
      _timerInfo(),
      SizedBox(height: 24),

      // Location
      _locationInfo(),
      SizedBox(height: 32),

      // Description
      _description(),
      SizedBox(height: 32),

      // Button
      _button(activityProvider),
      SizedBox(height: 16),
    ];

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}