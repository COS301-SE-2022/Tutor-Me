import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/tutor_services.dart';
import '../tutorProfilePages/tutor_profile_view.dart';
import 'package:tutor_me/services/models/tutors.dart';
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
  // TutorRepo tutorRepo = TutorRepo();
  String query = '';
  final textControl = TextEditingController();
  List<Tutors> tutorList = List<Tutors>.empty();

  void search(String search) {
    final tutors = tutorList.where((tutor) {
      final nameToLower = tutor.getFirstName.toLowerCase();
      final query = search.toLowerCase();

      return nameToLower.contains(query);
    }).toList();

    setState(() {
      tutorList = tutors;
      query = search;
    });
  }

  getTutors() async {
    final tutors = await TutorServices.getTutors();
    setState(() {
      tutorList = tutors;
    });
  }

  @override
  void initState() {
    super.initState();
    getTutors();
  }

  @override
  Widget build(BuildContext context) {
    if (query == '') {
      getTutors();
    }
    return Material(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      Container(
        margin: const EdgeInsets.all(15),
        height: 50,
        child: TextField(
          onChanged: (value) => search(value),
          controller: textControl,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(0),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black45,
              ),
              suffixIcon: query.isNotEmpty
                  ? GestureDetector(
                      child: const Icon(
                        Icons.close,
                        color: Colors.black45,
                      ),
                      onTap: () {
                        textControl.clear();
                      },
                    )
                  : null,
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
              leading: CircleAvatar(
                  child: Text(name[0]), backgroundColor: Colors.red),
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
                bio: tutorList[i].getBio,
                age: tutorList[i].getAge.toString(),
                location: tutorList[i].getLocation,
                gender: tutorList[i].getInstitution)));
      },
    );
  }
}
