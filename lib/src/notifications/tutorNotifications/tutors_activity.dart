import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/src/colorpallete.dart';

class TutorActivity extends StatefulWidget {
  final Globals globals;
  const TutorActivity({Key? key, required this.globals}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorActivityState();
  }
}

class TutorActivityState extends State<TutorActivity> {
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
