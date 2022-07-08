import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/src/notifications/tutorNotifications/tutors_requests.dart';
import 'package:tutor_me/src/notifications/tutorNotifications/tutors_activity.dart';

class TutorNotifications extends StatefulWidget {
  final Tutors user;
  const TutorNotifications({Key? key, required this.user}) : super(key: key);

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
                        Icons.chat_bubble_rounded,
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
              backgroundColor: const Color(0xffD6521B),
              title: const Text('Notifications'),

              // actions: <Widget>[

              // ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              TutorRequests(user: widget.user),
              TutorActivity(user: widget.user)
            ],
          )),
    );
  }
}
