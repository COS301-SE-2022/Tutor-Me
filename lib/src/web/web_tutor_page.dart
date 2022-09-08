import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/users.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/notifications/tutorNotifications/tutor_notifications.dart';
import 'package:tutor_me/src/pages/chats_page.dart';
import 'package:tutor_me/src/pages/home.dart';
import 'package:tutor_me/src/tutorAndTuteeCollaboration/tutorGroups/tutor_groups.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
import '../Navigation/tutor_nav_drawer.dart';
import '../pages/calls_page.dart';

class WebTutorPage extends StatefulWidget {
  final Users user;

  const WebTutorPage({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WebTutorPageState();
  }
}

class WebTutorPageState extends State<WebTutorPage> {
  // var size = tutors.length;
  int currentIndex = 0;

  getScreens() {
    return [
      Home(
        user: widget.user,
      ),
      Chats(user: widget.user),
      TutorGroups(tutor: widget.user),
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
    return Row(
      children: [
        TutorNavigationDrawerWidget(
          user: widget.user,
        ),
        Scaffold(
            // drawer: TutorNavigationDrawerWidget(user: widget.user),
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
                                user: widget.user,
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
            )),
      ],
    );

    // Widget _starBuilder(BuildContext context, int i) {
    //   return const Material(
    //     child: Icon(Icons.star),
    //   );
    // }
  }
}
