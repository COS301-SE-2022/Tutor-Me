import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/models/users.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/theme/themes.dart';
import 'Navigation/tutee_nav_drawer.dart';
// import 'theme/themes.dart';
import 'notifications/tuteeNotifications/tutee_notifications.dart';
import 'pages/calls_page.dart';
import 'pages/home.dart';
import 'pages/tutors_list.dart';
import 'pages/chats_page.dart';
import 'tutorAndTuteeCollaboration/tutorGroups/tutor_groups.dart';

class TuteePage extends StatefulWidget {
  final Users user;
  const TuteePage({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteePageState();
  }
}

class TuteePageState extends State<TuteePage> {
  int currentIndex = 0;

  getScreens() {
    return [
      const Home(),
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
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    Color appBarColor1;
    Color appBarColor2;
    Color highlightColor;
    if (provider.themeMode == ThemeMode.dark) {
      appBarColor1 = colorDarkGrey;
      appBarColor2 = colorGrey;
      highlightColor = colorOrange;
    } else {
      appBarColor1 = Colors.red;
      appBarColor2 = Colors.orange;
      highlightColor = colorTurqoise;
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: TuteeNavigationDrawerWidget(
          user: widget.user,
        ),
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          title: const Text('Tutor Me'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                // borderRadius:
                //     BorderRadius.vertical(bottom: Radius.circular(60)),
                gradient: LinearGradient(
                    colors: <Color>[appBarColor1, appBarColor2],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => TuteeNotifications(
                            user: widget.user,
                          )));
                },
                icon: const Icon(Icons.notifications)),
          ],
        ),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: colorOrange,
          unselectedItemColor: colorDarkGrey,
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
        ),
        floatingActionButton: FloatingActionButton.extended(
          // shape: S,
          isExtended: false,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => TutorsList(
                      tutee: widget.user,
                    )));
          },
          icon: const Icon(
            Icons.person_add_alt,
            color: Colors.white,
          ),
          label: const Text('Request Tutor'),
          backgroundColor: highlightColor.withOpacity(0.8),
          splashColor: colorOrange,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
}
