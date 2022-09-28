import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tutorProfilePages/tutor_profile_view.dart';
import '../../services/models/globals.dart';
import '../../services/models/users.dart';
import 'package:signalr_core/signalr_core.dart';

import '../models/message_model.dart';
import '../tuteeProfilePages/tutee_profile_view.dart';
import '../widgets/chat_message_list_widget.dart';
import '../widgets/chat_type_message_widget.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';

class Chat extends StatefulWidget {
  final Users reciever;
  final Globals globals;
  final Uint8List image;
  final bool hasImage;
  const Chat(
      {Key? key,
      required this.reciever,
      required this.globals,
      required this.image,
      required this.hasImage})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> {
  SharedPreferences? prefs;
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
    var size = MediaQuery.of(context).size;
    String name = widget.reciever.getName + ' ' + widget.reciever.getLastName;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlueTeal,
        title: InkWell(
          onTap: widget.reciever.getUserTypeID[0] == '9'
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
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            chatMessageWidget(chatListScrollController, messageModel,
                widget.globals.getUser.getId),
            chatTypeMessageWidget(messageTextController, submitMessageFunction)
          ],
        ),
      ),
    );
  }

  //set url and configs
  final connection = HubConnectionBuilder()
      .withUrl(
          'http://tutormechathub.us-east-1.elasticbeanstalk.com/chatHub',
          // 'http://192.168.42.155:500/chatHub',
          HttpConnectionOptions())
      .build();

  //connect to signalR
  Future<void> openSignalRConnection() async {
    prefs = await SharedPreferences.getInstance();
    final lastDate = prefs?.getString('lastDate');
    if (lastDate != null) {
      final lastDateParsed = DateTime.parse(lastDate);
      final now = DateTime.now();
      final difference = now.difference(lastDateParsed);
      if (difference.inDays > 0) {
        await prefs?.setString('lastDate', now.toString());
        await prefs?.setInt('interactionCount', 1);
      } else {
        final interactionCount = prefs?.getInt('interactionCount');
        await prefs?.setInt('interactionCount', interactionCount! + 1);
      }
    } else {
      await prefs?.setString('lastDate', DateTime.now().toString());
      await prefs?.setInt('interactionCount', 1);
    }

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
}
