import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/pages/tutee_calendar_page.dart';
// import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/upcoming.dart';
import 'package:tutor_me/src/pages/woah_factor.dart';

import '../theme/themes.dart';
import 'calendar_screen.dart';

class WeeklyReport extends StatefulWidget {
  Globals globals;
  WeeklyReport({Key? key, required this.globals}) : super(key: key);
  // WoahFactorNav({Key? key, required this.connections, required thi}) : super(key: key);

  @override
  State<WeeklyReport> createState() => _WeeklyReportState();
}

class _WeeklyReportState extends State<WeeklyReport> {
  int currentIndex = 0;

  // getScreens() {
  //   if (widget.globals.getUser.getUserTypeID[0] == '9') {
  //     return [
  //       WoahFactor(

  //       ),
  //       CalendarScreen(globals: widget.globals)
  //     ];
  //   } else {
  //     return [
  //       Upcoming(
  //         globals: widget.globals,
  //       ),
  //       TuteeCalendarScreen(globals: widget.globals)
  //     ];
  //   }
  // }

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
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color primaryColor;
    Color secondaryColor;
    Color textColor;
    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      primaryColor = const Color.fromARGB(255, 37, 36, 36);
      textColor = colorWhite;
      highLightColor = colorOrange;
      secondaryColor = const Color.fromARGB(255, 88, 88, 88);
    } else {
      primaryColor = colorBlueTeal;
      textColor = colorDarkGrey;
      highLightColor = colorOrange;
      secondaryColor = colorWhite;
    }

    // final screens = getScreens();

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
          body: Container(),
        ));
  }
}
