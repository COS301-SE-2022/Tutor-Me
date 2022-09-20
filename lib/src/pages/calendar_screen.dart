// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/services/models/event.dart';
// import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/invite_to_meeting.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../../services/models/users.dart';
import '../../services/services/events_services.dart';
import '../../services/services/user_services.dart';
import '../theme/themes.dart';

class CalendarScreen extends StatefulWidget {
  final Globals globals;
  const CalendarScreen({Key? key, required this.globals}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // late CalendarController _controller;
  // Event event = Event();
  List<Event> events = List<Event>.empty(growable: true);
  bool isLoading = true;
  List<Users> owner = List<Users>.empty(growable: true);
  DateTime timeSelected = DateTime.now();

  getUserEvents() async {
    try {
      final incomingEvents = await EventServices.getEventsByUserId(
          widget.globals.getUser.getId, widget.globals);
      events = incomingEvents;
    } catch (e) {
      const snack = SnackBar(content: Text('Error loading events'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    loadScheduledSession();
  }

  getOwner() async {
    try {
      for (int i = 0; i < events.length; i++) {
        final incomingOwner =
            await UserServices.getTutor(events[i].getOwnerId, widget.globals);
        owner += incomingOwner;
      }
    } catch (e) {
      print(e.toString());
      const snack = SnackBar(content: Text('Error loading events'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserEvents();
  }

  late Map<DateTime, List<dynamic>> scheduledSessions = {};

  loadScheduledSession() {
    DateTime varDate;

    int month, year, day;
    int min, hour;
    List<String> date;

    print("kjjojjo");
    for (int i = 0; i < events.length; i++) {
      min = int.parse(events[i].getTimeOfEvent.substring(3, 4));
      hour = int.parse(events[i].getTimeOfEvent.substring(0, 1));

      print(events[i].getDateOfEvent);
      date = events[i].getDateOfEvent.split('/');

      varDate = DateTime.parse(events[i].getDateOfEvent);
      print(varDate);
      scheduledSessions.addAll({
        DateTime(varDate.year, varDate.month, varDate.day): [
          events[i],
        ]
      });
      print(DateTime.now());
      print("noooo ");
      print(scheduledSessions);
      getOwner();
    }
  }

  List getScheduledSessions(DateTime date) {
    var newDate = DateTime(date.year, date.month, date.day);

    return scheduledSessions[newDate] ?? [];
  }

  List printResults(date) {
    return [];
  }

  CalendarFormat format = CalendarFormat.month;
  DateTime mySelectedDay = DateTime.now();
  DateTime myFocusedDay = DateTime.now();
  DateTime time = DateTime.now();

  TextEditingController meetingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  EventServices event = EventServices();

  @override
  void dispose() {
    meetingController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color primaryColor;
    Color secondaryColor;
    Color textColor;
    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      primaryColor = colorGrey;
      textColor = colorWhite;
      highLightColor = colorLightBlueTeal;
      secondaryColor = colorLightGrey;
    } else {
      primaryColor = colorBlueTeal;
      textColor = colorDarkGrey;
      highLightColor = colorOrange;
      secondaryColor = colorWhite;
    }

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
                    ? (date) => getScheduledSessions(date)
                    : (date) => printResults(date),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: colorWhite,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor,
                      width: 1.0,
                    ),
                  ),
                  todayDecoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor,
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
                    color: highLightColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: primaryColor,
                    size: MediaQuery.of(context).size.width * 0.085,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: primaryColor,
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
                                      e.getTitle,
                                      style: TextStyle(
                                          color: primaryColor,
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
                                      e.getDescription,
                                      style: TextStyle(
                                          color: highLightColor,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                child: Text("Send Invitation",
                                    style: TextStyle(color: highLightColor)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InviteToMeeting(
                                        globals: widget.globals,
                                      ),
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
              builder: (context) => Center(
                    child: AlertDialog(
                      title: const Text('Schedule Meeting'),
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
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
                            TextFormField(
                              controller: timeController,
                              decoration: const InputDecoration(
                                  labelText: 'Meeting Time'),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: textColor),
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
                                meetingController.text,
                                descriptionController.text,
                                mySelectedDay.toString(),
                                timeController.text,
                                "",
                                "",
                                "",
                                widget.globals.getUser.getId,
                              ));
                              EventServices.createEvent(
                                  Event(
                                    meetingController.text,
                                    descriptionController.text,
                                    mySelectedDay.toString(),
                                    timeController.text,
                                    widget.globals.getUser.getId,
                                    "",
                                    "",
                                    widget.globals.getUser.getId,
                                  ),
                                  widget.globals);
                            } else {
                              scheduledSessions[mySelectedDay] = [
                                Event(
                                  meetingController.text,
                                  descriptionController.text,
                                  mySelectedDay.toString(),
                                  time.toString(),
                                  "",
                                  "",
                                  "",
                                  widget.globals.getUser.getId,
                                ),
                              ];
                              EventServices.createEvent(
                                  Event(
                                    meetingController.text,
                                    descriptionController.text,
                                    mySelectedDay.toString(),
                                    timeController.text,
                                    "",
                                    "",
                                    "",
                                    widget.globals.getUser.getId,
                                  ),
                                  widget.globals);
                            }
                            // }
                            Navigator.pop(context);
                            meetingController.clear();
                            descriptionController.clear();
                            timeController.clear();

                            //move forward to next page
                            return;
                          },
                        ),
                      ],
                    ),
                  )),
          backgroundColor: highLightColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  TextStyle dayStyle(FontWeight normal) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color textColor;

    if (provider.themeMode == ThemeMode.dark) {
      textColor = colorWhite;
    } else {
      textColor = colorDarkGrey;
    }

    return TextStyle(
      // fontSize: 18,
      fontWeight: normal,
      color: textColor,
    );
  }

  selectedStyle(FontWeight bold) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      highLightColor = colorLightBlueTeal;
    } else {
      highLightColor = colorOrange;
    }
    return TextStyle(
      // fontSize: 18,
      fontWeight: bold,
      color: highLightColor,
    );
  }
}
