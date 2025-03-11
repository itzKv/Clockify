import 'package:clockify/features/activity/business/entities/activity_entity.dart';
import 'package:clockify/features/activity/business/usecases/get_all_activities.dart';
import 'package:clockify/features/timer/presentation/pages/timer_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}


class _ActivityScreenState extends State<ActivityScreen> {
  final DateFormat timeFormatter = DateFormat('HH:mm:ss'); 
  late String _dropdownValue = 'Latest Date';
  void dropdownCallback(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      
      final hours = twoDigits(duration.inHours);
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      
      return "$hours : $minutes : $seconds";
    }


  Widget _searchActivity() {
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
            decoration: const InputDecoration(
              hintText: "Search activity",
              hintStyle: TextStyle(
                color: Color(0xffA7A6C5),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xff25367B),
              ),
              border: InputBorder.none, // Removes default border
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterActivity() {
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
              onChanged: dropdownCallback,
            ),
          ),
        ),
      ),
    );
  }

  Widget _activityInfo(ActivityEntity activity) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(TimerScreen(activity: activity));
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
                            fontSize: 16,
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
                          activity.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
            SizedBox(height: 2,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                height: 1,
                width: double.infinity,
                color: Color(0xff434B8C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityList(GetAllActivities getAllActivities) {
    return Expanded(
      child: FutureBuilder<List<ActivityEntity>>(
        future: getAllActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"),);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No activities found!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                )
              ),
            );
          }

          final activities = snapshot.data!;
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _activityInfo(activity);
            },
          );
        },
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    final getAllActivities = Provider.of<GetAllActivities>(context);
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
                        _searchActivity(),
                        SizedBox(width: 16,),
                        _filterActivity(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ListView or other UI elements can go here
                  _activityList(getAllActivities),
                ],
              ), 

        ),
    );
  }
}
