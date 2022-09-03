import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutees.dart';
import 'package:tutor_me/src/colorpallete.dart';

import '../../../services/models/users.dart';

class TuteeActivity extends StatefulWidget {
  final Users user;
  const TuteeActivity({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteeActivityState();
  }
}

class TuteeActivityState extends State<TuteeActivity> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.notifications_off,
              size: MediaQuery.of(context).size.height * 0.15,
              color: colorTurqoise,
            ),
            const Text('No Activity found')
          ],
        ),
      ),
    );
  }
}
