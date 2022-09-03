import 'package:flutter/material.dart';
import '../../../services/models/users.dart';
import 'tutee_activity.dart';
import 'tutee_pending_requests.dart';

class TuteeNotifications extends StatefulWidget {
  final Users user;
  const TuteeNotifications({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteeNotificationsState();
  }
}

class TuteeNotificationsState extends State<TuteeNotifications> {
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
              backgroundColor: const Color(0xffD6521B),
              title: const Text('Notifications'),

              // actions: <Widget>[

              // ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              TuteePendingRequests(user: widget.user),
              TuteeActivity(user: widget.user)
            ],
          )),
    );
  }
}
