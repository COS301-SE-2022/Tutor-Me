import 'package:flutter/material.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
import '../tutorProfilePages/tutor_profile_view.dart';
import '../Navigation/nav_drawer.dart';
import '../tuteeProfilePages/tutee_data.dart';
import '../theme/themes.dart';

class Tutor extends StatefulWidget {
  const Tutor({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorState();
  }
}

class TutorState extends State<Tutor> {
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
    // TODO: implement build
    throw UnimplementedError();
  }
}
