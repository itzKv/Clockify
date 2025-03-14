import 'package:clockify/core/presentation/widgets/success_dialog_alert.dart';
import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/usecases/delete_activity.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/activity/presentation/providers/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}


class _ActivityScreenState extends State<ActivityScreen> {
  final DateFormat timeFormatter = DateFormat('HH:mm:ss'); 
  final DateFormat dateFormatter = DateFormat('d MMM yy'); 
  late String _dropdownValue = 'Latest Date';
  final FocusNode _focusNode = FocusNode();

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    return "$hours : $minutes : $seconds";
  }

  void _toggleKeyboard() {
    if (_focusNode.hasFocus) {
      // Close keyboard if it's on
      _focusNode.unfocus();
    } else {
      // Open keyboard if it's on
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  Widget _searchActivity(ActivityProvider activityProvider) {
    return Flexible(
      flex: 2,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextFormField(
            onChanged: (value) {
              activityProvider.searchActivity(value);
            },
            decoration: InputDecoration(
              hintText: "Search activity",
              hintStyle: TextStyle(
                color: Color(0xffA7A6C5),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              suffixIcon: GestureDetector(
                onTap: _toggleKeyboard,
                child: Icon(
                  Icons.search,
                  color: Color(0xff25367B),
                ),
              ),
              border: InputBorder.none, // Removes default border
              contentPadding: EdgeInsets.symmetric(vertical: 12)
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterActivity(ActivityProvider activityProvider) {
    return Flexible(
      flex: 1,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xff434B8C)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButtonHideUnderline( // Removes dropdown underline
            child: DropdownButton<String>(
              dropdownColor: Color(0xff434B8C),
              borderRadius: BorderRadius.circular(12),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              iconSize: 20,
              iconDisabledColor: Colors.white,
              iconEnabledColor: Colors.white,
              value: _dropdownValue,
              items: ['Latest Date', 'Nearby'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value, 
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? selectedValue) {
                setState(() {
                  _dropdownValue = selectedValue!;
                  activityProvider.setFilter(_dropdownValue);
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _activityInfo(ActivityEntity activity, ActivityProvider activityProvider) {
    return Slidable(
      key: ValueKey(activity.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(), 
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) async {
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
                  activityProvider.deleteActivity(activity.id);
                  // Sucess then show dialog
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false, // Prevent any dismmising by tapping outside
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () async {
                          if (context.mounted) {
                              Navigator.pop(context); // Close the Activity Detail Screen
                            }
                          });

                          return SuccessDialog(
                            title: "Activity Deleted", 
                            message: "Activity of ${activity.description} has beed deleted."
                          );
                        },
                      );
                    }
                  } catch (e) {
                    debugPrint("Error deleting activity: $e");
                  }
                }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white, 
            icon: Icons.delete,
            label: "Delete",
          )
        ]
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/activityDetail',
            arguments: activity,
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Container(
                height: 64,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDuration((activity.endTime.difference(activity.startTime))),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_filled,
                                color: Color(0xffA7A6C5),
                              ),
                              SizedBox(width: 4), // Add spacing
                              Text(
                                timeFormatter.format(activity.startTime),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                ' - ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                timeFormatter.format(activity.endTime),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            maxLines: 1,
                            activity.description,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Color(0xffA7A6C5),
                                size: 20,
                              ),
                              SizedBox(width: 4), // Add spacing
                              Text(
                                '${activity.locationLat!.toStringAsFixed(4)},${activity.locationLng!.toStringAsFixed(4)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 4,),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: Color(0xff434B8C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityList(ActivityProvider activityProvider) {
    return Expanded(
      child: Consumer<ActivityProvider>(
        builder: (context, activityProvider, child) {
          if (!activityProvider.isSearching) {
             activityProvider.fetchActivities(); // Fetch at once
          }
          
          final activities = activityProvider.activities;

          if (activities.isEmpty) {
            return Center(
              child: Text(
                "No activities found.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // 1. Group activities by date
          Map<String, List<ActivityEntity>> groupedActivities = {};
          for (var activity in activities) {
            String dateKey = DateFormat('yyyy-MM-dd').format(activity.endTime);
            groupedActivities.putIfAbsent(dateKey, () => []).add(activity);
          }


          // 2. Sort dates (latest first)
          List<String> sortedDates = groupedActivities.keys.toList()
            ..sort((a, b) => b.compareTo(a)); // Descending

          return ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              String dateKey = sortedDates[index];
              List<ActivityEntity> dailyActivities = groupedActivities[dateKey]!;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Header
                  Container(
                    width: double.infinity,
                    height: 24,
                    color: Color(0xff434B8C),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: Text(
                        dateFormatter.format(DateTime.parse(dateKey)),
                        style: TextStyle(
                          color: Color(0xffF8D068),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // List of activities for that date
                  ...dailyActivities.map((activity) => _activityInfo(activity, activityProvider))
                ],
              );
              // return _activityInfo(activity, activityProvider);
            },
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
      final activityProvider = Provider.of<ActivityProvider>(context);

      return SafeArea(
        child: Scaffold(
          body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _searchActivity(activityProvider),
                          SizedBox(width: 16,),
                          _filterActivity(activityProvider),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ListView or other UI elements can go here
                    _activityList(activityProvider),
                  ],
                ), 

          ),
      );
    }
  }
