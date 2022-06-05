import 'package:flutter/material.dart';
import '../chat/chat.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChatsState();
  }
}

class ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemBuilder: _chatBuilder,
      itemCount: 10,
    ));
  }

  Widget _chatBuilder(BuildContext context, int i) {
    return GestureDetector(
        child: Card(
          elevation: 7.0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              ListTile(
                leading: CircleAvatar(
                    child: Text('c'), backgroundColor: Colors.blue),
                title: Text('John Doe'),
                subtitle: Text('Hi, how are you'),
                // trailing: ,
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => const Chat(name: 'John Doe')));
        });
  }
}
