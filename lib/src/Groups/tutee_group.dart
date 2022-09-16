// ignore_for_file: non_constant_identifier_names, dead_code
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/services/group_services.dart';
import 'package:tutor_me/services/models/users.dart';
import 'package:tutor_me/src/chat/one_to_one_chat.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/theme/themes.dart';
import 'package:tutor_me/src/tutorAndTuteeCollaboration/tuteeGroups/tuteeGroupSettings.dart';
import 'package:http/http.dart' as http;
import '../../screens/join_screen.dart';
import '../../services/models/globals.dart';
import '../../services/models/groups.dart';
import '../../services/models/modules.dart';
import '../../services/services/user_services.dart';
import '../../utils/toast.dart';
import '../pages/chat_page.dart';
import '../pages/recorded_videos.dart';
// import '../chat/group_chat.dart';

class Tutee {
  Users tutee;
  Uint8List image;
  bool hasImage;
  Tutee(this.tutee, this.image, this.hasImage);
}

// ignore: must_be_immutable
class TuteeGroupPage extends StatefulWidget {
  Groups group;
  final int numberOfParticipants;
  final Globals globals;
  final Modules module;
  TuteeGroupPage(
      {Key? key,
      required this.group,
      required this.numberOfParticipants,
      required this.globals,
      required this.module})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteeGroupPageState();
  }
}

class TuteeGroupPageState extends State<TuteeGroupPage> {
  late Users tutorObj;
  final tuteeListObj = <Users>[];
  String name = '';
  bool _isLoading = true;
  late Uint8List tutorImage;
  bool tutorHasImage = false;
  List<Users> tuteeList = List<Users>.empty();
  List<Tutee> tutees = List<Tutee>.empty(growable: true);
  List<Uint8List> tuteeImages = List<Uint8List>.empty(growable: true);
  List<int> hasImage = List<int>.empty(growable: true);
  bool hasOnlyOneTutee = false;
  String _token = "";

