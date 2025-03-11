import 'package:clockify/core/presentation/widgets/success_dialog_alert.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/usecases/delete_activity.dart';
import 'package:clockify/features/activity/business/usecases/save_activity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ActivityDetailScreen extends StatefulWidget {
  final ActivityEntity activity;

  const ActivityDetailScreen({super.key, required this.activity});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  DateTime? _startTime;
  DateTime? _endTime;
  final DateFormat timeFormatter = DateFormat('HH:mm:ss'); 
  final DateFormat dateFormatter = DateFormat('d MMM yy'); 
  late double? _locationLat;
  late double? _locationLng;
  late TextEditingController _descriptionController = TextEditingController();
  final Uuid _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.activity.description);
  }

  bool _validateInput() {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Description must not be empty."), backgroundColor: Colors.red,),
      );

      return false;
    }

    return true;
  }

  
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours : $minutes : $seconds";
  }

   Widget _currentDate() {
    return SizedBox(
      height: 72,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(
          child: Text(
            dateFormatter.format(DateTime.now()),
            style: TextStyle(
              fontSize: 16,
              color: Color(0xffF8D068),
            ),
          ),
        ),
      )
    );
  }

  Widget _stopWatch() {
    return SizedBox(
      height: 64,
      child: StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime, 
        builder: (context, snapshot) {
          final displayTime = formatDuration(widget.activity.endTime.difference(widget.activity.startTime));

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
              SizedBox(
                height: 72,
                width: 128,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timeFormatter.format(widget.activity.startTime),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        dateFormatter.format(widget.activity.startTime),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
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
              SizedBox(
                height: 72,
                width: 128,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timeFormatter.format(widget.activity.endTime), // Changed to `formattedEndTime`
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        dateFormatter.format(widget.activity.endTime), // Changed to `formattedEndDate`
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
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
              '${widget.activity.locationLat},${widget.activity.locationLng}' ,
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

  Widget _button(SaveActivity saveActivity, DeleteActivity deleteActivity) {
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
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
                        
                        final activity = ActivityEntity(
                          id: widget.activity.id,
                          startTime: widget.activity.startTime,
                          endTime: widget.activity.endTime,
                          description: _descriptionController.text,
                          locationLat: widget.activity.locationLat,
                          locationLng: widget.activity.locationLng,
                          createdAt: widget.activity.createdAt,
                          updatedAt: DateTime.now(),
                        );

                        // Save
                        try {
                          saveActivity(activity);

                          // Sucess then show dialog
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 3), () async {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context); // Close the dialog
                                  }
                                  if (context.mounted) {
                                    Navigator.pop(context); // Close the Activity Detail Screen
                                  }
                                });

                                return SuccessDialog(
                                  title: "Activity Updated", 
                                  message: "Your activity has been saved."
                                );
                              },
                            );
                          }
                        } catch (e) {
                          debugPrint("Error updating activity: $e");
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
                  onPressed: () async {
                    bool? confirmDelete = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            textAlign: TextAlign.center,
                            "Confirm Delete",
                            style: TextStyle(
                              color: Colors.black
                            ),
                          ),
                          content: Text(
                            "Are you sure want to delete this activity?",
                            style: TextStyle(
                              color: Color(0xffA7A6C5)
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.red
                                ) ,
                              ),
                            )
                          ],
                        );
                      }
                    );

                    if (confirmDelete == true) {
                      try {
                        deleteActivity(widget.activity.id);

                        // Sucess then show dialog
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 3), () async {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context); // Close the dialog
                                }

                                if (context.mounted) {
                                  Navigator.pop(context); // Close the Activity Detail Screen
                                }
                              });

                              return SuccessDialog(
                                title: "Activity Deleted", 
                                message: "Activity of ${widget.activity.description} has beed deleted."
                              );
                            },
                          );
                        }
                      } catch (e) {
                        debugPrint("Error deleting activity: $e");
                      }
                    }
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use Cases
    final saveActivity = Provider.of<SaveActivity>(context);
    final deleteActivity = Provider.of<DeleteActivity>(context);


    var children = [
      // Current Date
      SizedBox(height: 36),
      _currentDate(),

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
      _button(saveActivity, deleteActivity),
    ];

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Detail",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left_rounded),
            iconSize: 40,
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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