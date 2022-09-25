// ignore_for_file: non_constant_identifier_names, dead_code
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tutor_me/services/services/events_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tutorProfilePages/tutor_profile_view.dart';
import '../../screens/join_screen.dart';
import '../../screens/meeting_screen.dart';
import '../../services/models/event.dart';
import '../../services/models/globals.dart';
import '../../services/models/users.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../utils/toast.dart';
import '../models/message_model.dart';
import '../tuteeProfilePages/tutee_profile_view.dart';
import '../widgets/chat_message_list_widget.dart';
import '../widgets/chat_type_message_widget.dart';
import 'package:http/http.dart' as http;
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';

class BookingChat extends StatefulWidget {
  final Users reciever;
  final Globals globals;
  final Uint8List image;
  final bool hasImage;
  final Event event;
  const BookingChat(
      {Key? key,
      required this.reciever,
      required this.globals,
      required this.image,
      required this.hasImage,
      required this.event})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BookingChatState();
  }
}

class BookingChatState extends State<BookingChat> {
  bool isVideoReady = false;
  String _token = "";
  String _meetingID = "";

  @override
  void initState() {
    super.initState();
    openSignalRConnection();
  }

  

  String removeMessageExtraChar(String userText) {
    String editedUserText = userText;
    for (;;) {
      if (editedUserText.endsWith('\n')) {
        editedUserText = editedUserText.substring(editedUserText.length - 1);
      } else if (editedUserText.endsWith(' ')) {
        editedUserText = editedUserText.substring(editedUserText.length - 1);
      } else if (editedUserText.startsWith(' ')) {
        editedUserText = editedUserText.substring(1);
      } else {
        break;
      }
    }
    return editedUserText;
  }

  ScrollController chatListScrollController = ScrollController();
  TextEditingController messageTextController = TextEditingController();
  submitMessageFunction() async {
    var messageText = removeMessageExtraChar(messageTextController.text);
    await connection.invoke('SendMessageToChat', args: [
      widget.globals.getUser.getId,
      widget.reciever.getId,
      widget.globals.getUser.getName,
      messageText
    ]);
    messageTextController.text = "";

    Future.delayed(const Duration(milliseconds: 500), () {
      chatListScrollController.animateTo(
          chatListScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(widget.event.getDateOfEvent);
    if (date.compareTo(DateTime.now()) > 0) {
      isVideoReady = true;
    }
    var size = MediaQuery.of(context).size;
    String name = widget.reciever.getName + ' ' + widget.reciever.getLastName;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlueTeal,
        title: InkWell(
          onTap: widget.reciever.getUserTypeID[0] == '7'
              ? () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => TutorProfilePageView(
                            tutor: widget.reciever,
                            globals: widget.globals,
                            image: widget.image,
                            hasImage: widget.hasImage,
                          )));
                }
              : () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => TuteeProfilePageView(
                            tutee: widget.reciever,
                            global: widget.globals,
                            image: widget.image,
                            imageExists: widget.hasImage,
                          )));
                },
          child: Row(
            children: [
              CircleAvatar(
                child: widget.hasImage
                    ? ClipOval(
                        child: Image.memory(
                          widget.image,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.253,
                          height: MediaQuery.of(context).size.width * 0.253,
                        ),
                      )
                    : ClipOval(
                        child: Image.asset(
                        "assets/Pictures/penguin.png",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.253,
                        height: MediaQuery.of(context).size.width * 0.253,
                      )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(name),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: isVideoReady
                ? null
                : () async {
                    try {
                      if (await validateMeeting(widget.event.getVideoLink)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JoinScreen(
                              meetingId: widget.event.getVideoLink,
                              token: _token,
                              globals: widget.globals,
                            ),
                          ),
                        );
                      } else {
                        try {
                          const SnackBar snackBar =
                              SnackBar(content: Text('Initializing...'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          _meetingID = await createMeeting();
                          await EventServices.updateVideoId(
                              widget.event.getEventId,
                              _meetingID,
                              widget.globals);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeetingScreen(
                                token: _token,
                                meetingId: _meetingID,
                                displayName: "Tutor",
                                globals: widget.globals,
                              ),
                            ),
                          );
                        } catch (e) {
                          const snackBar = SnackBar(
                            content: Text('Failed to start live video'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    } catch (e) {
                      const snackBar = SnackBar(
                        content: Text('Failed to join live video'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
            icon: const Icon(Icons.video_call),
            iconSize: MediaQuery.of(context).size.height * 0.045,
          ),
        ],
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            chatMessageWidget(
                chatListScrollController, messageModel, widget.globals.getUser.getId),
            chatTypeMessageWidget(messageTextController, submitMessageFunction)
          ],
        ),
      ),
    );
  }

  //set url and configs
  final connection = HubConnectionBuilder()
      .withUrl(
          // 'http://tutormechatapi-prod.us-east-1.elasticbeanstalk.com/chatHub',
          'http://192.168.42.155:500/chatHub',
          HttpConnectionOptions())
      .build();

  //connect to signalR
  Future<void> openSignalRConnection() async {
    fetchToken().then((token) => setState(() => _token = token));
    await connection.start();
    connection.on('ReceiveMessage', (message) {
      _handleIncommingDriverLocation(message);
    });
    await connection.invoke('JoinChat', args: [
      widget.reciever.getName,
      widget.globals.getUser.getId,
      widget.reciever.getId,
      widget.globals.getUser.getName,
    ]);
  }

  //get messages
  List<MessageModel> messageModel = [];
  Future<void> _handleIncommingDriverLocation(List<dynamic>? args) async {
    if (args != null) {
      var jsonResponse = json.decode(json.encode(args[0]));
      MessageModel data = MessageModel.fromJson(jsonResponse);
      setState(() {
        messageModel.add(data);
      });
    }
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
