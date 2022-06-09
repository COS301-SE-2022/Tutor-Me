import 'package:flutter/material.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';

class TuteesList extends StatefulWidget {
  const TuteesList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteesListState();
  }
}

class TuteesListState extends State<TuteesList> {
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

  var location = [
    'Hatfield\n',
    'Hatfield\n',
    'Arcadia\n',
    'Hatfield\n',
    'Hillcrest'
  ];

  var gender = [
    'Female\n',
    'Female\n',
    'Female\n',
    'Female\n',
    'Female\n',
  ];

  void search(String search) {
    setState(() {
      //  tutors = tutors.where((tu) => false)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      Container(
        margin: const EdgeInsets.all(15),
        height: 50,
        child: TextField(
          onChanged: (value) => search(value),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(0),
              
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black45,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.circular(50),
              ),
              hintStyle: const TextStyle(
                fontSize: 14,
              ),
              hintText: "Search for Tutors..."),
        ),
      ),
      SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          // padding: const EdgeInsets.all(10),
          itemCount: 5,
          itemBuilder: _cardBuilder,
        ),
      ),
    ])));
  }

  Widget _cardBuilder(BuildContext context, int i) {
    String name = tutors[i];
    return GestureDetector(
      child: Card(
        elevation: 7.0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                  child: Text(name[0]), backgroundColor: Colors.red),
              title: Text(name),
              subtitle: Text(bios[i]),
              // trailing: ListView.builder(
              //   itemBuilder: _starBuilder,
              //   itemCount: 5,
              // ),
            ),
          ],
        ),
      ),
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (BuildContext context) => TutorProfilePageView(
        //         person: tutors[i],
        //         bio: bios[i],
        //         age: ages[i],
        //         location: location[i],
        //         gender: gender[i])));
      },
    );
  }
}
