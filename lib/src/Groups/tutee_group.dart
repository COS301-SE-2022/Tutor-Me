import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutees.dart';
import 'package:tutor_me/services/services/tutor_services.dart';
import 'package:tutor_me/src/chat/one_to_one_chat.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tutorAndTuteeCollaboration/tuteeGroups/tuteeGroupSettings.dart';

import '../../services/models/groups.dart';
import '../../services/models/tutors.dart';
import '../../services/services/tutee_services.dart';
import '../chat/group_chat.dart';

class Tutee {
  Tutees tutee;
  Uint8List image;
  bool hasImage;
  Tutee(this.tutee, this.image, this.hasImage);
}

class TuteeGroupPage extends StatefulWidget {
  
  final Groups group;
  final int numberOfParticipants;
  final dynamic tutee;
  const TuteeGroupPage(
      {Key? key,
      required this.group,
      required this.numberOfParticipants,
      required this.tutee})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteeGroupPageState();
  }
}

class TuteeGroupPageState extends State<TuteeGroupPage> {
  late Tutors tutorObj;
  final tuteeListObj = <Tutees>[];
  String name = '';
  bool _isLoading = true;
  late Uint8List tutorImage;
  bool tutorHasImage = false;
  List<Tutees> tuteeList = List<Tutees>.empty();
  List<Tutee> tutees = List<Tutee>.empty(growable: true);
  List<Uint8List> tuteeImages = List<Uint8List>.empty(growable: true);
  List<int> hasImage = List<int>.empty(growable: true);
  bool hasOnlyOneTutee = false;

