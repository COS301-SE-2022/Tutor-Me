import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/users.dart';
import 'package:tutor_me/src/notifications/tutorNotifications/tutor_notifications.dart';
import 'package:tutor_me/src/pages/chats_page.dart';
import 'package:tutor_me/src/tutorAndTuteeCollaboration/tutorGroups/tutor_groups.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
import 'Navigation/tutor_nav_drawer.dart';
// import 'theme/themes.dart';
import 'pages/calls_page.dart';

class TutorPage extends StatefulWidget {
  final Users user;

  const TutorPage({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorPageState();
  }
}

class TutorPageState extends State<TutorPage> {
  // var size = tutors.length;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          drawer: TutorNavigationDrawerWidget(user: widget.user),
          appBar: AppBar(
            toolbarHeight: 70,
            // shape: const RoundedRectangleBorder(
            //   borderRadius: BorderRadius.vertical(
            //     bottom: Radius.circular(60),
            //   ),
            // ),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                    icon: Icon(
                      Icons.chat_bubble_rounded,
                      color: Colors.white,
                    ),
                    text: 'Chat'),
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  text: 'Groups',
                ),
                Tab(
                    icon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    text: 'Calls')
              ],
            ),
            // backgroundColor: const Color(0xffD6521B),
            centerTitle: true,
            title: const Text('Tutor Me'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  // borderRadius:
                  //     BorderRadius.vertical(bottom: Radius.circular(60)),
                  gradient: LinearGradient(
                      colors: <Color>[Colors.orange, Colors.red],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => TutorNotifications(
                              user: widget.user,
                            )));
                  },
                  icon: const Icon(Icons.notifications))
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              Chats(user: widget.user),
              TutorGroups(
                tutor: widget.user,
              ),
              const Calls()
            ],
          )),
    );

    // Widget _starBuilder(BuildContext context, int i) {
    //   return const Material(
    //     child: Icon(Icons.star),
    //   );
    // }
  }
}
