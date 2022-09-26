import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/services/user_services.dart';
import 'package:tutor_me/src/chat/booking_chat.dart';
import 'package:tutor_me/src/colorpallete.dart';
// import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/tutor_explore.dart';

import '../../services/models/event.dart';
import '../../services/models/globals.dart';
import '../../services/models/users.dart';
import '../../services/services/events_services.dart';
import '../theme/themes.dart';

class BookForTutor extends StatefulWidget {
  final Globals globals;
  const BookForTutor({Key? key, required this.globals}) : super(key: key);

  @override
  State<BookForTutor> createState() => _BookForTutorState();
}

class _BookForTutorState extends State<BookForTutor> {
  List<Event> events = List<Event>.empty(growable: true);
  List<Users> tutors = List<Users>.empty(growable: true);
  bool isLoading = true;

  getUserEvents() async {
    try {
      final incomingEvents = await EventServices.getEventsByUserId(
          widget.globals.getUser.getId, widget.globals);
      events = incomingEvents;

      if (widget.globals.getUser.getUserTypeID[0] == '9') {
        events.removeWhere(
            (event) => event.getOwnerId == widget.globals.getUser.getId);
      }
    } catch (e) {
      
      const snack = SnackBar(content: Text('Error loading events'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }

    getTutors();
  }

  getTutors() async {
    try {
      log('heree ' + events.length.toString());
      for (int i = 0; i < events.length; i++) {
        final incomingTutors =
            await UserServices.getTutor(events[i].getUserId, widget.globals);
        tutors.add(incomingTutors);
      }
    } catch (e) {
      const snack = SnackBar(content: Text('Error loading tutors'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }

    setState(() {
      isLoading = false;
    });
    log('heree ' + events.length.toString());
  }

  @override
  void initState() {
    super.initState();
    getUserEvents();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color primaryColor;
    Color textColor;
    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      primaryColor = colorGrey;
      textColor = colorWhite;
      highLightColor = colorLightBlueTeal;
    } else {
      primaryColor = colorBlueTeal;
      textColor = colorDarkGrey;
      highLightColor = colorOrange;
    }

    double widthOfScreen = MediaQuery.of(context).size.width;
    double heightOfScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book for Tutor"),
        backgroundColor: primaryColor,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(children: [
              SizedBox(
                height: heightOfScreen * 0.02,
              ),
              Center(
                child: Container(
                  width: widthOfScreen * 0.9,
                  height: heightOfScreen * 0.4,
                  decoration: BoxDecoration(
                    color: colorLightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: widthOfScreen * 0.08,
                        height: heightOfScreen * 0.4,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/Pictures/profileBackground.jpg"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: widthOfScreen * 0.05,
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: heightOfScreen * 0.02,
                          ),
                          Center(
                            child: Text(
                              "Booked Upcoming apointments: ",
                              style: TextStyle(
                                fontSize: widthOfScreen * 0.05,
                                fontWeight: FontWeight.bold,
                                color: highLightColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: heightOfScreen * 0.01,
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
                            height: heightOfScreen * 0.01,
                          ),
                          events.isEmpty
                              ? Center(
                                  child: Text(
                                    "You have no upcoming appointments",
                                    style: TextStyle(
                                      fontSize: widthOfScreen * 0.04,
                                      fontWeight: FontWeight.w300,
                                      color: highLightColor,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: heightOfScreen * 0.3,
                                  width: widthOfScreen * 0.7,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.023),
                                      itemBuilder: buildAppointments,
                                      itemCount: events.length,
                                    ),
                                  )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: heightOfScreen * 0.06,
              ),
              SizedBox(
                width: widthOfScreen * 0.9,
                height: heightOfScreen * 0.08,
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: widthOfScreen * 0.08, color: highLightColor),
                    Flexible(
                      child: Text(
                          "Explore the available tutors and book for One time sessions.",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: widthOfScreen * 0.05,
                            fontWeight: FontWeight.normal,
                            color: textColor,
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    bottom: MediaQuery.of(context).size.height * 0.02),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "moreInfo",
                    style: TextStyle(
                      fontSize: widthOfScreen * 0.05,
                      fontWeight: FontWeight.normal,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TutorExplore(
                                  globals: widget.globals,
                                )),
                      );
                    },
                    child: Container(
                      width: widthOfScreen * 0.6,
                      height: heightOfScreen * 0.065,
                      decoration: BoxDecoration(
                        color: colorOrange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "  Explore",
                          style: TextStyle(
                            fontSize: widthOfScreen * 0.05,
                            fontWeight: FontWeight.bold,
                            color: colorWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]),
    );
  }

  Widget buildAppointments(BuildContext context, int i) {
    String date = events[i].getDateOfEvent.split(' ')[0];
    Uint8List image = Uint8List(128);
    return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookingChat(
                      reciever: tutors[i],
                      globals: widget.globals,
                      image: image,
                      hasImage: false,
                      event: events[i],
                    )),
          );
        },
        child: Text(
          '•' +
              tutors[i].getName +
              " " +
              tutors[i].getLastName +
              ", " +
              date +
              " " +
              events[i].getTimeOfEvent,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.02,
            fontWeight: FontWeight.w300,
            // color: colorBlueTeal,
          ),
        ));
  }
}