  getTutees() async {
    try {
      if (widget.numberOfParticipants == 1) {
        hasOnlyOneTutee = true;
      }

      List<String> tuteeIds = widget.group.getTutees.split(',');
      int tuteeIndex = tuteeIds.indexOf(widget.tutee.getId);

      tuteeIds.removeAt(tuteeIndex);

      for (int i = 0; i < tuteeIds.length; i++) {
        final tutee = await TuteeServices.getTutee(tuteeIds[i]);
        tuteeList += tutee;
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Failed to load tutees'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    getTuteeProfileImages();
  }

  getTuteeProfileImages() async {
    for (int i = 0; i < tuteeList.length; i++) {
      try {
        final image =
            await TuteeServices.getTuteeProfileImage(tuteeList[i].getId);
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
      bool val = true;
      for (int j = 0; j < hasImage.length; j++) {
        if (hasImage[j] == i) {
          val = false;
          break;
        }
      }
      if (!val) {
        tutees.add(Tutee(tuteeList[i], tuteeImages[i], false));
      } else {
        tutees.add(Tutee(tuteeList[i], tuteeImages[i], true));
      }
    }
    setState(() {
      tutees = tutees;
      _isLoading = false;
    });
  }

  getTutor() async {
    final tutor = await TutorServices.getTutor(widget.group.getTutorId);

    setState(() {
      tutorObj = tutor[0];
    });
    getTutorImage();
    getTutees();
  }

  getTutorImage() async {
    try {
      final image =
          await TutorServices.getTutorProfileImage(widget.group.getTutorId);

      setState(() {
        tutorHasImage = true;
        tutorImage = image;
      });
    } catch (e) {
      setState(() {
        tutorHasImage = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTutor();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          title: Text(widget.group.getModuleCode + '- Group'),
          backgroundColor: colorOrange,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TuteeGroupsSettings()));
                },
                icon: const Icon(Icons.settings))
          ],
          centerTitle: true,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SingleChildScrollView(
              child: SizedBox(
                height: screenHeight * 0.9,
                width: screenWidth * 0.9,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Container(
                      color: Colors.grey.withOpacity(0.2),
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.42,
                      padding: EdgeInsets.only(
                          top: screenHeight * 0.02,
                          bottom: screenHeight * 0.02,
                          left: screenWidth * 0.02,
                          right: screenWidth * 0.02),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Group Header:',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: screenHeight * 0.03,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Flexible(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    scrollbarTheme: ScrollbarThemeData(
                                        thumbColor: MaterialStateProperty.all(
                                            colorTurqoise))),
                                child: Scrollbar(
                                  child: Text(
                                    widget.group.getDescription,
                                    style: const TextStyle(
                                      color: colorBlack,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    SizedBox(
                      height: screenHeight * 0.24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => GroupChat(
                                      user: widget.tutee,
                                      group: widget.group)));
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: ListTile(
                                horizontalTitleGap: screenHeight * 0.04,
                                leading: Icon(
                                  Icons.chat,
                                  size: screenHeight * 0.06,
                                  color: colorOrange,
                                ),
                                title: Text(
                                  'Group Chat',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                ),
                                subtitle: const Text('2 new msgs!'),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: ListTile(
                                horizontalTitleGap: screenHeight * 0.04,
                                leading: Stack(children: [
                                  Icon(
                                    Icons.chat_bubble,
                                    size: screenHeight * 0.06,
                                    color: colorOrange,
                                  ),
                                  Positioned(
                                      top: screenHeight * 0.01,
                                      left: screenWidth * 0.014,
                                      child: const Icon(
                                        Icons.video_camera_front,
                                        color: colorWhite,
                                      ))
                                ]),
                                title: Text(
                                  'Start Live Video Call',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: screenHeight * 0.05,
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.5,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: Text(
                          'Tutor:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.12,
                      width: screenWidth * 0.5,
                      child: ListView.separated(
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: tutorBuilder,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: screenHeight * 0.0001,
                            );
                          },
                          itemCount: 1),
                    ),
                    SizedBox(
                      width: screenWidth * 0.5,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: Text(
                          'Tutees:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    hasOnlyOneTutee
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.08,
                            ),
                            child: Center(
                              child: Text(
                                "No other Tutees in this group",
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.06),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: screenHeight * 0.2,
                            width: screenWidth * 0.5,
                            child: ListView.separated(
                                controller: ScrollController(),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: participantBuilder,
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: screenHeight * 0.0001,
                                  );
                                },
                                itemCount: widget.numberOfParticipants),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget tutorBuilder(BuildContext context, int i) {
    //getTutees
    String name = tutorObj.getName + ' ' + tutorObj.getLastName;
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Chat(
                  reciever: tutorObj,
                    user: widget.tutee,
                    image: tutorImage,
                    hasImage: tutorHasImage,
                  )));

        },
        child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: ListTile(
              leading: CircleAvatar(
                  child: tutorHasImage
                      ? ClipOval(
                          child: Image.memory(
                            tutorImage,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.18,
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            'assets/Pictures/penguin.png',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.18,
                          ),
                        ),
                  radius: MediaQuery.of(context).size.aspectRatio * 50),
              title: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
              subtitle: Text(
                tutorObj.getCourse,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: colorOrange),
              ),
              trailing: Icon(
                Icons.chat_bubble,
                size: MediaQuery.of(context).size.aspectRatio * 80,
                color: colorOrange,
              ),
            )));
  }

  Widget participantBuilder(BuildContext context, int i) {
    //getTutees
    String name = tutees[i].tutee.getName + ' ' + tutees[i].tutee.getLastName;
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Chat(
                    reciever: tutees[i].tutee,
                    user: tutees[i].tutee,
                    image: tutees[i].image,
                    hasImage: tutees[i].hasImage,
                  )));
        },
        child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: ListTile(
              leading: CircleAvatar(
                  child: tutees[i].hasImage
                      ? ClipOval(
                          child: Image.memory(
                            tutees[i].image,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.18,
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            'assets/Pictures/penguin.png',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.18,
                          ),
                        ),
                  radius: MediaQuery.of(context).size.aspectRatio * 50),
              title: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
              subtitle: Text(
                tutees[i].tutee.getCourse,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: colorOrange),
              ),
              trailing: Icon(
                Icons.chat_bubble,
                size: MediaQuery.of(context).size.aspectRatio * 80,
                color: colorOrange,
              ),
            )));
  }
}
