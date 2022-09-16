// ignore_for_file: sort_child_properties_last, file_names, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.2,
          flexibleSpace: Container(
            width: MediaQuery.of(context).size.width * 1,
            // height: MediaQuery.of(context).size.height * 0.2,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Pictures/about.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: Text(
                "About",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  "The Tutor Me project is an idea that aims to provide a platform where students that "
                          " need help academically can easily find a tutor that can help them with specific modules."
                          "This project will be useful especially now that the covid-19 pandemic has made it much "
                          " difficult to have face-to-face conversations, ask for help with their studies from fellow" +
                      " students, and interact with lecturers for additional assistance. As with the rest of the" +
                      "world, every matter related to students is moving towards being digital and virtual." +
                      " This project focuses on providing a platform to ease the process of: Registering as " +
                      " a Tutor that can tutor certain modules for a price, Registering as a Tutee that needs" +
                      " a tutor for certain modules, The tutor should be able to select the modules he/she tutors" +
                      " for a fee, The tutee should be able to choose which subject they need help with from " +
                      " certain tutors, One-on-one chat functionality between Tutees and Tutors, Group chat " +
                      " creation for students requiring assistance with the same modules or subjects, Sending and " +
                      " receiving notifications when Tutor is found Video calling functionality in-app to allow students" +
                      " to virtually meet After implementing these core functionalities of this project, we would start " +
                      " looking at additional functionalities like filtering tutors by gender to enable students to choose " +
                      " someone that they are comfortable with. We would also look into implementing a dark mode of the app " +
                      " for users that prefer it over light mode. The project will be implemented as a cross platform mobile" +
                      " app for Android and iOS.",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.055,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.height * 0.02),
              child: Text(
                "1. Email: capson301@gmail.com",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.height * 0.02),
              child: Text(
                "Please feel free to contact us with any queries or suggestions you may have. We would be happy to hear from you.",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
