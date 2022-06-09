import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/tutor_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
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
  List<Tutors> saveTutors = List<Tutors>.empty();

  void search(String search) {
    if (search == '') {
      tutorList = saveTutors;
    }
    final tutors = tutorList.where((tutor) {
      final nameToLower = tutor.getName.toLowerCase();
      final query = search.toLowerCase();

      return nameToLower.contains(query);
    }).toList();

    setState(() {
      tutorList = tutors;
      query = search;
    });
  }

  void filterGender(String filter) {
    if (filter == 'Male') {
      filter = 'M';
    } else if (filter == 'Female') {
      filter = 'F';
    } else {
      setState(() {
        tutorList = saveTutors;
      });
    }
    final tutors = tutorList.where((tutor) {
      final tGender = tutor.getGender;

      return tGender.contains(filter);
    }).toList();

    setState(() {
      tutorList = tutors;
    });
  }

  void filterAge(String filter) {
    if (filter == '36+') {
      final tutors = tutorList.where((tutor) {
        bool val = false;

        String strAge = tutor.getAge;
        int age = int.parse(strAge);
        if (age >= 36) {
          val = true;
        }
        return val;
      }).toList();

      setState(() {
        tutorList = tutors;
      });
    }
    String first = "";
    String second = "";
    for (int i = 0; i < 2; i++) {
      first += filter[i];
    }

    for (int i = 3; i < 5; i++) {
      second += filter[i];
    }

    var f = int.parse(first);
    var s = int.parse(second);

    final tutors = tutorList.where((tutor) {
      bool val = false;
      String strAge = tutor.getAge;
      int age = int.parse(strAge);
      for (int i = f; i < s + 1; i++) {
        if (age == i) {
          val = true;
        }
      }
      return val;
    }).toList();

    setState(() {
      tutorList = tutors;
    });
  }

  getTutors() async {
    final tutors = await TutorServices.getTutors();
    setState(() {
      tutorList = tutors;
      saveTutors = tutors;
    });
  }

  @override
  void initState() {
    super.initState();
    getTutors();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                right: MediaQuery.of(context).size.width * 0.0001,
                left: MediaQuery.of(context).size.height * 0.02),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.07,
            child: TextField(
              cursorColor: colorOrange,
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
                            setState(() {
                              tutorList = saveTutors;
                            });
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
          IconButton(
            icon: Icon(
              Icons.filter_alt,
              size: MediaQuery.of(context).size.width * 0.09,
              color: colorOrange,
            ),
            onPressed: () {
              List<String> genders = ['Male', 'Female', 'Gender(Not Selected)'];
              List<String> ages = [
                'Age(Not selected)',
                '16-18',
                '19-21',
                '22-25',
                '26-35',
                '36+'
              ];
              String? selectedGender = 'Gender(Not Selected)';
              String? selectedAge = 'Age(Not selected)';
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        actions: <Widget>[
                          Center(
                            child: DropdownButton<String>(
                                value: selectedGender,
                                items: genders
                                    .map((gender) => DropdownMenuItem<String>(
                                        value: gender, child: Text(gender)))
                                    .toList(),
                                onChanged: (gender) {
                                  Navigator.of(context).pop();
                                  tutorList = saveTutors;
                                  String newGen = gender!;
                                  filterGender(newGen);
                                  setState(() {
                                    selectedGender = gender;
                                  });
                                }),
                          ),
                          Center(
                            child: DropdownButton<String>(
                                value: selectedAge,
                                items: ages
                                    .map((age) => DropdownMenuItem<String>(
                                        value: age, child: Text(age)))
                                    .toList(),
                                onChanged: (age) {
                                  Navigator.of(context).pop();
                                  tutorList = saveTutors;
                                  String newAge = age!;
                                  filterAge(newAge);
                                  setState(() {
                                    selectedAge = age;
                                  });
                                }),
                          ),
                        ],
                      ));
            },
          ),
        ],
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
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
    String name = tutorList[i].getName;
    name += ' ' + tutorList[i].getLastName;
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
                subtitle: Text(tutorList[i].getBio),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(tutorList[i].getRating),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    )
                  ],
                )),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TutorProfilePageView(
                tutor: tutorList[i])));
      },
    );
  }
}
