import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tutor_me/services/tutor_services.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'tutorProfilePages/tutor_profile_view.dart';
import 'Navigation/tutee_nav_drawer.dart';
import 'tuteeProfilePages/tutee_data.dart';
import 'theme/themes.dart';
import 'pages/calls_page.dart';
import 'pages/tutors_list.dart';
import 'pages/chats_page.dart';

class TuteePage extends StatefulWidget {
  const TuteePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteePageState();
  }
}

class TuteePageState extends State<TuteePage> {
  Tutee tutee = Tutee();
  List<Tutors> tutorList = List<Tutors>.empty();
  List<Tutors> tutors = List<Tutors>.empty();

  @override
  Widget build(BuildContext context) {
    tutee.setAttributes(
        "I am a hardworker,I absolutely love the field I am in.I'm constantly looking for ways to get things done",
        'Evander, Secunda\n',
        'Rose Tamil\n',
        '21 years old\n',
        'Female\n');
    return DefaultTabController(
      length: 3,
      child: MaterialApp(
        themeMode: ThemeMode.light,
        darkTheme: Themes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          drawer: const TuteeNavigationDrawerWidget(),
          appBar: AppBar(
              toolbarHeight: 70,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(60),
                ),
              ),
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
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(60)),
                    gradient: LinearGradient(
                        colors: <Color>[Colors.orange, Colors.red],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),
              // actions: <Widget>[
                
              // ],
          ),
            body: const TabBarView(
              children: <Widget>[
                Chats(),
                TutorsList(),
                Calls()
              ],
            )),
      ),
    );
        
  }

}
