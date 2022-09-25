import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/src/colorpallete.dart';

import '../../services/models/badges.dart';
import '../../services/models/globals.dart';
import '../../services/services/badges_services.dart';
import '../theme/themes.dart';

class Badges extends StatefulWidget {
  Globals globals;
  Badges({Key? key, required this.globals}) : super(key: key);

  @override
  State<Badges> createState() => _PageState();
}

class _PageState extends State<Badges> {
  List<Badge> allBadges = List<Badge>.empty(growable: true);
  bool isLoading = true;

  getAllBadges() async {
    log("bbi ");

    try {
      var badges = await BadgesServices.getAllBages(widget.globals);
      allBadges = badges;
      log("bbi " + badges.toString());
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllBadges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        topDesign(),
        buildBody(allBadges),
        // buildBody(),
      ],
    ));
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

  Widget buildBody(List<Badge> allBadges) {
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

    final myBages = [
      "Registered",
    ];

    List<String> titles = List<String>.empty(growable: true);
    List<String> descriptions = List<String>.empty(growable: true);
    List<String> images = List<String>.empty(growable: true);

    for (int i = 0; i < allBadges.length; i++) {
      titles.add(allBadges[i].getName);
    }

    for (int i = 0; i < allBadges.length; i++) {
      descriptions.add(allBadges[i].getDescription);
    }

    for (int i = 0; i < allBadges.length; i++) {
      images.add(allBadges[i].getImage);
    }
    if (images.length > 0) log(images[0] + " images");

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
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: SizedBox(
              height: screenHeightSize * 0.2,
              width: screenWidthSize * 1,
              child: GridView.count(
                childAspectRatio: 1,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: List<Widget>.generate(myBages.length, (index) {
                  return GridTile(
                    child: GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.015),
                        child: Card(
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeightSize * 0,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.02),
                            color: colorWhite,
                            child: Center(
                              child: Container(
                                width: screenWidthSize * 0.4,
                                height: screenHeightSize * 0.5,
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
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets\Pictures\badges\star.png",
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
                                          myBages[index],
                                          style: TextStyle(
                                              color: textColor,
                                              fontSize: screenHeightSize * 0.02,
                                              fontWeight: FontWeight.w500),
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
          ),
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
                    height: screenHeightSize * 0.9,
                    width: screenWidthSize * 1,
                    child: GridView.count(
                      childAspectRatio: 1,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      children: List<Widget>.generate(titles.length, (index) {
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
                                                      images[index],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: screenWidthSize * 0.01,
                                                  right: screenWidthSize * 0.01,
                                                ),
                                                child: Text(
                                                  titles[index],
                                                  style: TextStyle(
                                                      color: textColor,
                                                      fontSize:
                                                          screenHeightSize *
                                                              0.02,
                                                      fontWeight:
                                                          FontWeight.w500),
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
