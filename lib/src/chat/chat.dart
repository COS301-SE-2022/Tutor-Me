import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../chat/message.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';

class Chat extends StatefulWidget {
  final dynamic user;

  const Chat({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> {
  List<Message> messages = [
    Message(
        text: 'Yes sure!',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: false,
        isOnline: false,
        sentBy: "John@gmail.com")
  ].toList();
  @override
  Widget build(BuildContext context) {
    String status = "";
    if (widget.user.getStatus == "F") {
      status = "Offline";
    } else {
      status = "Online";
    }
    String name = widget.user.getName + ' ' + widget.user.getLastName;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorOrange,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(name),
              Text(
                status,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(child: Container()),
            Container(
              color: Colors.grey,
              child: const TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(14),
                    hintText: 'Type your message...'),
              ),
            )
          ],
        ));
  }
}
