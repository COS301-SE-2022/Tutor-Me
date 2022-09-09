import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/notifications/tutorNotifications/tutor_notifications.dart';
import 'package:tutor_me/src/pages/chats_page.dart';
import 'package:tutor_me/src/pages/home.dart';
import 'package:tutor_me/src/tutorAndTuteeCollaboration/tutorGroups/tutor_groups.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
import 'Navigation/tutor_nav_drawer.dart';
// import 'theme/themes.dart';
import 'pages/calls_page.dart';

class TutorPage extends StatefulWidget {
  final Globals globals;

  const TutorPage({Key? key, required this.globals}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorPageState();
  }
}

class TutorPageState extends State<TutorPage> {
  // var size = tutors.length;
  int currentIndex = 0;

  getScreens() {
    return [
      Home(
        globals: widget.globals,
      ),
      Chats(globals: widget.globals),
      TutorGroups(globals: widget.globals),
      const Calls()
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screens = getScreens();
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 1100) {
      return Scaffold(
          drawer: TutorNavigationDrawerWidget(globals: widget.globals),
          appBar: AppBar(
            toolbarHeight: 70,
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
                              user: widget.globals.getUser,
                            )));
                  },
                  icon: const Icon(Icons.notifications))
            ],
          ),
          body: screens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: colorOrange,
            unselectedItemColor: colorDarkGrey,
            showUnselectedLabels: true,
            unselectedLabelStyle: const TextStyle(color: colorDarkGrey),
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Groups',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Calls',
              ),
            ],
          ));
    } else {
      return Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: 70,
        //   centerTitle: true,
        //   title: const Text('Tutor Me'),
        //   flexibleSpace: Container(
        //     decoration: const BoxDecoration(
        //         // borderRadius:
        //         //     BorderRadius.vertical(bottom: Radius.circular(60)),
        //         gradient: LinearGradient(
        //             colors: <Color>[Colors.orange, Colors.red],
        //             begin: Alignment.topCenter,
        //             end: Alignment.bottomCenter)),
        //   ),
        //   actions: <Widget>[
        //     IconButton(
        //         onPressed: () {
        //           Navigator.of(context).push(MaterialPageRoute(
        //               builder: (BuildContext context) => TutorNotifications(
        //                     user: widget.user,
        //                   )));
        //         },
        //         icon: const Icon(Icons.notifications))
        //   ],
        // ),
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              width: screenWidth * 0.2,
              child: TutorNavigationDrawerWidget(globals: widget.globals),
            ),
            SizedBox(
              width: screenWidth * 0.8,
              child: screens[currentIndex],
            ),
          ],
        ),
      );
    }
  }
}
