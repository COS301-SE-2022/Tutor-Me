import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/src/colorpallete.dart';

import '../../theme/themes.dart';

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
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color primaryColor;
    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      primaryColor = colorGrey;
      highLightColor = colorLightBlueTeal;
    } else {
      primaryColor = colorBlueTeal;
      highLightColor = colorOrange;
    }

    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.notifications,
              size: MediaQuery.of(context).size.height * 0.15,
              color: primaryColor,
            ),
            Text(
              'No Activity found',
              style: TextStyle(
                color: highLightColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
