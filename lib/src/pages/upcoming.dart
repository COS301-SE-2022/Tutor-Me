// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/services/user_services.dart';
import 'package:tutor_me/src/colorpallete.dart';

import '../../services/models/event.dart';
import '../../services/models/globals.dart';
import '../../services/models/users.dart';
import '../../services/services/events_services.dart';
import '../theme/themes.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';

class Upcoming extends StatefulWidget {
  final Globals globals;
  const Upcoming({Key? key, required this.globals}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UpcomingState();
  }
}

class UpcomingState extends State<Upcoming> {
  List<Event> events = List<Event>.empty(growable: true);
  bool isLoading = true;
  List<Users> owner = List<Users>.empty(growable: true);

  List<Color> colors = [
    const Color.fromARGB(255, 243, 109, 0),
    const Color.fromARGB(255, 12, 123, 214),
    const Color.fromARGB(255, 106, 155, 42),
    const Color.fromARGB(255, 255, 230, 0),
  ];

  Color getRandomColor() {
    int x = Random().nextInt(colors.length);
    return colors[x];
  }

  getUserEvents() async {
    try {
      final incomingEvents = await EventServices.getEventsByUserId(
          widget.globals.getUser.getId, widget.globals);
      events = incomingEvents;
      List<int> indecies = List<int>.empty(growable: true);
      if (widget.globals.getUser.getUserTypeID[0] == '7') {
        events.removeWhere(
            (event) => event.getOwnerId == widget.globals.getUser.getId);
      }
    } catch (e) {
      const snack = SnackBar(content: Text('Error loading events'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }

    getOwner();
  }

  getOwner() async {
    try {
      if (events.isNotEmpty) {
        for (int i = 0; i < events.length; i++) {
          final incomingOwner =
              await UserServices.getUser(events[i].getOwnerId, widget.globals);
          owner += incomingOwner;
        }
      }
    } catch (e) {
      const snack = SnackBar(content: Text('Error loading owners'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    setState(() {
      isLoading = false;
    });
    // deleteEvets();
  }

  deleteEvets() async {
    try {
      for (int i = 0; i < events.length; i++) {
        // print('hereeeeeeeeeeeeeeeeeee');
        await EventServices.deleteEventEventId(
            events[i].getEventId, widget.globals);
      }
    } catch (e) {
      const snack = SnackBar(content: Text('Error deletng events'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (events.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    // padding: const EdgeInsets.all(10),
                    itemCount: events.length,
                    itemBuilder: _cardBuilder,
                  ),
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.update_disabled_sharp,
                          size: MediaQuery.of(context).size.height * 0.08,
                          color: Colors.grey),
                      Text(
                        'No Upcoming Events',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  Widget _cardBuilder(BuildContext context, int i) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    // Color appBarColor1;
    // Color appBarColor2;
    Color textColor;
    Color cardBackground;

    if (provider.themeMode == ThemeMode.dark) {
      textColor = colorWhite;
      cardBackground = const Color.fromARGB(255, 146, 143, 143);
    } else {
      textColor = colorBlack;
      cardBackground = colorWhite;
    }
    if (events == null) {
      return const Center(
        child: Text('No events found',
            style: TextStyle(fontSize: 20, color: Colors.black)),
      );
    }
    {
      return GestureDetector(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.155,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.155,
                    width: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      color: getRandomColor(),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        children: [
                          Text(
                            events[i].getTitle,
                            style: TextStyle(
                              color: colorBlack,
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.022,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.001,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 36, 35, 35)
                              .withOpacity(0.2),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text("Date: " + events[i].getDateOfEvent,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.018,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text("Time: " + events[i].getTimeOfEvent,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.018,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(children: <Widget>[
                        Text(
                          "Created by - Tutor: ",
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.018,
                          ),
                        ),
                        Text(
                          owner[i].getName + " " + owner[i].getLastName,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.018,
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
