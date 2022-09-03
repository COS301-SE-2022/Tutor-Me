import 'dart:convert';
import 'dart:math';

import 'package:tutor_me/services/models/groups.dart';
// import 'package:tutor_me/services/models/tutors.dart';

import '../../services/models/modules.dart';
import '../models/message_model.dart';
import '../widgets/chat_appbar_widget.dart';
import '../widgets/chat_message_list_widget.dart';
import '../widgets/chat_type_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatPage extends StatefulWidget {
  final dynamic user;
  final Groups group;
  final String moduleCode;
  const ChatPage({Key? key, required this.group, required this.user, required this.moduleCode}) 
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  late Modules module ;
  

  @override
  void initState() {
    super.initState();
    openSignalRConnection();
    createRandomId();
  }

  int currentUserId = 0;
  //generate random user id
  createRandomId() {
    Random random = Random();
    currentUserId = random.nextInt(999999);
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
    await connection.invoke('SendMessage',
        args: [widget.user.getName, currentUserId, messageText]);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            chatAppbarWidget(size, context, widget.moduleCode),
            chatMessageWidget(
                chatListScrollController, messageModel, currentUserId),
            chatTypeMessageWidget(messageTextController, submitMessageFunction)
          ],
        ),
      ),
    );
  }

  //set url and configs
  final connection = HubConnectionBuilder()
      .withUrl(
          'http://tutormechatapi-prod.us-east-1.elasticbeanstalk.com/chatHub',
          HttpConnectionOptions())
      .build();

  //connect to signalR
  Future<void> openSignalRConnection() async {
    await connection.start();
    connection.on('ReceiveMessage', (message) {
      _handleIncommingDriverLocation(message);
    });
    await connection
        .invoke('JoinUSer', args: [widget.user.getName, currentUserId]);
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
