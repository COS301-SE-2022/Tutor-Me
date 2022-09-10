// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/models/event.dart';
// import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/invite_to_meeting.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // late CalendarController _controller;

  final Map<DateTime, List<dynamic>> scheduledSessions ={};

  
  //   DateTime(2022, 9, 12): [
  //     Event(
  //       title: 'Session 1',
  //       description: 'Session 1',
  //       date: DateTime(2021, 9, 12),
  //       time: DateTime(2021, 9, 1, 10, 0),
  //       owner: 'Owner 1',
  //     ),
  //     Event(
  //       title: 'Session 2',
  //       description: 'Session 2',
  //       date: DateTime(2021, 9, 12),
  //       time: DateTime(2021, 9, 12, 11, 0),
  //       owner: 'Owner 2',
  //     ),
  //   ],
  //   DateTime(2022, 9, 22): [
  //     Event(
  //       title: 'Session 3',
  //       description: 'Session 3',
  //       date: DateTime(2021, 9, 22),
  //       time: DateTime(2021, 9, 22, 10, 0),
  //       owner: 'Owner 3',
  //     ),
  //     Event(
  //       title: 'Session 4',
  //       description: 'Session 4',
  //       date: DateTime(2021, 9, 22),
  //       time: DateTime(2021, 9, 22, 11, 0),
  //       owner: 'Owner 4',
  //     ),
  //   ],
  //   DateTime(2022, 9, 23): [
  //     Event(
  //       title: 'Session 5',
  //       description: 'Session 5',
  //       date: DateTime(2021, 9, 23),
  //       time: DateTime(2021, 9, 23, 10, 0),
  //       owner: 'Owner 5',
  //     ),
  //     Event(
  //       title: 'Session 6',
  //       description: 'Session 6',
  //       date: DateTime(2021, 9, 23),
  //       time: DateTime(2021, 9, 23, 11, 0),
  //       owner: 'Owner 6',
  //     ),
  //   ],
  //   DateTime(2022, 9, 24): [
  //     Event(
  //       title: 'Session 7',
  //       description: 'Session 7',
  //       date: DateTime(2021, 9, 24),
  //       time: DateTime(2021, 9, 24, 10, 0),
  //       owner: 'Owner 7',
  //     ),
  //   ],
  // };

  List getScheduledSessions(DateTime date) {
    print(date);
    print("hiiiiii ");
    print(scheduledSessions[1]);
    return scheduledSessions[date] ?? [];
  }

  @override
  void initState() {
    super.initState();

    // _controller = CalendarController();
  }

  CalendarFormat format = CalendarFormat.month;
  DateTime mySelectedDay = DateTime.now();
  DateTime myFocusedDay = DateTime.now();
  DateTime time = DateTime.now();

  TextEditingController meetingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    meetingController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    double toggleWidth = MediaQuery.of(context).size.width * 0.4;
    double textBoxWidth = MediaQuery.of(context).size.width * 0.4 * 2;
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;
    if (widthOfScreen >= 400.0) {
      toggleWidth = toggleWidth / 2;
      buttonWidth = buttonWidth / 2;
      textBoxWidth = textBoxWidth / 2;
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              TableCalendar(
                startingDayOfWeek: StartingDayOfWeek.sunday,
                eventLoader: scheduledSessions.isNotEmpty
                    ? (date) {
                        return getScheduledSessions(date);

                        // return getScheduledSessions(date);
                      }
                    : null,
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: colorWhite,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorBlueTeal,
                      width: 1.0,
                    ),
                  ),
                  todayDecoration: BoxDecoration(
                    color: colorBlueTeal,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorBlueTeal,
                      width: 1.0,
                    ),
                  ),
                  selectedTextStyle: selectedStyle(FontWeight.bold),
                ),
                firstDay: DateTime.now(),
                focusedDay: myFocusedDay,
                lastDay: DateTime(2025),
                calendarFormat: format,
                onFormatChanged: (CalendarFormat format) {
                  setState(() {
                    format = format;
                  });
                },
                onDaySelected: (DateTime day, DateTime fday) {
                  setState(() {
                    mySelectedDay = day;
                    myFocusedDay = fday;
                  });
                },
                selectedDayPredicate: (DateTime day) {
                  return isSameDay(day, mySelectedDay);
                },
                headerStyle: HeaderStyle(
                  // centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                    color: colorOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                    color: colorBlueTeal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: colorBlueTeal,
                    size: MediaQuery.of(context).size.width * 0.085,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: colorBlueTeal,
                    size: MediaQuery.of(context).size.width * 0.085,
                  ),
                ),
              ),
              const Divider(
                color: Color.fromARGB(255, 241, 241, 241),
                thickness: 1,
                height: 1,
              ),
              ...getScheduledSessions(mySelectedDay).map((e) => ListTile(
                    title: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.0,
                                    color: colorLightGrey.withOpacity(0.6)))),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.03,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      e.title,
                                      style: TextStyle(
                                          color: colorBlueTeal,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      e.description,
                                      style: TextStyle(
                                          color: colorOrange,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                child: const Text("Send Invitation",
                                    style: TextStyle(color: colorOrange)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InviteToMeeting(
                                          title: e.title,
                                          description: e.description),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        )),
                  ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Schedule Meeting'),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: meetingController,
                            decoration: const InputDecoration(
                                labelText: 'Meeting Title'),
                          ),
                          TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                                labelText: 'Meeting Description'),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: colorDarkGrey),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () {
                          if (meetingController.text.isEmpty) {
                            return;
                          }
                          // else {
                          if (scheduledSessions[mySelectedDay] != null) {
                            scheduledSessions[mySelectedDay]?.add(Event(
                                title: meetingController.text,
                                description: descriptionController.text,
                                date: mySelectedDay,
                                time: time,
                                owner: "Me"));
                          } else {
                            scheduledSessions[mySelectedDay] = [
                              Event(
                                  title: meetingController.text,
                                  description: descriptionController.text,
                                  date: mySelectedDay,
                                  time: time,
                                  owner: "Me")
                            ];
                          }
                          // }
                          Navigator.pop(context);
                          meetingController.clear();
                          descriptionController.clear();

                          //move forward to next page
                          return;
                        },
                      ),
                    ],
                  )),
          backgroundColor: colorOrange,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  TextStyle dayStyle(FontWeight normal) {
    return TextStyle(
      // fontSize: 18,
      fontWeight: normal,
      color: colorBlack,
    );
  }

  selectedStyle(FontWeight bold) {
    return TextStyle(
      // fontSize: 18,
      fontWeight: bold,
      color: colorOrange,
    );
  }
}
