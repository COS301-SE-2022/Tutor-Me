import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/services/models/event.dart';
// import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/invite_to_meeting.dart';

import '../theme/themes.dart';

class BookingCalender extends StatefulWidget {
  final Globals globals;
  const BookingCalender({Key? key, required this.globals}) : super(key: key);

  @override
  State<BookingCalender> createState() => _BookingCalenderState();
}

class _BookingCalenderState extends State<BookingCalender> {
  late Map<DateTime, List<dynamic>> scheduledSessions = {};

  List getScheduledSessions(DateTime date) {
    return scheduledSessions[date] ?? [];
  }

  void iniState() {
    scheduledSessions = {};
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
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text(
            'Available Sessions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                    : null,
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
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: highLightColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: highLightColor,
                    size: MediaQuery.of(context).size.width * 0.085,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: highLightColor,
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
                                    color: highLightColor.withOpacity(0.2)))),
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
                                      e.description,
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
                                    style: TextStyle(color: primaryColor)),
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
              builder: (context) => AlertDialog(
                    title: Text(
                      'Schedule Meeting',
                      style: TextStyle(color: textColor),
                    ),
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
                        child:  Text(
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
                                time.toString(),
                                "Me",
                                "k",
                                "",
                                ""));
                          } else {
                            scheduledSessions[mySelectedDay] = [
                              Event(
                                  meetingController.text,
                                  descriptionController.text,
                                  mySelectedDay.toString(),
                                  time.toString(),
                                  "Me",
                                  "",
                                  "",
                                  "")
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
          backgroundColor: primaryColor,
          child: const Icon(Icons.bookmark_add_outlined),
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
