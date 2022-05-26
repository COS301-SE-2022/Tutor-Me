import 'package:flutter/material.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
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

  var tutors = [
    'Kuda Chivunga',
    'Thabo Maduna',
    'Farai Chivunga',
    'Simphiwe Ndlovu',
    'Musa Mabasa'
  ];

  var bios = [
    'I am a CS student with a lot of passion',
    'I am an IT student looking to lean more',
    'Hi!!!',
    'Welcome to my page',
    'Engeering student'
  ];

  var ages = [
    '21 years old\n',
    '18 years old\n',
    '20 years old\n',
    '21 years old\n',
    '19 years old\n'
  ];

  var location = ['Hatfield\n', 'Hatfield\n', 'Arcadia\n', 'Hatfield\n', 'Hillcrest'];

  var gender = [
    'Female\n',
    'Female\n',
    'Female\n',
    'Female\n',
    'Female\n',
  ];

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
              title: Text(tutors[i]),
              subtitle: Text(bios[i]),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                TutorProfilePageView(person: tutors[i], bio: bios[i], age: ages[i], location: location[i], gender: gender[i])));
      },
    );
  }
}
