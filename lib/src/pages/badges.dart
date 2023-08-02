import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/services/user_badges.dart';
import 'package:tutor_me/src/colorpallete.dart';

import '../../services/models/badges.dart' as bad;
import '../../services/models/globals.dart';
import '../../services/models/user_badges.dart';
import '../../services/services/badges_services.dart';
import '../theme/themes.dart';

// ignore: must_be_immutable
class Badges extends StatefulWidget {
  Globals globals;
  Badges({Key? key, required this.globals}) : super(key: key);

  @override
  State<Badges> createState() => _PageState();
}

class _PageState extends State<Badges> {
  List<bad.Badge> allBadges = List<bad.Badge>.empty(growable: true);
  List<UserBadge> userBadges = List<UserBadge>.empty(growable: true);
  List<String> userBadgeIds = List<String>.empty(growable: true);
  List<String> userBadgeNames = List<String>.empty(growable: true);
  bool isLoading = true;
  List<String> titles = List<String>.empty(growable: true);
  List<String> descriptions = List<String>.empty(growable: true);
  List<String> images = List<String>.empty(growable: true);

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
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  getAllBadges() async {
    log("bbi ");

    try {
      var badges = await BadgesServices.getAllBages(widget.globals);
      allBadges = badges;

      for (int i = 0; i < allBadges.length; i++) {
        titles.add(allBadges[i].getName);
      }

      for (int i = 0; i < allBadges.length; i++) {
        descriptions.add(allBadges[i].getDescription);
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
    return Scaffold(
      body: (isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                topDesign(),
                buildBody(allBadges),
                // buildBody(),
              ],
            )),
    );
  }

