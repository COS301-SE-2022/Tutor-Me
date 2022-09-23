// import 'package:flutter/material.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:tutor_me/src/pages/call_history.dart';
// import 'package:tutor_me/src/colorpallete.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import '../../constants/colors.dart';
// import '../../navigator_key.dart';
// import '../../screens/splash_screen.dart';
// import '../../screens/startup_screen.dart';

void main() async {
  // Load Environment variables
  // await dotenv.load(fileName: ".env");

  // Run Flutter App
  runApp(const Calls());
}

class Calls extends StatefulWidget {
  const Calls({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CallsState();
  }
}

class CallsState extends State<Calls> {
  @override
  Widget build(BuildContext context) {
    return const CallHistory();
  }
}
