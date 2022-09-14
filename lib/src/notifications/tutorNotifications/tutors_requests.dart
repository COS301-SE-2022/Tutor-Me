import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/services/models/modules.dart';
import 'package:tutor_me/services/models/requests.dart';
import 'package:tutor_me/services/services/module_services.dart';
import 'package:tutor_me/services/services/user_services.dart';
// import 'package:tutor_me/services/services/tutor_services.dart';
import 'package:tutor_me/src/colorpallete.dart';

import '../../../services/models/users.dart';

class Tutee {
  Users tutee;
  Uint8List image;
  bool hasImage;
  Modules module;
  Tutee(this.tutee, this.image, this.hasImage, this.module);
}

class TutorRequests extends StatefulWidget {
  final Globals globals;
  const TutorRequests({Key? key, required this.globals}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorRequestsState();
  }
}

class TutorRequestsState extends State<TutorRequests> {
  List<Users> tuteeList = List<Users>.empty();
  List<Tutee> tutees = List<Tutee>.empty(growable: true);
  List<Requests> requestList = List<Requests>.empty();
  List<Uint8List> tuteeImages = List<Uint8List>.empty(growable: true);
  List<int> hasImage = List<int>.empty(growable: true);
  List<Modules> modules = List<Modules>.empty(growable: true);

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  List<bool> isExcepting = List<bool>.empty();
  List<bool> isExcepted = List<bool>.empty();
  List<bool> isDeclining = List<bool>.empty();
  List<bool> isDeclined = List<bool>.empty();
  bool isLoading = true;

  getRequests() async {
    try {
      final requests = await UserServices().getTutorRequests(widget.globals.getUser.getId, widget.globals);
      requestList = requests;
      if (requestList.isEmpty) {
        setState(() {
          isLoading = false;
        });
      }
      getTutees();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  getTutees() async {
    for (int i = 0; i < requestList.length; i++) {
      final tutee = await UserServices.getTutee(requestList[i].getTuteeId, widget.globals);
      tuteeList += tutee;
    }
    int requestLength = tuteeList.length;
    setState(() {
      isExcepting = List<bool>.filled(requestLength, false);
      isExcepted = List<bool>.filled(requestLength, false);
      isDeclining = List<bool>.filled(requestLength, false);
      isDeclined = List<bool>.filled(requestLength, false);
      tuteeList = tuteeList;
    });
    getTuteeModules();
  }

  getTuteeModules() async {
    try {
      for (int i = 0; i < requestList.length; i++) {
        final module =
            await ModuleServices.getModule(requestList[i].getModuleId, widget.globals);
        setState(() {
          modules.add(module);
        });
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Failed to load'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    getTuteeProfileImages();
  }

  getTuteeProfileImages() async {
    for (int i = 0; i < tuteeList.length; i++) {
      try {
        final image =
            await UserServices.getTuteeProfileImage(tuteeList[i].getId, widget.globals);
        setState(() {
          tuteeImages.add(image);
        });
      } catch (e) {
        final byte = Uint8List(128);
        tuteeImages.add(byte);
        hasImage.add(i);
      }
    }
    for (int i = 0; i < tuteeList.length; i++) {
      setState(() {
        bool val = true;
        for (int j = 0; j < hasImage.length; j++) {
          if (hasImage[j] == i) {
            val = false;
            break;
          }
        }
        if (!val) {
          tutees.add(Tutee(tuteeList[i], tuteeImages[i], false, modules[i]));
        } else {
          tutees.add(Tutee(tuteeList[i], tuteeImages[i], true, modules[i]));
        }
      });
    }
    setState(() {
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
                      height: screenHeight * 0.8,
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
                        color: colorOrange,
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
    } else if (currentDay - daySent >= 1) {
      if (currentDay - daySent > 1) {
        howLongAgo = (currentDay - daySent).toString() + ' days ago';
      } else {
        howLongAgo = (currentDay - daySent).toString() + ' day ago';
      }
    } else if (currentDay - daySent == 0) {
      howLongAgo = 'Today';
    }

    return howLongAgo;
  }

  Widget _cardBuilder(BuildContext context, int i) {
    String name = tuteeList[i].getName + ' ' + tuteeList[i].getLastName;
    String howLongAgo = getRequestDate(requestList[i].getDateCreated);

    String module = tutees[i].module.getCode;

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
                  child: tutees[i].hasImage
                      ? ClipOval(
                          child: Image.memory(
                            tutees[i].image,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                          "assets/Pictures/penguin.png",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                        )),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Tooltip(
                    message: module,
                    showDuration: const Duration(seconds: 4),
                    preferBelow: false,
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.01),
                    triggerMode: TooltipTriggerMode.tap,
                    child: const Text(
                      'View module',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: colorOrange),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  isExcepting[i] || isDeclining[i]
                      ? const CircularProgressIndicator.adaptive()
                      : isExcepted[i]
                          ? Text(
                              'You have accepted this request',
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
                                      // Groups moduleRequestedGroup;

                                      // final group =
                                      //     await GroupServices.getGroupByUserID(
                                      //         widget.user.getId);
                                      // moduleRequestedGroup = group;
                                      // await GroupServices.updateGroup(
                                      //     moduleRequestedGroup);

                                      await UserServices()
                                          .acceptRequest(requestList[i].getId, widget.globals);

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
                                    backgroundColor:
                                        MaterialStateProperty.all(colorOrange),
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
                                try {
                                  await UserServices()
                                      .declineRequest(requestList[i].getId,widget.globals);

                                  setState(() {
                                    isDeclining[i] = false;
                                    isDeclined[i] = true;
                                  });
                                } catch (e) {
                                  const snackBar = SnackBar(
                                    content: Text('Failed to decline'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: const Text("Reject"),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(colorBlueTeal),
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
