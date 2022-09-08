import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/pages/badges.dart';
import 'package:tutor_me/src/pages/book_for_tutor.dart';
import 'package:tutor_me/src/pages/calendar.dart';

import '../../services/models/users.dart';

class Home extends StatefulWidget {
  final Users user;
  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var gridCount = 0;
  @override
  Widget build(BuildContext context) {
    double screenHieght = MediaQuery.of(context).size.height;
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

  Widget buildBody() {
    final screenHeightSize = MediaQuery.of(context).size.height;
    final screenWidthSize = MediaQuery.of(context).size.width;
    final images = [
      "assets/Pictures/studentt.jpg",
      "assets/Pictures/groups.jpg",
      "assets/Pictures/badges.jpg",
      "assets/Pictures/calendar.jpg",
      "assets/Pictures/book.jpg",
    ];
    final titles = [
      "Tutees",
      "Groups",
      "Badges",
      "Calendar",
      "Book for a Tutor"
    ];
    final numberStats = ["4", "4", "2", "more info", "more info"];

    // FilePickerResult? filePickerResult;
    // String? fileName;
    // PlatformFile? file;
    // bool isUploading = false;
    // File? fileToUpload;

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
                const CircleAvatar(
                  radius: 24.0,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1529470839332-78ad660a6a82?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fHN0dWRlbnR8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: screenWidthSize * 0.02),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.01),
                      child: Text(
                        "Kuda Christine",
                        style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeightSize * 0.025),
                      ),
                    ),
                    Row(
                      children: const <Widget>[
                        Icon(
                          Icons.run_circle_rounded,
                          color: colorOrange,
                        ),
                        Icon(
                          Icons.school_rounded,
                          color: colorOrange,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenWidthSize * 0.1, top: screenHeightSize * 0.02),
          child: Container(
            width: screenWidthSize > 800 ? 500 : screenWidthSize * 0.8,
            height: screenHeightSize * 0.2,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Pictures/progressBar.jpg"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        SizedBox(height: screenHeightSize * 0.02),
        Padding(
          padding: EdgeInsets.only(left: screenWidthSize * 0.1),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.circle,
                color: colorLightGreen,
                size: screenHeightSize * 0.03,
              ),
              SizedBox(width: screenWidthSize * 0.02),
              Text(
                "New meeting scheduled...",
                style: TextStyle(fontSize: screenHeightSize * 0.03),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidthSize * 0.11),
          child: Container(
            height: screenHeightSize * 0.03,
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(width: 2, color: colorGrey)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: screenWidthSize * 0.1),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.circle,
                color: colorLightGreen,
                size: screenHeightSize * 0.03,
              ),
              SizedBox(width: screenWidthSize * 0.02),
              Text(
                "New meeting scheduled...",
                style: TextStyle(fontSize: screenHeightSize * 0.03),
              ),
              const Text(
                "more updates",
                style: TextStyle(color: colorOrange),
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
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: screenHeightSize * 0.015, bottom: screenHeightSize * 0.015),
          child: Divider(
            color: colorGrey.withOpacity(0.2), //color of divider
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
                      if (index == 0) {
                        //render Tutees Page
                      } else if (index == 1) {
                        //render Groups Page
                      } else if (index == 2) {
                        //render Badges Page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => const Badges()));
                      } else if (index == 3) {
                        //render Calendar Page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const Calendar()));
                      } else if (index == 4) {
                        //render Book for a tutor Page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => BookForTutor(
                                  user: widget.user,
                                )));
                      }
                    },
                    child: Card(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeightSize * 0.02,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02),
                        color: colorWhite,
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
                                        fontSize: screenHeightSize * 0.03,
                                        fontWeight: FontWeight.w500),
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
                                        size: screenHeightSize * 0.025,
                                      ),
                                      SizedBox(width: screenWidthSize * 0.02),
                                      Text(
                                        numberStats[index],
                                        style: TextStyle(
                                            fontSize: screenHeightSize * 0.03,
                                            fontWeight: FontWeight.w400),
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
