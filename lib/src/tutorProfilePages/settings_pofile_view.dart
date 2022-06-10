import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tutorProfilePages/tutor_profile_edit.dart';
import 'package:tutor_me/src/tutorProfilePages/user_stats.dart';

import '../components.dart';

class TutorSettingsProfileView extends StatefulWidget {
  const TutorSettingsProfileView({Key? key}) : super(key: key);

  @override
  _TutorSettingsProfileViewState createState() =>
      _TutorSettingsProfileViewState();
}

class _TutorSettingsProfileViewState extends State<TutorSettingsProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        topDesign(),
        // readyToTutor(),
        buildBody(),
      ],
    ));
  }

  Widget buildBody() {
    final screenWidthSize = MediaQuery.of(context).size.width;
    final screenHeightSize = MediaQuery.of(context).size.height;

    return Column(children: [
      Text(
        "Carol Timith(22)",
        style: TextStyle(
          fontSize: screenWidthSize * 0.08,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SmallTagButton(
        btnName: "Tutor",
        onPressed: () {},
        backColor: colorTurqoise,
      ),
      SizedBox(height: screenHeightSize * 0.01),
      Text(
        "Computer Science | Universtiy of Pretoria",
        style: TextStyle(
          fontSize: screenWidthSize * 0.05,
          fontWeight: FontWeight.normal,
          color: colorOrange,
        ),
      ),
      SizedBox(height: screenHeightSize * 0.02),
      const UserStats(rating: "3",numTutees: 4,numConnections: 15,),
      SizedBox(height: screenHeightSize * 0.02),
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: screenWidthSize * 0.06,
            top: screenHeightSize * 0.03,
          ),
          child: Text(
            "About Me",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: screenWidthSize * 0.065,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: screenWidthSize * 0.06,
          top: screenHeightSize * 0.01,
          bottom: screenWidthSize * 0.06,
        ),
        child: Text(
            "I am a self motivated individual who finds joy in exploring new technologies. I absolutely love teaching people. Fun fact: I love cooking. Always eager to help, feel free to hmu! ",
            style: TextStyle(
              fontSize: screenWidthSize * 0.05,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            )),
      ),
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: screenWidthSize * 0.06,
          ),
          child: Text("Gender",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: screenWidthSize * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            right: screenWidthSize * 0.06,
            left: screenWidthSize * 0.06,
            top: screenHeightSize * 0.02,
            bottom: screenHeightSize * 0.04,
          ),
          child: Text("Female",
              style: TextStyle(
                fontSize: screenWidthSize * 0.05,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              )),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: screenWidthSize * 0.06,
            // top: 16,
          ),
          child: Text("Modules I tutor",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: screenWidthSize * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: screenWidthSize * 0.06,
            right: screenWidthSize * 0.06,
            top: screenHeightSize * 0.02,
          ),
          child: Text(
              "* WTW114 - Calculus \n* WTW115 - Discrete Methamatics \n* COS122 - Operating Systems",
              style: TextStyle(
                fontSize: screenWidthSize * 0.05,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              )),
        ),
      ),
    ]);
  }

  Widget topDesign() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.25,
            margin: const EdgeInsets.only(bottom: 78),
            child: buildCoverImage()),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.18,
          child: buildProfileImage(),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.17,
          left: MediaQuery.of(context).size.height * 0.42,
          child: GestureDetector(
            onTap: (() => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TutorProfileEdit()))),
            child: Icon(
              Icons.edit,
              color: colorOrange,
              size: MediaQuery.of(context).size.height * 0.05,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: const Image(
          image: AssetImage('assets/Pictures/tutorCover.jpg'),
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: const AssetImage("assets/Pictures/penguin.png"),
      );

  Widget buildEditImageIcon() => const CircleAvatar(
        radius: 18,
        backgroundColor: colorOrange,
        child: Icon(
          Icons.camera_enhance,
          color: Colors.white,
        ),
      );
}
