import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/src/colorpallete.dart';
// import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/tutor_explore.dart';

import '../../services/models/globals.dart';
import '../theme/themes.dart';

class BookForTutor extends StatefulWidget {
  final Globals globals;
  const BookForTutor({Key? key, required this.globals}) : super(key: key);

  @override
  State<BookForTutor> createState() => _BookForTutorState();
}

class _BookForTutorState extends State<BookForTutor> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color primaryColor;
    Color secondaryColor;
    Color textColor;
    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      primaryColor = colorGrey;
      textColor = colorWhite;
      highLightColor = colorLightBlueTeal;
      secondaryColor = colorLightGrey;
    } else {
      primaryColor = colorBlueTeal;
      textColor = colorDarkGrey;
      highLightColor = colorOrange;
      secondaryColor = colorWhite;
    }

    double widthOfScreen = MediaQuery.of(context).size.width;
    double heightOfScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(

        title: const Text("Book for Tutor"),
        backgroundColor: primaryColor,
      ),
      body: Column(children: [
        SizedBox(
          height: heightOfScreen * 0.02,
        ),
        Center(
          child: Container(
            width: widthOfScreen * 0.9,
            height: heightOfScreen * 0.25,
            decoration: BoxDecoration(
              color: colorLightGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: widthOfScreen * 0.08,
                  height: heightOfScreen * 0.25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/Pictures/profileBackground.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  width: widthOfScreen * 0.05,
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: heightOfScreen * 0.02,
                    ),
                    Center(
                      child: Text(
                        "Booked Upcoming apointments: ",
                        style: TextStyle(
                          fontSize: widthOfScreen * 0.05,
                          fontWeight: FontWeight.bold,
                          color: highLightColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heightOfScreen * 0.01,
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
                      height: heightOfScreen * 0.01,
                    ),
                    Center(
                      child: Text(
                        "You have no upcoming appointments",
                        style: TextStyle(
                          fontSize: widthOfScreen * 0.04,
                          fontWeight: FontWeight.w300,
                          color: highLightColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: heightOfScreen * 0.06,
        ),
        SizedBox(
          width: widthOfScreen * 0.9,
          height: heightOfScreen * 0.08,
          child: Row(
            children: [
              Icon(Icons.info_outline,
                  size: widthOfScreen * 0.08, color: highLightColor),
              Flexible(
                child: Text(
                    "Explore the available tutors and book for One time sessions.",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: widthOfScreen * 0.05,
                      fontWeight: FontWeight.normal,
                      color: textColor,
                    )),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.02),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "moreInfo",
              style: TextStyle(
                fontSize: widthOfScreen * 0.05,
                fontWeight: FontWeight.normal,
                color: primaryColor,
              ),
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TutorExplore(
                            globals: widget.globals,
                          )),
                );
              },
              child: Container(
                width: widthOfScreen * 0.6,
                height: heightOfScreen * 0.065,
                decoration: BoxDecoration(
                  color: colorOrange,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "  Explore",
                    style: TextStyle(
                      fontSize: widthOfScreen * 0.05,
                      fontWeight: FontWeight.bold,
                      color: colorWhite,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
