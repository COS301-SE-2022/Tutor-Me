import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/services/models/event.dart';
// import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/invite_to_meeting.dart';
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
  List<Event> events = List<Event>.empty(growable: true);
  bool isLoading = true;
  List<Users> owner = List<Users>.empty(growable: true);
  DateTime timeSelected = DateTime.now();
  TimeOfDay timeofDay = const TimeOfDay(hour: 0, minute: 0);

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

    for (int i = 0; i < events.length; i++) {
      varDate = DateTime.parse(events[i].getDateOfEvent);

      if (scheduledSessions[
              DateTime(varDate.year, varDate.month, varDate.day)] ==
          null) {
        scheduledSessions.addAll({
          DateTime(varDate.year, varDate.month, varDate.day): [
            events[i],
          ]
        });
      } else {
        scheduledSessions[DateTime(varDate.year, varDate.month, varDate.day)]!
            .add(events[i]);
      }
    }

    getOwner();
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
    Color textColor;
    Color highLightColor;
    Color backgroundColor;

    if (provider.themeMode == ThemeMode.dark) {
      primaryColor = colorGrey;
      textColor = colorWhite;
      highLightColor = colorLightBlueTeal;
      backgroundColor = colorDarkGrey;
    } else {
      primaryColor = colorBlueTeal;
      textColor = colorDarkGrey;
      highLightColor = colorOrange;
      backgroundColor = colorWhite;
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
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: TableCalendar(
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  eventLoader: scheduledSessions.isNotEmpty
                      ? (date) => getScheduledSessions(date)
                      : (date) => printResults(date),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: highLightColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: highLightColor,
                        width: 1.0,
                      ),
                    ),
                    todayDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor,
                        width: 6.0,
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
                      color: textColor,
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
                                    child: Row(
                                      children: [
                                        Text(
                                          e.getTitle,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07),
                                        ),
                                      ],
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
                                        event: e,
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
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'For: ' +
                                  mySelectedDay.year.toString() +
                                  '-' +
                                  mySelectedDay.month.toString() +
                                  '-' +
                                  mySelectedDay.day.toString(),
                              style: const TextStyle(
                                color: colorLightGreen,
                              ),
                            ),
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                    onPressed: (() async {
                                      TimeOfDay? newTime = await showTimePicker(
                                        context: context,
                                        initialTime: timeofDay,
                                      );

                                      if (newTime == null) return;

                                      setState(() {
                                        timeofDay = newTime;
                                      });
                                    }),
                                    child: const Text('Time')),
                                
                              ],
                            )

                            // TextFormField(
                            //   controller: timeController,
                            //   decoration: const InputDecoration(
                            //       labelText: 'Meeting Time'),
                            // ),
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
                          onPressed: () async {
                            if (meetingController.text.isEmpty) {
                              return;
                            }

                            // else {
                            if (scheduledSessions[DateTime(mySelectedDay.year,
                                    mySelectedDay.month, mySelectedDay.day)] !=
                                null) {
                              // final date
                              scheduledSessions[DateTime(mySelectedDay.year,
                                      mySelectedDay.month, mySelectedDay.day)]
                                  ?.add(Event(
                                meetingController.text,
                                descriptionController.text,
                                DateTime(mySelectedDay.year,
                                        mySelectedDay.month, mySelectedDay.day)
                                    .toString(),
                                timeofDay.format(context),
                                "",
                                "",
                                "",
                                widget.globals.getUser.getId,
                              ));
                              setState(() {
                                loadScheduledSession();
                              });
                              await EventServices.createEvent(
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
                              scheduledSessions[DateTime(mySelectedDay.year,
                                  mySelectedDay.month, mySelectedDay.day)] = [
                                Event(
                                  meetingController.text,
                                  descriptionController.text,
                                  DateTime(
                                          mySelectedDay.year,
                                          mySelectedDay.month,
                                          mySelectedDay.day)
                                      .toString(),
                                  time.toString(),
                                  "",
                                  "",
                                  "",
                                  widget.globals.getUser.getId,
                                ),
                              ];
                              setState(() {
                                loadScheduledSession();
                              });
                              await EventServices.createEvent(
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
          child: const Icon(
            Icons.add,
            // size: MediaQuery.of(context).size.height * 0.,
          ),
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
      highLightColor = colorLightGrey;
    } else {
      highLightColor = colorWhite;
    }
    return TextStyle(
      // fontSize: 18,
      fontWeight: bold,
      color: highLightColor,
    );
  }
}
