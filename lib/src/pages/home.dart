// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/constants/colors.dart';
import 'package:tutor_me/services/models/user_badges.dart';
import 'package:tutor_me/services/services/badges_services.dart';
import 'package:tutor_me/services/services/group_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/book_for_tutor.dart';
import 'package:tutor_me/src/pages/calendar.dart';
import 'package:tutor_me/src/pages/woah_factor_nav.dart';
import '../../services/models/badges.dart';
import '../../services/models/globals.dart';
import '../../services/models/groups.dart';
import '../../services/models/users.dart';
import '../../services/services/user_badges.dart';
import '../../services/services/user_services.dart';
import '../theme/themes.dart';
import '../tutorAndTuteeCollaboration/tuteeGroups/home_tutee_groups.dart';
import 'connections.dart';

class Home extends StatefulWidget {
  final Globals globals;
  const Home({Key? key, required this.globals}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var gridCount = 0;
  List<Badge> allBadges = List.empty(growable: true);
  List<UserBadge> userBadges = List.empty(growable: true);
  List<String> userBadgeIds = List.empty(growable: true);
  List<String> userBadgeNames = List.empty(growable: true);
  bool isLoading = true;
  int numBadges = -1;

  getAllEarnedBadges() async {
    try {
      var badges = await UserBadges.getAllUserBadgesByUserId(widget.globals);

      userBadges = badges;

      log(userBadges.length.toString());

      log("user badges: " + userBadges.toString());
      log("all badges: " + allBadges.toString());

      for (int x = 0; x < userBadges.length; x++) {
        allBadges.removeWhere((badge) =>
            badge.getBadgeId == userBadges[x].getBadgeId &&
            badge.getPointsToAchieve <= userBadges[x].getPointAchieved);
      }

      for (var allBadge in allBadges) {
        userBadges.removeWhere((userBadge) =>
            userBadge.getBadgeId == allBadge.getBadgeId &&
            userBadge.getPointAchieved <= allBadge.getPointsToAchieve);
      }

      for (int i = 0; i < userBadges.length; i++) {
        userBadgeIds.add(userBadges[i].getBadgeId);
      }

      for (int i = 0; i < widget.globals.getBadges.length; i++) {
        for (int j = 0; j < userBadgeIds.length; j++) {
          if (widget.globals.getBadges[i].getBadgeId == userBadgeIds[j]) {
            userBadgeNames.add(widget.globals.getBadges[i].getName);
          }
        }
      }

      numBadges = userBadgeNames.length;
      setState(() {
        numBadges = userBadgeNames.length;
      });
    } catch (e) {
      log(e.toString());
    }

    getUserType();
  }

  getAllBadges() async {
    try {
      var badges = await BadgesServices.getAllBages(widget.globals);
      allBadges = badges;
      List<String> titles = List.empty(growable: true);
      List<String> images = List.empty(growable: true);

      for (int i = 0; i < allBadges.length; i++) {
        titles.add(allBadges[i].getName);
      }

      for (int i = 0; i < allBadges.length; i++) {
        if (titles[i].contains("connect")) {
          log("connext " + titles[i]);
          images.add("assets/Pictures/badges/connections.png");
        } else if (titles[i].contains("streak") ||
            titles[i].contains("conse")) {
          log("streak " + titles[i]);

          images.add("assets/Pictures/badges/streak.png");
        } else if (titles[i].contains("rat")) {
          log("rat " + titles[i]);

          images.add("assets/Pictures/badges/rating.png");
        } else {
          log("j " + titles[i]);

          images.add("assets/Pictures/badges/star.png");
        }
      }

      log("message " + images.toString());
    } catch (e) {
      log(e.toString());
    }

    getAllEarnedBadges();
  }

  @override
  void initState() {
    super.initState();
    getAllBadges();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 800) {
      gridCount = 3;
    } else {
      gridCount = 2;
    }

    int meetings = 2;
    int connections = 2;
    int interactions = 2;
    int ratings = 2;

    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        buildBody(meetings, connections, interactions, ratings),
        // buildBody(),
      ],
    ));
  }

  late Uint8List tuteeImage;
  bool doesUserImageExist = false;
  bool isImageLoading = true;
  late UserType userType;
  int numConnections = -1;
  int numGroups = -1;
  List<Users> userChats = List<Users>.empty();
  List<Groups> groups = List<Groups>.empty();
  String typeUser = '';
  String bookingsText = '';
  SharedPreferences? prefs;

  void getUserType() async {
    if (widget.globals.getUser.getUserTypeID[0] == '9') {
      setState(() {
        typeUser = 'Tutor';
        bookingsText = 'Single Bookings';
      });
    } else {
      setState(() {
        typeUser = 'Tutee';
        bookingsText = 'Book a Tutor ';
      });
    }

    getConnections();
  }

  void getGroupCount() async {
    try {
      if (widget.globals.getUser.getUserTypeID[0] == '9') {
        groups = await GroupServices.getTutorGroupByUserID(
            widget.globals.getUser.getId, widget.globals);
      } else {
        groups = await GroupServices.getTuteeGroupByUserID(
            widget.globals.getUser.getId, widget.globals);
      }
      numGroups = groups.length;

      setState(() {
        log("groups lemdth " + numGroups.toString());
        numGroups = numGroups;
      });
    } catch (e) {
      log(e.toString());
    }

    getTuteeProfileImage();
  }

  void getConnections() async {
    try {
      userChats = await UserServices.getConnections(
          widget.globals.getUser.getId,
          widget.globals.getUser.getUserTypeID,
          widget.globals);
      numConnections = userChats.length;

      setState(() {
        numConnections = userChats.length;
      });
      // getChatsProfileImages();
    } catch (e) {
      log(e.toString());
      // getChatsProfileImages();
    }
    getGroupCount();
  }

  getTuteeProfileImage() async {
    prefs = await SharedPreferences.getInstance();
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
    setState(() {
      final meetingCount = prefs!.getInt('meetingCount');
      final interactionCount = prefs!.getInt('interactionCount');
        dataMap = {
          "Meetings":  meetingCount == null? 0 : meetingCount.toDouble(),
          "Connections": numConnections.toDouble(),
          "Interactions": interactionCount == null? 0 : interactionCount.toDouble(),
          "Ratings": 2,
        };

        if(meetingCount !=null)
        {
          
        }

      isLoading = false;
      isImageLoading = false;
    });
  }

  int key = 0;

  Map<String, double> dataMap = {
    "Meetings": 2,
    "Connections": 2,
    "Interactions": 2,
    "Ratings": 2,
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

  Widget buildBody(
      int meetings, int connections, int interactions, int ratings) {
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
    List<String> titles;

    if (widget.globals.getUser.getUserTypeID[0] == '9') {
      titles = [
        "Bookings",
        "Groups",
        "Calendar",
        "Tutees",
        "Badges",
      ];
    } else {
      titles = [
        "Book a Tutor",
        "Groups",
        "Calendar",
        "Tutors",
        "Badges",
      ];
    }

    List<String> numberStats;

    if (numBadges == -1) {
      numberStats = [
        "more info",
        "1",
        "more info",
        "0",
        "1",
      ];
    } else {
      numberStats = [
        "more info",
        "1",
        "more info",
        numBadges.toString(),
        numConnections.toString(),
      ];
    }

    if (numGroups != -1 || numConnections != -1 || numBadges != -1) {
      numberStats = [
        "more info",
        numGroups.toString(),
        "more info",
        numConnections.toString(),
        numBadges.toString(),
      ];
    }

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
                          " " + typeUser,
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
                widget.globals.getUser.getIsVerified
                    ? Icon(
                        Icons.verified,
                        color: colorGreen,
                        size: screenHeightSize * 0.03,
                      )
                    : Container(),
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
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WoahFactorNav(
                          meetings: prefs?.getInt('meetingCount') ?? 0,
                          connections: numConnections,
                          interactions: prefs?.getInt('interactionCount') ?? 0,
                          ratings: ratings),
                    ),
                  );
                },
                child: Text(
                  "more info",
                  style: TextStyle(color: highlightColor),
                  overflow: TextOverflow.ellipsis,
                ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Connections(
                                      globals: widget.globals,
                                      stringUserType: titles[3],
                                    )));
                      } else if (index == 1) {
                        //render Groups Page

                        if (widget.globals.getUser.getUserTypeID[0] == '9') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeTuteeGroups(
                                      globals: widget.globals)));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeTuteeGroups(
                                      globals: widget.globals)));
                        }
                      } else if (index == 4) {
                        //render Badges Page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Badges(
                                  globals: widget.globals,
                                )));
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
                                      color: colorDarkGrey,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                                            fontSize: screenHeightSize * 0.019,
                                            fontWeight: FontWeight.w400,
                                            color: colorDarkGrey,
                                            overflow: TextOverflow.ellipsis),
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
