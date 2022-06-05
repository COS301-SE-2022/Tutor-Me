import 'package:flutter/material.dart';
import '../tutorProfilePages/tutor_profile_view.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/services/tutor_services.dart';
import 'dart:convert';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'theme/themes.dart';

class TutorsList extends StatefulWidget {
  const TutorsList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorsListState();
  }
}

class TutorsListState extends State<TutorsList> {
  List<Tutors> tutorList = List<Tutors>.empty();

  getTutors() {
    TutorServices.getTutors().then((response) {
      setState(() {
        String j = "";
        if (response.body[0] != "[") {
          j = "[" + response.body + "]";
        } else {
          j = response.body;
        }
        Iterable list = json.decode(j);
        tutorList = list.map((model) => Tutors.fromObject(model)).toList();
      });
    });
  }

  List<Tutors> tutors = List<Tutors>.empty();

  void search(String search) {
    setState(() {
      // final tutors = tutorList.where()
    });
  }

  @override
  Widget build(BuildContext context) {
    getTutors();
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
          itemCount: tutorList.length,
          itemBuilder: _cardBuilder,
        ),
      ),
    ])));
  }

  Widget _cardBuilder(BuildContext context, int i) {
    String name = tutorList[i].getFirstName;
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
              leading: CircleAvatar(child: Text(name[0]), backgroundColor: Colors.red),
              title: Text(tutorList[i].getFirstName),
              subtitle: Text(tutorList[i].getBio),
              // trailing: ListView.builder(
              //   itemBuilder: _starBuilder,
              //   itemCount: 5,
              // ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TutorProfilePageView(
                person: tutorList[i].getFirstName,
                bio: tutorList[i].getLocation,
                age: tutorList[i].getAge,
                location: tutorList[i].getLocation,
                gender: tutorList[i].getInstitution)));
      },
    );
  }
}
