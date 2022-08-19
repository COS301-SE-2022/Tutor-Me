import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/models/tutees.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/pages/%20call_history.dart';
import 'package:tutor_me/src/theme/themes.dart';
import 'package:tutor_me/src/tutorAndTuteeCollaboration/tuteeGroups/tutee_groups.dart';
import 'Navigation/tutee_nav_drawer.dart';
// import 'theme/themes.dart';
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
     final provider = Provider.of<ThemeProvider>(context,listen: false);
    Color appBarColor1 ;
    Color appBarColor2;
    Color highlightColor;
    if(provider.themeMode == ThemeMode.dark)
    {
      appBarColor1 = colorDarkGrey;
      appBarColor2 = colorGrey ;
      highlightColor = colorOrange;
    }
    else
    {
      appBarColor1 = Colors.red;
      appBarColor2 = Colors.orange ;
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
                  text: 'Calls'),
            ],
          ),
          // backgroundColor: const Color(0xffD6521B),
          centerTitle: true,
          title: const Text('Tutor Me'),
          flexibleSpace: Container(
            decoration:  BoxDecoration(
                // borderRadius:
                //     BorderRadius.vertical(bottom: Radius.circular(60)),
                gradient: LinearGradient(
                    colors: <Color>[appBarColor1, appBarColor2 ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          actions: <Widget>[
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Chats(user: widget.user),
            TuteeGroups(tutee: widget.user),
            const CallHistory(),
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
