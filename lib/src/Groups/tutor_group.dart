// ignore_for_file: non_constant_identifier_names, dead_code
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/services/models/user_badges.dart';
import 'package:tutor_me/services/services/group_services.dart';
import 'package:tutor_me/src/Groups/add_tutees.dart';
import 'package:tutor_me/services/services/user_badges.dart';
// import 'package:tutor_me/src/chat/group_chat.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../services/models/badges.dart';
import '../../services/models/modules.dart';
import '../pages/chat_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../screens/meeting_screen.dart';
import '../../services/models/groups.dart';
// import '../../services/models/tutees.dart';
import '../../services/models/users.dart';
import '../../services/services/user_services.dart';
import '../../utils/toast.dart';
import '../chat/one_to_one_chat.dart';
import 'package:http/http.dart' as http;

import '../pages/recorded_videos.dart';
import '../theme/themes.dart';

class Tutee {
  Users tutee;
  Uint8List image;
  bool hasImage;
  Tutee(this.tutee, this.image, this.hasImage);
}

class TutorGroupPage extends StatefulWidget {
  final Groups group;
  final Globals globals;
  final Modules module;
  const TutorGroupPage(
      {Key? key,
      required this.group,
      required this.globals,
      required this.module})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorGroupPageState();
  }
}

class TutorGroupPageState extends State<TutorGroupPage> {
  List<Users> tuteeList = List<Users>.empty();
  List<Tutee> tutees = List<Tutee>.empty(growable: true);
  List<Uint8List> tuteeImages = List<Uint8List>.empty(growable: true);
  List<int> hasImage = List<int>.empty(growable: true);
  bool _isLoading = true;

  bool hasTutees = false;
  String _token = "";
  String _meetingID = "";

  getTutees() async {
    fetchToken().then((token) => setState(() => _token = token));
    try {
      final tutees = await GroupServices.getGroupTutees(
          widget.group.getId, widget.globals);
      setState(() {
        tuteeList = tutees;
        if (tuteeList.isNotEmpty) {
          hasTutees = true;
        }
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
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getTutees();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.height;

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

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTutees(
                        group: widget.group,
                        globals: widget.globals,
                        tutees: tutees)));
          },
          label: const Text('Add tutees'),
          backgroundColor: colorOrange,
          icon: const Icon(Icons.add)),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          title: Text(widget.module.getCode + '- Group'),
          backgroundColor: primaryColor,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
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
                                        color: textColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenHeight * 0.03,
                                        decoration: TextDecoration.underline),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.edit,
                                        color: highLightColor,
                                      ))
                                ],
                              ),
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
                      height: screenHeight * 0.35,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                              color: Colors.transparent,
                              child: ListTile(
                                horizontalTitleGap: screenHeight * 0.02,
                                leading: Icon(
                                  Icons.chat,
                                  size: screenHeight * 0.06,
                                  color: primaryColor,
                                ),
                                title: Text(
                                  'Group Chat',
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                ),
                                subtitle: const Text('2 new msgs!'),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: highLightColor,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              try {
                                const SnackBar snackBar =
                                    SnackBar(content: Text('Initializing...'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                _meetingID = await createMeeting();
                                await GroupServices.updateGroupVideoId(
                                    _meetingID, widget.group, widget.globals);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MeetingScreen(
                                        token: _token,
                                        meetingId: _meetingID,
                                        displayName: "Tutor",
                                        group: widget.group,
                                        globals: widget.globals,
                                      ),
                                    ));
                                List<Badge> fetchedBadges =
                                    List<Badge>.empty(growable: true);
                                for (var badge in widget.globals.getBadges) {
                                  if (badge.getName.contains('Meetings')) {
                                    fetchedBadges.add(badge);
                                  }
                                }

                                List<UserBadge> userBadges =
                                    List<UserBadge>.empty(growable: true);

                                userBadges =
                                    await UserBadges.getAllUserBadgesByUserId(
                                        widget.globals);

                                bool isThere = false;
                                int index = 0;

                                for (int k = 0; k < userBadges.length; k++) {
                                  for (int j = 0;
                                      j < fetchedBadges.length;
                                      j++) {
                                    if (userBadges[k].getBadgeId ==
                                        fetchedBadges[j].getBadgeId) {
                                      isThere = true;
                                      await UserBadges.updateUserBadge(
                                          widget.globals.getUser.getId,
                                          userBadges[k].getBadgeId,
                                          userBadges[k].getPointAchieved + 1,
                                          widget.globals);
                                      break;
                                    }
                                  }
                                  if (isThere == false) {
                                    await UserBadges.addUserBadge(
                                        widget.globals.getUser.getId,
                                        fetchedBadges[index].getBadgeId,
                                        1,
                                        widget.globals);
                                    break;
                                  }
                                  try {} catch (e) {
                                    log(e.toString());
                                  }

                                  try {
                                    _meetingID = await createMeeting();
                                    await GroupServices.updateGroupVideoId(
                                        _meetingID,
                                        widget.group,
                                        widget.globals);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MeetingScreen(
                                          token: _token,
                                          meetingId: _meetingID,
                                          displayName: "Tutor",
                                          group: widget.group,
                                          globals: widget.globals,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    const snackBar = SnackBar(
                                      content:
                                          Text('Failed to start live video'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              } catch (e) {
                                const snackBar = SnackBar(
                                  content: Text('Failed to start live video'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: ListTile(
                                horizontalTitleGap: screenHeight * 0.02,
                                leading: Stack(children: [
                                  Icon(
                                    Icons.chat_bubble,
                                    size: screenHeight * 0.06,
                                    color: primaryColor,
                                  ),
                                  Positioned(
                                      top: screenHeight * 0.01,
                                      left: screenWidth * 0.017,
                                      child: const Icon(
                                        Icons.video_camera_front,
                                        color: colorWhite,
                                      ))
                                ]),
                                title: Text(
                                  'Start Live Video Call',
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: highLightColor,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RecordedVideos(
                                        group: widget.group,
                                        global: widget.globals,
                                      )));
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: ListTile(
                                horizontalTitleGap: screenHeight * 0.02,
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
                                      color: textColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: highLightColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.5,
                      // height: screenHeight * 0.5,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: Text(
                          'Tutees:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: textColor,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.20,
                      width: screenWidth * 0.5,
                      child: hasTutees
                          ? ListView.separated(
                              controller: ScrollController(),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: participantBuilder,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: screenHeight * 0.0001,
                                );
                              },
                              itemCount: tutees.length)
                          : Center(
                              child: Text(
                                'This group has no tutees',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: highLightColor),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
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

    // log("Auth Token: $_AUTH_TOKEN");

    return _AUTH_TOKEN ?? "";
  }

  Future<String> createMeeting() async {
    final String? _VIDEOSDK_API_ENDPOINT = dotenv.env['VIDEOSDK_API_ENDPOINT'];

    final Uri getMeetingIdUrl = Uri.parse('$_VIDEOSDK_API_ENDPOINT/meetings');
    final http.Response meetingIdResponse =
        await http.post(getMeetingIdUrl, headers: {
      "Authorization": _token,
    });
    final meetingId = json.decode(meetingIdResponse.body)['meetingId'];

    // log("Meeting ID: $meetingId");

    return meetingId;
  }

  Widget pointBuilder(BuildContext context, int i) {
    return Text(
      '•' + widget.group.getDescription,
      style: const TextStyle(fontWeight: FontWeight.w300),
    );
  }

  Widget participantBuilder(BuildContext context, int i) {
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
                          "assets/Pictures/penguin.png",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                        )),
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
}
