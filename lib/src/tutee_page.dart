import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/theme/themes.dart';
import '../services/models/globals.dart';
import '../services/services/user_services.dart';
import 'Navigation/tutee_nav_drawer.dart';
// import 'theme/themes.dart';
import 'notifications/tuteeNotifications/tutee_notifications.dart';
import 'pages/home.dart';
// import 'pages/text_recognition.dart';
import 'pages/tutors_list.dart';
import 'pages/chats_page.dart';
import 'tutorAndTuteeCollaboration/tuteeGroups/tutee_groups.dart';

class TuteePage extends StatefulWidget {
  final Globals globals;
  const TuteePage({Key? key, required this.globals}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteePageState();
  }
}

class TuteePageState extends State<TuteePage> {
  int currentIndex = 0;
  int notificationCount = 0;

  getRequests() async {
    final requests = await UserServices()
        .getTuteeRequests(widget.globals.getUser.getId, widget.globals);

    if (requests == null) {
      return;
    }
    if (requests.isEmpty) {
      setState(() {
        notificationCount = 0;
      });
    } else {
      setState(() {
        notificationCount = requests.length;
      });
    }
    setBadges();
  }

  getScreens() {
    return [
      Home(globals: widget.globals),
      Chats(globals: widget.globals),
      TuteeGroups(globals: widget.globals),
    ];
  }

  setBadges() async {
    await widget.globals.getAllBadges();
  }

  @override
  void initState() {
    super.initState();
    getRequests();
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
      highlightColor = colorBlueTeal;
    } else {
      appBarColor1 = colorLightBlueTeal;
      appBarColor2 = colorBlueTeal;
      highlightColor = colorOrange;
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: TuteeNavigationDrawerWidget(
          globals: widget.globals,
        ),
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.09,
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
            Stack(children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => TuteeNotifications(
                              globals: widget.globals,
                            )));
                  },
                  icon: const Icon(Icons.notifications)),
              notificationCount == 0
                  ? Container()
                  : Positioned(
                      right: MediaQuery.of(context).size.width * 0.020,
                      top: MediaQuery.of(context).size.height * 0.014,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: colorOrange,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          notificationCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ])
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
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          // shape: S,
          isExtended: false,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => TutorList(
                      globals: widget.globals,
                    )));
          },
          icon: const Icon(
            Icons.person_add_alt,
            color: Colors.white,
          ),
          label: const Text('Request Tutor'),
          backgroundColor: highlightColor.withOpacity(0.8),
          splashColor: colorBlueTeal,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
}
