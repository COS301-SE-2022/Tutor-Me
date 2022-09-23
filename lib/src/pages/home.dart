// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/constants/colors.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/book_for_tutor.dart';
import 'package:tutor_me/src/pages/calendar.dart';
import '../../services/models/globals.dart';
import '../../services/models/users.dart';
import '../../services/services/user_services.dart';
import '../theme/themes.dart';
import '../tutorAndTuteeCollaboration/tuteeGroups/home_tutee_groups.dart';

class Home extends StatefulWidget {
  final Globals globals;
  const Home({Key? key, required this.globals}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var gridCount = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 800) {
      gridCount = 3;
    } else {
      gridCount = 2;
    }

    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        buildBody(),
        // buildBody(),
      ],
    ));
  }

  late Uint8List tuteeImage;
  bool doesUserImageExist = false;
  bool isImageLoading = true;
  late UserType userType;

  getTuteeProfileImage() async {
    try {
      final image = await UserServices.getTuteeProfileImage(
          widget.globals.getUser.getId, widget.globals);

      setState(() {
        tuteeImage = image;
        doesUserImageExist = true;
        isImageLoading = false;
      });
    } catch (e) {
      setState(() {
        isImageLoading = false;
        tuteeImage = Uint8List(128);
      });
    }
  }

  getUserType() async {
    try {
      final type = await UserServices.getUserType(
          widget.globals.getUser.getUserTypeID, widget.globals);

      userType = type;
      getTuteeProfileImage();
    } catch (e) {
      getTuteeProfileImage();
    }
  }

  int key = 0;

  Map<String, double> dataMap = {
    "Meetings - 2": 2,
    "Connections - 3": 3,
    "Interactions - 2": 2,
    "Ratings - 2": 2,
  };

  List<Color> chartColorList = [
    Colors.blue,
    colorLightGreen,
    colorOrange,
    Colors.yellow,
  ];

  Widget buildChart() {
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

    return PieChart(
      key: ValueKey(key),
      centerText: "Activity",
      dataMap: dataMap,
      initialAngleInDegree: 0,
      animationDuration: const Duration(milliseconds: 3500),
      chartType: ChartType.ring,
      ringStrokeWidth: 15,
      colorList: chartColorList,
      chartLegendSpacing: 34,
      chartRadius: MediaQuery.of(context).size.height / 6.6,
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: true,
        decimalPlaces: 1,
        chartValueStyle: TextStyle(
          background: Paint()..color = secondaryColor,
          color: colorDarkGrey,
          fontWeight: FontWeight.normal,
          fontSize: MediaQuery.of(context).size.height * 0.015,
        ),
      ),
      // centerText: 'Progress',
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.rectangle,
        legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: MediaQuery.of(context).size.width * 0.03),
      ),
    );
  }
  // List<

  // _generateData() {
  //   var data = [
  //     Task(
  //       task: 'Meetings',
  //       taskValue: 35.8,
  //       color: const Color(0xff3366cc),
  //     ),
  //     Task(task: 'Connections', taskValue: 4, color: colorOrange),
  //     Task(task: 'Badges', taskValue: 1, color: colorLightGreen),
  //     Task(task: 'OverAll', taskValue: 32, color: colorBlueTeal),
  //   ];
  // }

  @override
  void initState() {
    super.initState();
    getUserType();
  }

  Widget buildBody() {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    // Color appBarColor1;
    // Color appBarColor2;
    Color highlightColor;
    Color textColor;
    Color cardBackground;

    if (provider.themeMode == ThemeMode.dark) {
      highlightColor = colorOrange;
      textColor = colorWhite;
      cardBackground = const Color.fromARGB(255, 104, 104, 104);
    } else {
      // appBarColor1 = colorLightBlueTeal;
      // appBarColor2 = colorBlueTeal;
      highlightColor = colorOrange;
      textColor = colorBlack;
      cardBackground = colorWhite;
    }
    final screenHeightSize = MediaQuery.of(context).size.height;
    final screenWidthSize = MediaQuery.of(context).size.width;
    final images = [
      "assets/Pictures/book.jpg",
      "assets/Pictures/groups.jpg",
      "assets/Pictures/calendar.jpg",
      "assets/Pictures/studentt.jpg",
      "assets/Pictures/badges.jpg",
    ];
    final titles = [
      "Book a Tutor",
      "Groups",
      "Calendar",
      "Tutees",
      "Badges",
    ];
    final numberStats = [
      "more info",
      "1",
      "more info",
      "3",
      "1",
    ];
    String name = widget.globals.getUser.getName;
    String fullName = name + ' ' + widget.globals.getUser.getLastName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: screenHeightSize * 0.02),
        Padding(
          padding: EdgeInsets.only(left: screenWidthSize * 0.1),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.09,
            decoration: const BoxDecoration(
                // color: Color.fromARGB(120, 250, 247, 247),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Row(
              children: <Widget>[
                SizedBox(width: screenWidthSize * 0.02),
                CircleAvatar(
                  backgroundColor: colorOrange,
                  radius: MediaQuery.of(context).size.width * 0.08,
                  child: isImageLoading
                      ? const CircularProgressIndicator.adaptive()
                      : doesUserImageExist
                          ? ClipOval(
                              child: Image.memory(
                                tuteeImage,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.width * 0.2,
                              ),
                            )
                          : ClipOval(
                              child: Image.asset(
                              "assets/Pictures/penguin.png",
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.253,
                              height: MediaQuery.of(context).size.width * 0.253,
                            )),
                ),
                SizedBox(width: screenWidthSize * 0.02),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.01),
                      child: Text(
                        fullName,
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeightSize * 0.025),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "  Tutee",
                          style: TextStyle(
                            color: highlightColor,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenWidthSize * 0.075, top: screenHeightSize * 0.02),
          child: Container(
            width: screenWidthSize > 800 ? 500 : screenWidthSize * 0.85,
            height: screenHeightSize * 0.25,
            decoration: BoxDecoration(
                // color: Colors.black38,
                border: Border.all(color: colorBlueTeal.withOpacity(0.3)),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: buildChart(),
          ),
        ),
        SizedBox(height: screenHeightSize * 0.02),
        Padding(
          padding: EdgeInsets.only(left: screenWidthSize * 0.1),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.circle,
                color: highlightColor,
                size: screenHeightSize * 0.017,
              ),
              SizedBox(width: screenWidthSize * 0.02),
              Row(
                children: [
                  Text(
                    "12.8% ",
                    style: TextStyle(
                      color: colorLightGreen,
                      fontSize: screenHeightSize * 0.03,
                    ),
                  ),
                  Text(
                    "above average ",
                    style: TextStyle(fontSize: screenHeightSize * 0.025),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidthSize * 0.11),
          child: Container(
            height: screenHeightSize * 0.03,
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(width: 2, color: secondaryColor)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidthSize * 0.1),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.circle,
                color: highlightColor,
                size: screenHeightSize * 0.017,
              ),
              SizedBox(width: screenWidthSize * 0.02),
              Text(
                "What do the stats mean ?...",
                style: TextStyle(
                    fontSize: screenHeightSize * 0.025, color: textColor),
              ),
              Text(
                "more info",
                style: TextStyle(color: highlightColor),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenWidthSize * 0.1, top: screenHeightSize * 0.05),
          child: Text(
            "Dashboard",
            style: TextStyle(
                fontSize: screenHeightSize * 0.039,
                fontWeight: FontWeight.bold,
                color: textColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: screenHeightSize * 0.015, bottom: screenHeightSize * 0.015),
          child: Divider(
            color: colorGrey.withOpacity(0.3), //color of divider
            height: 2, //height spacing of divider
            thickness: 1, //thickness of divier line
            indent: 32, //spacing at the start of divider
            endIndent: 35, //spacing at the end of divider
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidthSize * 0.1),
          child: SizedBox(
            height: screenHeightSize * 0.6,
            width: screenWidthSize * 0.8,
            child: GridView.count(
              childAspectRatio: 1,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: gridCount,
              children: List<Widget>.generate(5, (index) {
                return GridTile(
                  child: GestureDetector(
                    onTap: () {
                      if (index == 3) {
                        //render Tutees Page
                      } else if (index == 1) {
                        //render Groups Page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeTuteeGroups(globals: widget.globals)));
                      } else if (index == 4) {
                        //render Badges Page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => const Badges()));
                      } else if (index == 2) {
                        //render Calendar Page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Calendar(globals: widget.globals)));
                      } else if (index == 0) {
                        //render Book for a tutor Page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => BookForTutor(
                                  globals: widget.globals,
                                )));
                      }
                    },
                    child: Card(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeightSize * 0.02,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02),
                        color: cardBackground,
                        child: Center(
                          child: Container(
                            width: screenWidthSize * 0.4,
                            height: screenHeightSize * 0.2,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(50, 193, 193, 193),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: screenHeightSize * 0.09,
                                  width: screenWidthSize * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    image: DecorationImage(
                                      image: AssetImage(images[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: screenWidthSize * 0.01),
                                  // ignore: unnecessary_string_interpolations
                                  child: Text(
                                    titles[index],
                                    style: TextStyle(
                                        fontSize: screenHeightSize * 0.025,
                                        fontWeight: FontWeight.w500,
                                        color: colorDarkGrey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: screenWidthSize * 0.01,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.circle,
                                        color: colorLightGreen,
                                        size: screenHeightSize * 0.015,
                                      ),
                                      SizedBox(width: screenWidthSize * 0.02),
                                      Text(
                                        numberStats[index],
                                        style: TextStyle(
                                            fontSize: screenHeightSize * 0.025,
                                            fontWeight: FontWeight.w400,
                                            color: colorDarkGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                );
              }),
            ),
          ),
        )
      ],
    );
  }
}

class Task {
  String task;
  double taskValue;
  Color color;

  Task({required this.task, required this.taskValue, required this.color});
}
