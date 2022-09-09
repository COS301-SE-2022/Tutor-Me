import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutor_me/src/colorpallete.dart';
// import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/upcoming.dart';

import 'calendar_screen.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int currentIndex = 0;

  getScreens() {
    return [const Upcoming(), const CalendarScreen()];
  }
  // late CalendarController _controller;

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
    final screens = getScreens();

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
            // backgroundColor: const Color(0xffD6521B),
            centerTitle: true,
            title: const Text('Calendar'),
            backgroundColor: colorOrange,
            // flexibleSpace: Container(
            //   decoration: const BoxDecoration(
            //       // borderRadius:
            //       //     BorderRadius.vertical(bottom: Radius.circular(60)),
            //       gradient: LinearGradient(
            //           colors: <Color>[Colors.orange, Colors.red],
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter)),
            // ),

            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: Container(
                height: 50.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 235, 231, 231),
                ),
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  indicatorColor: colorTurqoise,
                  unselectedLabelColor: colorGrey,
                  labelColor: colorTurqoise,
                  unselectedLabelStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.upcoming,
                        size: MediaQuery.of(context).size.width * 0.06,
                      ),
                      text: 'Upcoming',
                      // child: Text("gjgjgj"),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        size: MediaQuery.of(context).size.width * 0.06,
                      ),
                      text: 'Calendar',
                      // child: Text("gjgjgjlkjh"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: screens[currentIndex],
        ));
  }
}