  Widget topDesign() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: const EdgeInsets.only(bottom: 78),
            child: buildCoverImage()),
        Positioned(
          top: 100,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildProfileImage() => CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.139,
        backgroundColor: colorBlueTeal,
        child: ClipOval(
          child: Image.asset(
            "assets/Pictures/student.jpg",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.268,
            height: MediaQuery.of(context).size.width * 0.268,
          ),
        ),
      );

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image(
          image: const AssetImage('assets/Pictures/badges.jpg'),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.22,
          fit: BoxFit.cover,
        ),
      );

  Widget buildBody(List<bad.Badge> allBadges) {
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

    final screenHeightSize = MediaQuery.of(context).size.height;
    final screenWidthSize = MediaQuery.of(context).size.width;

    //   "10 Consecutive Days",
    //   "Attend 5 Meetings",
    //   "Chose modules",
    //   "1st Connection",
    //   "1st Meeting",
    //   "1st Review",
    //   "1st Rating",
    //   "1st Tutor request",
    //   "20 Consecutive Days",
    //   "Attend 10 Meetings",
    //   "30 Consecutive Days",
    //   "Attend 20 Meetings",
    //   "40 Consecutive Days",
    //   "Attend 50 Meetings",
    //   "50 Consecutive Days",
    // ];

    // ignore: unused_local_variable
    // final descriptions = [
    //   "You have registered with TutorMe",
    //   "You have attended 10 consecutive days",
    //   "You have attended 5 meetings",
    //   "You have chosen your modules",
    //   "You have made your first connection",
    //   "You have made your first meeting",
    //   "You have made your first review",
    //   "You have made your first rating",
    //   "You have made your first tutor request",
    //   "You have attended 20 consecutive days",
    //   "You have attended 10 meetings",
    //   "You have attended 30 consecutive days",
    //   "You have attended 20 meetings",
    //   "You have attended 40 consecutive days",
    //   "You have attended 50 meetings",
    //   "You have attended 50 consecutive days",
    // ];

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(screenWidthSize * 0.1),
                bottomRight: Radius.circular(screenWidthSize * 0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: screenWidthSize * 0.05),
                  child: Text(
                    'All Badges',
                    style: TextStyle(
                        fontSize: screenWidthSize * 0.06,
                        fontWeight: FontWeight.bold,
                        color: highLightColor),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.04,
              left: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Text(
              "Earned Badges",
              style: TextStyle(
                  fontSize: screenWidthSize * 0.05,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.1),
            thickness: 1,
            indent: screenWidthSize * 0.05,
            endIndent: screenWidthSize * 0.05,
          ),
          (userBadgeNames.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: SizedBox(
                    height: screenHeightSize * 0.25,
                    width: screenWidthSize * 1,
                    child: GridView.count(
                      childAspectRatio: 1,
                      crossAxisCount: 3,
                      children:
                          List<Widget>.generate(userBadges.length, (index) {
                        return GridTile(
                          child: GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.015),
                              child: Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: screenHeightSize * 0,
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.02),
                                  color: colorWhite,
                                  child: Center(
                                    child: Container(
                                      width: screenWidthSize * 0.4,
                                      height: screenHeightSize * 0.5,
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(50, 193, 193, 193),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: screenHeightSize * 0.09,
                                            width: screenWidthSize * 0.4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10)),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  images[index],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: screenWidthSize * 0.01,
                                                right: screenWidthSize * 0.01,
                                              ),
                                              child: Text(
                                                userBadgeNames[index],
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize:
                                                        screenHeightSize * 0.02,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    const Text("No Badges Earned Yet"),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.celebration,
                            color: highLightColor,
                          ),
                          Text(
                            "Congratulations! on Registering",
                            style: TextStyle(color: highLightColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ))),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.04,
              left: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Text(
              "To - Be - Earned Badges",
              style: TextStyle(
                  fontSize: screenWidthSize * 0.05,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.1),
            thickness: 1,
            indent: screenWidthSize * 0.05,
            endIndent: screenWidthSize * 0.05,
          ),
          (titles.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: SizedBox(
                    height: screenHeightSize * 2.1,
                    width: screenWidthSize * 1,
                    child: GridView.count(
                      childAspectRatio: 1,
                      crossAxisCount: 3,
                      physics: const NeverScrollableScrollPhysics(),
                      children:
                          List<Widget>.generate(allBadges.length, (index) {
                        return GridTile(
                          child: GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.015),
                              child: Stack(
                                children: <Widget>[
                                  Card(
                                      margin: EdgeInsets.symmetric(
                                          vertical: screenHeightSize * 0,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      color: colorWhite,
                                      child: Center(
                                        child: Container(
                                          width: screenWidthSize * 0.4,
                                          height: screenHeightSize * 0.5,
                                          decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  50, 193, 193, 193),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02),
                                              Container(
                                                height: screenHeightSize * 0.07,
                                                width: screenWidthSize * 0.4,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                      // "assets/Pictures/badges/streak.png",
                                                      images[index],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: screenWidthSize * 0.01,
                                                    left:
                                                        screenWidthSize * 0.01,
                                                    right:
                                                        screenWidthSize * 0.01,
                                                  ),
                                                  child: Text(
                                                    allBadges[index].getName,
                                                    style: TextStyle(
                                                        color: textColor,
                                                        fontSize:
                                                            screenHeightSize *
                                                                0.016,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                            overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                  Positioned(
                                    top: screenHeightSize * 0.00055,
                                    left: screenWidthSize * 0.012,
                                    child: Container(
                                      height: screenHeightSize * 0.14,
                                      width: screenWidthSize * 0.29,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              (BorderRadius.circular(8)),
                                          color: colorBlack.withOpacity(0.5)),
                                      child: Icon(
                                        Icons.lock,
                                        color: colorWhite,
                                        size: screenHeightSize * 0.05,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.celebration_outlined,
                          size: MediaQuery.of(context).size.height * 0.1,
                          color: highLightColor,
                        ),
                        Text(
                          "You have earned all the badges",
                          style: TextStyle(
                              fontSize: screenWidthSize * 0.05,
                              fontWeight: FontWeight.bold,
                              color: colorGreen),
                        ),
                      ],
                    ),
                  ),
                )),
        ]);
  }
}
