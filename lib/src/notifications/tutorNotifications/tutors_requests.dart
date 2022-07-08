import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/requests.dart';
import 'package:tutor_me/services/models/tutees.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/services/services/tutee_services.dart';
import 'package:tutor_me/services/services/tutor_services.dart';
import 'package:tutor_me/src/colorpallete.dart';

class TutorRequests extends StatefulWidget {
  final Tutors user;
  const TutorRequests({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorRequestsState();
  }
}

class TutorRequestsState extends State<TutorRequests> {
  List<Tutees> tuteeList = List<Tutees>.empty();
  List<Requests> requestList = List<Requests>.empty();

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isExcepting = false;
  bool isExcepted = false;
  bool isDeclining = false;
  bool isDeclined = false;

  getRequests() async {
    final requests = await TutorServices().getRequests(widget.user.getId);
    setState(() {
      requestList = requests;
    });
    getTutees();
  }

  getTutees() async {
    for (int i = 0; i < requestList.length; i++) {
      final tutee = await TuteeServices.getTutee(requestList[i].getRequesterId);
      setState(() {
        tuteeList += tutee;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (requestList.isNotEmpty) {
      return Material(
        child: SingleChildScrollView(
            child: SizedBox(
                height: screenHeight * 0.9,
                child: ListView.builder(
                  itemBuilder: _cardBuilder,
                  itemCount: requestList.length,
                ))),
      );
    }

    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.notifications_off,
              size: MediaQuery.of(context).size.height * 0.15,
              color: colorTurqoise,
            ),
            const Text('No new requests')
          ],
        ),
      ),
    );
  }

  String getRequestDate(String dateSent) {
    final lastDate = DateTime.now();
    String dateAsString = lastDate.toString();
    List<String> currentSplit = dateAsString.split(' ');
    String currentDate = currentSplit[0];
    List<String> currentDateUnits = currentDate.split('-');

    List<String> sentDateUnits = dateSent.split('/');

    String howLongAgo = '';

    int currentYear = int.parse(currentDateUnits[0]);
    int yearSent = int.parse(sentDateUnits[2]);

    int currentMonth = int.parse(currentDateUnits[1]);
    int monthSent = int.parse(sentDateUnits[1]);

    int currentDay = int.parse(currentDateUnits[2]);
    int daySent = int.parse(sentDateUnits[0]);

    if (currentYear - yearSent > 0) {
      if (currentYear - yearSent > 1) {
        howLongAgo = (currentYear - yearSent).toString() + ' years ago';
      } else {
        howLongAgo = (currentYear - yearSent).toString() + ' year ago';
      }
    } else if (currentMonth - monthSent > 0) {
      if (currentMonth - monthSent > 1) {
        howLongAgo = (currentMonth - monthSent).toString() + ' months ago';
      } else {
        howLongAgo = (currentMonth - monthSent).toString() + ' month ago';
      }
    } else if (currentDay - daySent > 1) {
      if (currentDay - daySent > 1) {
        howLongAgo = (currentMonth - monthSent).toString() + ' days ago';
      } else {
        howLongAgo = (currentMonth - monthSent).toString() + ' day ago';
      }
    } else if (currentDay - daySent == 0) {
      howLongAgo = 'Today';
    }

    return howLongAgo;
  }

  Widget _cardBuilder(BuildContext context, int i) {
    String name = tuteeList[i].getName + ' ' + tuteeList[i].getLastName;
    String howLongAgo = getRequestDate(requestList[i].getDateCreated);
    return Card(
      elevation: 0,
      color: Colors.white60,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: MediaQuery.of(context).size.aspectRatio * 70,
              backgroundImage: const AssetImage('assets/Pictures/penguin.png'),
            ),
            title: Text(name),
            subtitle: Text(
              tuteeList[i].getBio,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              howLongAgo,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              isExcepting || isDeclining
                  ? const CircularProgressIndicator.adaptive()
                  : isExcepted
                      ? Text(
                          'You have excepted this request',
                          style: TextStyle(color: Colors.grey[400]),
                        )
                      : isDeclined
                          ? Container()
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isExcepting = true;
                                });
                                await TutorServices()
                                    .acceptRequest(requestList[i].getId);

                                setState(() {
                                  isExcepting = false;
                                  isExcepted = true;
                                });
                              },
                              child: const Text("Accept"),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(colorTurqoise),
                              ),
                            ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              isDeclining || isExcepting || isExcepted
                  ? Container()
                  : isDeclined
                      ? Text(
                          'You have rejected this request',
                          style: TextStyle(color: Colors.grey[400]),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isDeclining = true;
                            });
                            await TutorServices()
                                .declineRequest(requestList[i].getId);
                            setState(() {
                              isDeclining = false;
                              isDeclined = true;
                            });
                          },
                          child: const Text("Reject"),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(colorOrange),
                          ),
                        )
            ],
          )
        ],
      ),
    );
  }
}
