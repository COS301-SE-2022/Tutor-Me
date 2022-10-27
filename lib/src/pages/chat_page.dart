import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/services/models/groups.dart';
// import 'package:tutor_me/services/models/tutors.dart';

import '../../services/models/globals.dart';
import '../../services/models/modules.dart';
import '../colorpallete.dart';
import '../models/message_model.dart';
import '../theme/themes.dart';
import '../widgets/chat_appbar_widget.dart';
import '../widgets/chat_message_list_widget.dart';
import '../widgets/chat_type_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatPage extends StatefulWidget {
  final Globals globals;
  final Groups group;
  final String moduleCode;
  const ChatPage(
      {Key? key,
      required this.group,
      required this.globals,
      required this.moduleCode})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Modules module;
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
    await connection.invoke('SendMessageToGroup', args: [
      widget.group.getId,
      widget.globals.getUser.getName,
      widget.globals.getUser.getId,
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
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color secondaryColor;

    if (provider.themeMode == ThemeMode.dark) {
      secondaryColor = colorLightGrey;
    } else {
      secondaryColor = colorWhite;
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            chatAppbarWidget(size, context, widget.moduleCode),
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
          'http://chatapplicationserver3-dev.us-east-1.elasticbeanstalk.com/chatHub',
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
    await connection.invoke('JoinGroup', args: [
      widget.moduleCode,
      widget.group.getId,
      widget.globals.getUser.getName,
      widget.globals.getUser.getId
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
