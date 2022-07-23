import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/tutor_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tutorAndTuteeCollaboration/tuteeGroups/tuteeGroupSettings.dart';

import '../../services/models/groups.dart';
import '../../services/models/tutors.dart';

class TuteeGroupPage extends StatefulWidget {
  final Groups group;
  final int numberOfParticipants;
  const TuteeGroupPage(
      {Key? key, required this.group, required this.numberOfParticipants})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteeGroupPageState();
  }
}

class TuteeGroupPageState extends State<TuteeGroupPage> {
  late Tutors tutorObj;
  String name = '';
  bool _isLoading = true;
  late Uint8List tutorImage;
  bool tutorHasImage = false;

  getTutor() async {
    final tutor = await TutorServices.getTutor(widget.group.getTutorId);

    setState(() {
      tutorObj = tutor[0];
    });
    getTutorImage();
  }

  getTutorImage() async {
    try {
      final image =
          await TutorServices.getTutorProfileImage(widget.group.getTutorId);

      setState(() {
        tutorHasImage = true;
        tutorImage = image;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        tutorHasImage = false;
        _isLoading = false;
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
                      height: screenHeight * 0.01,
                    ),
                    SizedBox(
                      height: screenHeight * 0.24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {},
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
                          'Paticipants:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.382,
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

  Widget participantBuilder(BuildContext context, int i) {
    //getTutees
    String name = tutorObj.getName + ' ' + tutorObj.getLastName;
    return InkWell(
        onTap: () {},
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
}
