import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tutor_me/modules/api.services.dart';
import 'package:tutor_me/modules/tutors.dart';
import 'tutorProfilePages/tutor_profile_view.dart';
import 'Navigation/nav_drawer.dart';
import 'tuteeProfilePages/tutee_data.dart';
import 'theme/themes.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Tutee tutee = Tutee();
  List<Tutors> tutorList = List<Tutors>.empty();

  getTutors() {
    print("start get tutors");
    APIServices.fetchTutor().then((response) {
      print("lllllllllllllllllllll" + response.body);
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
        tutorList = list.map((model) => Tutors.fromObject(model)).toList();
      });
    });
  }

  List<Tutors> tutors = List<Tutors>.empty();

  @override
  Widget build(BuildContext context) {
    getTutors();
    tutee.setAttributes(
        "I am a hardworker,I absolutely love the field I am in.I'm constantly looking for ways to get things done",
        'Evander, Secunda\n',
        'Rose Tamil\n',
        '21 years old\n',
        'Female\n');
    return DefaultTabController(
      length: 3,
      child: MaterialApp(
        themeMode: ThemeMode.system,
        darkTheme: Themes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          drawer: const NavigationDrawerWidget(),
          appBar: AppBar(
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.chat_bubble_rounded), text: 'Chat'),
                Tab(icon: Icon(Icons.person), text: 'Request'),
                Tab(icon: Icon(Icons.phone), text: 'Calls')
              ],
            ),
            // backgroundColor: const Color(0xffD6521B),
            centerTitle: true,
            title: const Text('Tutor Me'),
            actions: <Widget>[
              IconButton(onPressed: () {}, icon: const Icon(Icons.search))
            ],
          ),
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 400,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: 5,
                  itemBuilder: _cardBuilder,
                ),
              )

              //ignore: unused_local_variable

              // GestureDetector(
              //   child: Card(
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: <Widget>[
              //         ListTile(
              //           leading: const Icon(Icons.account_circle),
              //           title: Text(person),
              //           subtitle:
              //               const Text('I am a Machenical engineer student'),
              //         ),
              //       ],
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (BuildContext context) =>
              //             TutorProfilePageView(person: person)));
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardBuilder(BuildContext context, int i) {
    return GestureDetector(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(tutorList[i].getFirstNname),
              subtitle: Text(tutorList[i].getLocation),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TutorProfilePageView(
                person: tutorList[i].getFirstNname,
                bio: tutorList[i].getLocation,
                age: tutorList[i].getAge,
                location: tutorList[i].getLocation,
                gender: tutorList[i].getInstitution)));
      },
    );
  }
}
