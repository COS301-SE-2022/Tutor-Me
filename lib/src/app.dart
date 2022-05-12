import 'package:flutter/material.dart';
import 'tutorProfilePages/tutor_profile_view.dart';
import 'Navigation/nav_drawer.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  var people = [
    'Kuda Chivunga',
    'Thabo Maduna',
    'Farai Chivunga',
    'Simphiwe Ndlovu',
    'Musa Mabasa'
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MaterialApp(
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
            backgroundColor: const Color(0xffD6521B),
            centerTitle: true,
            title: const Text('Tutor Me'),
            actions: const <Widget>[],
          ),
          body: Column(
            children: <Widget>[
              //ignore: unused_local_variable
              for (var person in people)
                GestureDetector(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: Text(person),
                          subtitle:
                              const Text('I am a Machenical engineer student'),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TutorProfilePageView(person: person)));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
