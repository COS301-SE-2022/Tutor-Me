import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'tuteeProfilePages/tutee_data.dart';
// import 'theme/themes.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UpcomingState();
  }
}

class UpcomingState extends State<Upcoming> {
  var titles = [
    'COS301 - Software Engineering Meeting',
    'COS326 - Database Management Meeting',
    'COS341 - Compiler Construction Meeting',
    'COS332 - Operating Systems Meeting',
  ];

  var dates = [
    '2021-09-01',
    '2021-09-02',
    '2021-09-03',
    '2021-09-04',
  ];

  var times = [
    '10:00',
    '11:00',
    '12:00',
    '13:00',
  ];

  var tutors = [
    'Ladeb Sibanda',
    'Kuda Chivunga',
    'Thabo Maduna',
    'Simphiwe Ndlovu'
  ];

  List<Color> colors = [
    const Color.fromARGB(255, 243, 109, 0),
    const Color.fromARGB(255, 12, 123, 214),
    const Color.fromARGB(255, 106, 155, 42),
    const Color.fromARGB(255, 255, 230, 0),
  ];

  void search(String search) {
    setState(() {
      //  tutors = tutors.where((tu) => false)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          // padding: const EdgeInsets.all(10),
          itemCount: 4,
          itemBuilder: _cardBuilder,
        ),
      ),
    );
  }

  Widget _cardBuilder(BuildContext context, int i) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.155,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.155,
                  width: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                    color: colors[i],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      titles[i],
                      style: TextStyle(
                        color: colorBlack,
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.height * 0.018,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.001,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 36, 35, 35)
                            .withOpacity(0.2),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text("Date: " + dates[i],
                        style: TextStyle(
                          color: colorDarkGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.height * 0.018,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text("Time: " + times[i],
                        style: TextStyle(
                          color: colorDarkGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.height * 0.018,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(children: <Widget>[
                      Text(
                        "Created by - Tutor: ",
                        style: TextStyle(
                          color: colorBlueTeal,
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.height * 0.018,
                        ),
                      ),
                      Text(tutors[i],
                          style: TextStyle(
                            color: colorDarkGrey,
                            fontWeight: FontWeight.w500,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.018,
                          )),
                    ])
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
