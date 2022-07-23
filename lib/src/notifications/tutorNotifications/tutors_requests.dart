import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/requests.dart';
import 'package:tutor_me/services/models/tutees.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/services/services/group_services.dart';
import 'package:tutor_me/services/services/tutee_services.dart';
import 'package:tutor_me/services/services/tutor_services.dart';
import 'package:tutor_me/src/colorpallete.dart';

import '../../../services/models/groups.dart';

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

  List<bool> isExcepting = List<bool>.empty();
  List<bool> isExcepted = List<bool>.empty();
  List<bool> isDeclining = List<bool>.empty();
  List<bool> isDeclined = List<bool>.empty();
  bool isLoading = true;

  getRequests() async {
    final requests = await TutorServices().getRequests(widget.user.getId);
    requestList = requests;
    if (requestList.isEmpty) {
      setState(() {
        isLoading = false;
      });
    }
    getTutees();
  }

  getTutees() async {
    for (int i = 0; i < requestList.length; i++) {
      final tutee = await TuteeServices.getTutee(requestList[i].getRequesterId);
      tuteeList += tutee;
    }
    int requestLength = tuteeList.length;
    setState(() {
      isExcepting = List<bool>.filled(requestLength, false);
      isExcepted = List<bool>.filled(requestLength, false);
      isDeclining = List<bool>.filled(requestLength, false);
      isDeclined = List<bool>.filled(requestLength, false);
      tuteeList = tuteeList;
      isLoading = false;
    });
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

    return Material(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : requestList.isNotEmpty
              ? SingleChildScrollView(
                  child: SizedBox(
                      height: screenHeight * 0.9,
                      child: ListView.builder(
                        itemBuilder: _cardBuilder,
                        itemCount: requestList.length,
                      )))
              : Center(
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
    List<String> moduleList = requestList[i].getModuleCode.split(',');
    String modules = '';
    for (int i = 0; i < moduleList.length; i++) {
      modules += moduleList[i] + '\n';
    }
    return Column(
      children: <Widget>[
        Card(
          elevation: 0,
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  radius: MediaQuery.of(context).size.aspectRatio * 70,
                  backgroundImage:
                      const AssetImage('assets/Pictures/penguin.png'),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Tooltip(
                    message: modules,
                    showDuration: const Duration(seconds: 4),
                    preferBelow: false,
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.01),
                    triggerMode: TooltipTriggerMode.tap,
                    child: const Text(
                      'View modules',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: colorTurqoise),
                    ),
                  ),
                  isExcepting[i] || isDeclining[i]
                      ? const CircularProgressIndicator.adaptive()
                      : isExcepted[i]
                          ? Text(
                              'You have excepted this request',
                              style: TextStyle(color: Colors.grey[400]),
                            )
                          : isDeclined[i]
                              ? Container()
                              : ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isExcepting[i] = true;
                                    });

                                    try {
                                      await TutorServices()
                                          .acceptRequest(requestList[i].getId);

                                      List<Groups> groupList =
                                          List<Groups>.empty();

                                      final groups =
                                          await GroupServices.getGroupByUserID(
                                              widget.user.getId, 'tutor');

                                      groupList = groups;

                                      List<Groups> moduleRequestedGroups =
                                          List<Groups>.empty(growable: true);

                                      List<String> modules = requestList[i]
                                          .getModuleCode
                                          .split(',');

                                      for (int j = 0;
                                          j < groupList.length;
                                          j++) {
                                        for (int k = 0;
                                            k < modules.length;
                                            k++) {
                                          if (groupList[j]
                                              .getModuleCode
                                              .contains(modules[k])) {
                                            moduleRequestedGroups
                                                .add(groupList[j]);
                                          }
                                        }
                                      }

                                      for (int j = 0;
                                          j < moduleRequestedGroups.length;
                                          j++) {
                                        String tutees =
                                            moduleRequestedGroups[j].getTutees;

                                        tutees +=
                                            ',' + requestList[i].getRequesterId;

                                        moduleRequestedGroups[j].setTutees =
                                            tutees;
                                        await GroupServices.updateGroup(
                                            moduleRequestedGroups[j]);
                                      }
                                      setState(() {
                                        isExcepting[i] = false;
                                        isExcepted[i] = true;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        isExcepting[i] = false;
                                        isExcepted[i] = false;
                                      });
                                      const snackBar = SnackBar(
                                        content: Text('Failed to accept'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: const Text("Accept"),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        colorTurqoise),
                                  ),
                                ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  isDeclining[i] || isExcepting[i] || isExcepted[i]
                      ? Container()
                      : isDeclined[i]
                          ? Text(
                              'You have rejected this request',
                              style: TextStyle(color: Colors.grey[400]),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isDeclining[i] = true;
                                });
                                await TutorServices()
                                    .declineRequest(requestList[i].getId);
                                setState(() {
                                  isDeclining[i] = false;
                                  isDeclined[i] = true;
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
        ),
        const Divider()
      ],
    );
  }
}
