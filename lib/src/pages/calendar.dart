import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/models/event.dart';
import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/inviteToMeeting.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // late CalendarController _controller;

  late Map<DateTime, List<dynamic>> scheduledSessions = {};

  List getScheduledSessions(DateTime date) {
    return scheduledSessions[date] ?? [];
  }

  @override
  void iniState() {
    scheduledSessions = {};
    super.initState();
    // _controller = CalendarController();
  }

  CalendarFormat format = CalendarFormat.month;
  DateTime mySelectedDay = DateTime.now();
  DateTime myFocusedDay = DateTime.now();

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
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color(0xffD6521B),
        centerTitle: true,
        title: const Text('Calendar'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              // borderRadius:
              //     BorderRadius.vertical(bottom: Radius.circular(60)),
              gradient: LinearGradient(
                  colors: <Color>[Colors.orange, Colors.red],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                      color: colorOrange,
                      width: 1.0,
                    ),
                  ),
                  todayDecoration: BoxDecoration(
                    color: colorOrange,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorOrange,
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
                    color: colorTurqoise,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: colorTurqoise,
                    size: MediaQuery.of(context).size.width * 0.085,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: colorTurqoise,
                    size: MediaQuery.of(context).size.width * 0.085,
                  ),
                ),
              ),
              ...getScheduledSessions(mySelectedDay).map((e) => ListTile(
                    title: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.0,
                                    color: colorTurqoise.withOpacity(0.2)))),
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
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      e.title,
                                      style: TextStyle(
                                          color: colorOrange,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      e.description,
                                      style: TextStyle(
                                          color: colorTurqoise,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Schedule Meeting'),
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: meetingController,
                          decoration:
                              InputDecoration(labelText: 'Meeting Title'),
                        ),
                        TextFormField(
                          controller: descriptionController,
                          decoration:
                              InputDecoration(labelText: 'Meeting Description'),
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
                              description: descriptionController.text));
                        } else {
                          scheduledSessions[mySelectedDay] = [
                            Event(
                                title: meetingController.text,
                                description: descriptionController.text)
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
      color: colorTurqoise,
    );
  }
}
