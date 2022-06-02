import 'package:flutter/material.dart';
import 'package:tutor_me/src/pages/chat_page.dart';
import 'package:tutor_me/src/pages/tutees_list.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
import 'Navigation/nav_drawer.dart';
import 'tuteeProfilePages/tutee_data.dart';
import 'theme/themes.dart';
import 'pages/calls_page.dart';

class TutorPage extends StatefulWidget {
  const TutorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorPageState();
  }
}

class TutorPageState extends State<TutorPage> {
  Tutee tutee = Tutee();
  // List<Tutors> tutorList = List<Tutors>.empty();
  // getTutors() {
  //   APIServices.fetchTutor().then((response) {
  //     // ignore: deprecated_member_use
  //     Iterable list = json.decode(response.body);
  //     // ignore: deprecated_member_use
  //     List<Tutors> tutorsl = List<Tutors>.empty();
  //     tutorsl = list.map((model) => Tutors.fromObject(model)).toList();
  //     setState(() {
  //       tutorList = tutorsl;
  //     });
  //   });
  // }

  void search(String search) {
    setState(() {
      //  tutors = tutors.where((tu) => false)
    });
  }

  // var size = tutors.length;
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
            drawer: const NavigationDrawerWidget(),
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
                    text: 'Tutees',
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
              actions: <Widget>[
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              ],
            ),
            body: const TabBarView(
              children: <Widget>[
                Chats(),
                TuteesList(),
                Calls()
              ],
            )),
      ),
    );

    // Widget _starBuilder(BuildContext context, int i) {
    //   return const Material(
    //     child: Icon(Icons.star),
    //   );
    // }
  }
}