  getTutees() async {
    fetchToken().then((token) => setState(() => _token = token));
    try {
      final tutees = await GroupServices.getGroupTutees(
          widget.group.getId, widget.globals);
      setState(() {
        tuteeList = tutees;
      });
    } catch (e) {
      const snackBar = SnackBar(content: Text('Error getting tutees'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    getTuteeProfileImages();
  }

  getTuteeProfileImages() async {
    for (int i = 0; i < tuteeList.length; i++) {
      try {
        final image = await UserServices.getTuteeProfileImage(
            tuteeList[i].getId, widget.globals);
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
    });
    getTutor();
  }

  getTutor() async {
    try {
      final tutor =
          await UserServices.getTutor(widget.group.getUserId, widget.globals);

      setState(() {
        tutorObj = tutor[0];
      });
    } catch (e) {
      const snackBar = SnackBar(content: Text('Error getting tutor'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    getTutorImage();
    // getTutees();
  }

  getTutorImage() async {
    try {
      final image = await UserServices.getTutorProfileImage(
          widget.group.getUserId, widget.globals);

      setState(() {
        tutorHasImage = true;
        tutorImage = image;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        tutorHasImage = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTutees();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    Color textColor;
    Color highlightColor;
    Color primaryColor;

    if (provider.themeMode == ThemeMode.dark) {
      highlightColor = colorBlueTeal;
      textColor = colorWhite;
      primaryColor = colorOrange;
    } else {
      highlightColor = colorOrange;
      textColor = Colors.black;
      primaryColor = colorBlueTeal;
    }
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          title: Text(widget.module.getCode + '- Group'),
          backgroundColor: primaryColor,
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
                width: screenWidth * 1,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05),
                          child: Container(
                            width: screenWidth * 0.03,
                            height: screenHeight * 0.2,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/Pictures/group.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.2,
                          width: screenWidth * 0.40,
                          padding: EdgeInsets.only(
                              top: screenHeight * 0.02,
                              bottom: screenHeight * 0.02,
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(
                                    MediaQuery.of(context).size.width * 0.02),
                                topRight: Radius.circular(
                                    MediaQuery.of(context).size.width * 0.02)),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            thumbColor:
                                                MaterialStateProperty.all(
                                                    colorOrange))),
                                    child: Scrollbar(
                                      child: Text(
                                        widget.group.getDescription,
                                        style: TextStyle(
                                          color: textColor,
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
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => ChatPage(
                                        globals: widget.globals,
                                        group: widget.group,
                                        moduleCode: widget.module.getCode,
                                      )));
                            },
                            child: Card(
                              elevation: 0,
                              child: ListTile(
                                horizontalTitleGap: screenHeight * 0.04,
                                leading: Icon(
                                  Icons.chat,
                                  size: screenHeight * 0.06,
                                  color: primaryColor,
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
                            onTap: () async {
                              try {
                                final group = await GroupServices.getGroup(
                                    widget.group.getId, widget.globals);

                                setState(() {
                                  widget.group = group;
                                });
                                try {
                                  if (await validateMeeting(
                                      widget.group.getVideoId)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JoinScreen(
                                          meetingId: widget.group.getVideoId,
                                          token: _token,
                                          globals: widget.globals,
                                          group: widget.group,
                                        ),
                                      ),
                                    );
                                  } else {
                                    toastMsg("Invalid Meeting ID");
                                  }
                                } catch (e) {
                                  const snackBar = SnackBar(
                                    content: Text('Failed to join live video'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              } catch (e) {
                                const snackBar = SnackBar(
                                  content: Text('Failed to join live video'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: ListTile(
                                horizontalTitleGap: screenHeight * 0.04,
                                leading: Stack(children: [
                                  Icon(
                                    Icons.chat_bubble,
                                    size: screenHeight * 0.06,
                                    color: primaryColor,
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
                                  'Join live video call',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const RecordedVideos()));
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: ListTile(
                                horizontalTitleGap: screenHeight * 0.04,
                                leading: Stack(children: [
                                  Icon(
                                    Icons.chat_bubble,
                                    size: screenHeight * 0.06,
                                    color: primaryColor,
                                  ),
                                  Positioned(
                                      top: screenHeight * 0.01,
                                      left: screenWidth * 0.014,
                                      child: const Icon(
                                        Icons.video_library,
                                        color: colorWhite,
                                      ))
                                ]),
                                title: Text(
                                  'Recorded Meetings',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: screenHeight * 0.05,
                    // ),
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
                      height: screenHeight * 0.14,
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
                                    color: highlightColor,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.06),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: screenHeight * 0.3,
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
                                itemCount: tutees.length),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget tutorBuilder(BuildContext context, int i) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color primaryColor;

    if (provider.themeMode == ThemeMode.dark) {
      primaryColor = colorGrey;
    } else {
      primaryColor = colorBlueTeal;
    }
    //getTutees
    String name = tutorObj.getName + ' ' + tutorObj.getLastName;
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Chat(
                    reciever: tutorObj,
                    globals: widget.globals,
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
                tutorObj.getBio,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: colorBlueTeal),
              ),
              trailing: Icon(
                Icons.chat_bubble,
                size: MediaQuery.of(context).size.aspectRatio * 80,
                color: primaryColor,
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
                    globals: widget.globals,
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
                tutees[i].tutee.getBio,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: colorBlueTeal),
              ),
              trailing: Icon(
                Icons.chat_bubble,
                size: MediaQuery.of(context).size.aspectRatio * 80,
                color: colorBlueTeal,
              ),
            )));
  }

  Future<String> fetchToken() async {
    final String? _AUTH_URL = dotenv.env['AUTH_URL'];
    String? _AUTH_TOKEN = dotenv.env['AUTH_TOKEN'];

    if ((_AUTH_TOKEN?.isEmpty ?? true) && (_AUTH_URL?.isEmpty ?? true)) {
      toastMsg("Please set the environment variables");
      throw Exception("Either AUTH_TOKEN or AUTH_URL is not set in .env file");
      return "";
    }

    if ((_AUTH_TOKEN?.isNotEmpty ?? false) &&
        (_AUTH_URL?.isNotEmpty ?? false)) {
      toastMsg("Please set only one environment variable");
      throw Exception("Either AUTH_TOKEN or AUTH_URL can be set in .env file");
      return "";
    }

    if (_AUTH_URL?.isNotEmpty ?? false) {
      final Uri getTokenUrl = Uri.parse('$_AUTH_URL/get-token');
      final http.Response tokenResponse = await http.get(getTokenUrl);
      _AUTH_TOKEN = json.decode(tokenResponse.body)['token'];
    }

    log("Auth Token: $_AUTH_TOKEN");

    return _AUTH_TOKEN ?? "";
  }

  Future<bool> validateMeeting(String _meetingId) async {
    final String? _VIDEOSDK_API_ENDPOINT = dotenv.env['VIDEOSDK_API_ENDPOINT'];

    final Uri validateMeetingUrl =
        Uri.parse('$_VIDEOSDK_API_ENDPOINT/meetings/$_meetingId');
    final http.Response validateMeetingResponse =
        await http.post(validateMeetingUrl, headers: {
      "Authorization": _token,
    });

    return validateMeetingResponse.statusCode == 200;
  }
}
