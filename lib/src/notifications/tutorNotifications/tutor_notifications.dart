import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/src/notifications/tutorNotifications/tutors_requests.dart';
import 'package:tutor_me/src/notifications/tutorNotifications/tutors_activity.dart';

import '../../colorpallete.dart';
import '../../theme/themes.dart';

class TutorNotifications extends StatefulWidget {
  final Globals globals;
  const TutorNotifications({Key? key, required this.globals}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorNotificationsState();
  }
}

class TutorNotificationsState extends State<TutorNotifications> {
  List<Tutors> tutorList = List<Tutors>.empty();
  List<Tutors> tutors = List<Tutors>.empty();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color primaryColor;
    Color textColor;
    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      primaryColor = colorGrey;
      textColor = colorWhite;
      highLightColor = colorLightBlueTeal;
    } else {
      primaryColor = colorBlueTeal;
      textColor = colorDarkGrey;
      highLightColor = colorOrange;
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.17),
            child: AppBar(
              bottom: const TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                      icon: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      text: 'Requests'),
                  Tab(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    text: 'Activity',
                  ),
                ],
              ),
              backgroundColor: primaryColor,
              title: const Text(
                'Notifications',
                style: TextStyle(color: colorWhite),
              ),

              // actions: <Widget>[

              // ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              TutorRequests(globals: widget.globals),
              TutorActivity(globals: widget.globals)
            ],
          )),
    );
  }
}
