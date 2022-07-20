import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutees.dart';
import 'Navigation/tutee_nav_drawer.dart';
// import 'theme/themes.dart';
import 'pages/calls_page.dart';
import 'pages/tutors_list.dart';
import 'pages/chats_page.dart';

class TuteePage extends StatefulWidget {
  final Tutees user;
  const TuteePage({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteePageState();
  }
}

class TuteePageState extends State<TuteePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          drawer: TuteeNavigationDrawerWidget(
            user: widget.user,
          ),
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
                  text: 'Request',
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
            // actions: <Widget>[

            // ],
          ),
          body: TabBarView(
            children: <Widget>[
              Chats(user: widget.user),
              TutorsList(tutee: widget.user),
              const Calls()
            ],
          )),
    );
  }
}
