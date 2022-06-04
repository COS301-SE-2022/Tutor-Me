import 'package:flutter/material.dart';
import '../chat/message.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';

class Chat extends StatefulWidget {
  final String name;

  const Chat({Key? key,
  required this.name,
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
      isOnline: false
    )
  ].toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(children: [
        Expanded(child: Container(

        )),
        Container(
          color: Colors.grey,
          child: const TextField(decoration: InputDecoration(
            contentPadding: EdgeInsets.all(14),
            hintText: 'Type your message...'
          ),),
        )
      ],)
    );
  }


}
