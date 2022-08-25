

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/pages/badges.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // late CalendarController _controller;
  @override
  void iniState() {
    super.initState();
    // _controller = CalendarController();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  CalendarFormat format = CalendarFormat.month;
  DateTime mySelectedDay = DateTime.now();
  DateTime myFocusedDay = DateTime.now();

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
      body:Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TableCalendar( 
                startingDayOfWeek: StartingDayOfWeek.sunday,
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
                onFormatChanged: (CalendarFormat format){
                  setState(() {
                    format = format;
                  });
                },
                onDaySelected: (DateTime day,DateTime fday) {
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
                  titleTextStyle:const  TextStyle(
                    color: colorTurqoise,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: colorTurqoise,
                    size: MediaQuery.of(context).size.width * 0.085,
                  ),rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: colorTurqoise,
                    size: MediaQuery.of(context).size.width * 0.085,
                  ),
                ),
                ),
            ],
          ),
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
      color: colorTurqoise,
      
    );
  }

    
  

}