import 'package:flutter/material.dart';
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
    return const Center(
      child: Text("No Chats available."),
    );
  }
}
