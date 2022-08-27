// ignore_for_file: non_constant_identifier_names, dead_code
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/group_services.dart';
// import 'package:tutor_me/src/chat/group_chat.dart';
import 'package:tutor_me/src/colorpallete.dart';
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

class Tutee {
  Users tutee;
  Uint8List image;
  bool hasImage;
  Tutee(this.tutee, this.image, this.hasImage);
}

class TutorGroupPage extends StatefulWidget {
  final Groups group;
  final Users tutor;
  const TutorGroupPage({Key? key, required this.group, required this.tutor})
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
    if (widget.group.getTutees == '') {
      setState(() {
        hasTutees = false;
        _isLoading = false;
      });
    } else {
      try {
        List<String> tuteeIds = widget.group.getTutees.split(',');
        for (int i = 0; i < tuteeIds.length; i++) {
          final tutee = await UserServices.getTutee(tuteeIds[i]);
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
  }

  getTuteeProfileImages() async {
    for (int i = 0; i < tuteeList.length; i++) {
      try {
        final image =
            await UserServices.getTuteeProfileImage(tuteeList[i].getId);
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
          tutees.add(Tutee(tuteeList[i], tuteeImages[i], false));
        } else {
          tutees.add(Tutee(tuteeList[i], tuteeImages[i], true));
        }
      });
    }
    setState(() {
      hasTutees = true;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getTutees();
    fetchToken().then((token) => setState(() => _token = token));
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
                        mainAxisSize: MainAxisSize.min,
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
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  color: colorTurqoise,
                                  size: screenHeight * 0.045,
                                ),
                              )
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
                                    child: ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: pointBuilder,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: screenHeight * 0.01,
                                          );
                                        },
                                        itemCount: 1),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    SizedBox(
                      height: screenHeight * 0.23,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => ChatPage(
                                      user: widget.tutor,
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
                            onTap: () async {
                              try {
                                _meetingID = await createMeeting();
                                widget.group.setGroupLink = _meetingID;
                                await GroupServices.updateGroup(widget.group);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MeetingScreen(
                                      token: _token,
                                      meetingId: _meetingID,
                                      displayName: "Tutor",
                                    ),
                                  ),
                                );
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
                                horizontalTitleGap: screenHeight * 0.04,
                                leading: Stack(children: [
                                  Icon(
                                    Icons.chat_bubble,
                                    size: screenHeight * 0.06,
                                    color: colorOrange,
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
                                      fontWeight: FontWeight.w800,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                        ],
                      ),
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
                    SizedBox(
                      height: screenHeight * 0.25,
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
                          : const Center(
                              child: Text(
                                'This group has no tutees',
                                style: TextStyle(fontWeight: FontWeight.w400),
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
                    user: widget.tutor,
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
