import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/models/globals.dart';

import 'package:tutor_me/src/theme/themes.dart';
import '../../colorpallete.dart';

import 'tutee_activity.dart';
import 'tutee_pending_requests.dart';

class TuteeNotifications extends StatefulWidget {
  final Globals globals;
  const TuteeNotifications({Key? key, required this.globals}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteeNotificationsState();
  }
}

class TuteeNotificationsState extends State<TuteeNotifications> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color primaryColor;


    if (provider.themeMode == ThemeMode.dark) {
      primaryColor = colorGrey;
   
    } else {
      primaryColor = colorBlueTeal;
   
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.14),
            child: AppBar(
              bottom: const TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                      icon: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      text: 'Pending Requests'),
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
              TuteePendingRequests(globals: widget.globals),
              TuteeActivity(globals: widget.globals)
            ],
          )),
    );
  }
}
