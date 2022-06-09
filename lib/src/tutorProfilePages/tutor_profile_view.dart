import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutors.dart';
// import 'package:tutor_me/src/colorPalette.dart';

import '../../services/models/modules.dart';
import '../../services/services/tutor_services.dart';
import '../colorpallete.dart';
import '../components.dart';
import 'user_stats.dart';

class TutorProfilePageView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  TutorProfilePageView({Key? key, required this.tutor}) : super(key: key);
  final Tutors tutor;

  static const String route = '/tutor_profile_view';

  @override
  _TutorProfilePageViewState createState() => _TutorProfilePageViewState();
}

class _TutorProfilePageViewState extends State<TutorProfilePageView> {
  List<Modules> currentModules = List<Modules>.empty();
  late int numConnections;
  late int numTutees;
  getCurrentModules() async {
    final current = await TutorServices.getTutorModules(widget.tutor.getId);
    setState(() {
      currentModules = current;
    });
  }

  int getNumConnections() {
    var allConnections = widget.tutor.getConnections.split(',');

    return allConnections.length;
  }

  int getNumTutees() {
    var allTutees = widget.tutor.getTuteesCode.split(',');

    return allTutees.length;
  }

  @override
  void initState() {
    super.initState();
    getCurrentModules();
    numConnections = getNumConnections();
    numTutees = getNumTutees();
  }

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
    String tutorName = widget.tutor.getName + ' ' + widget.tutor.getLastName;
    String courseInfo =
        widget.tutor.getCourse + ' | ' + widget.tutor.getInstitution;
    String personalDets = tutorName + '(' + widget.tutor.getAge + ')';
    String gender = "";
    if (widget.tutor.getGender == "F") {
      gender = "Female";
    } else {
      gender = "Male";
    }
    return Column(children: [
      Text(
        personalDets,
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
        courseInfo,
        style: TextStyle(
          fontSize: screenWidthSize * 0.04,
          fontWeight: FontWeight.normal,
          color: colorOrange,
        ),
      ),
      SizedBox(height: screenHeightSize * 0.02),
      UserStats(
        rating: widget.tutor.getRating,
        numTutees: numTutees,
        numConnections: numConnections,
      ),
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
        child: Text(widget.tutor.getBio,
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
          child: Text(gender,
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
            top: screenHeightSize * 0,
          ),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: _moduleListBuilder,
            itemCount: currentModules.length,
          ),
        ),
      ),
      SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.03,
                top: MediaQuery.of(context).size.height * 0.03),
            child: ElevatedButton(
              onPressed: () {
                showAlertDialog(context);
              },
              child: const Text("Send Request"),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.deepOrangeAccent),
              ),
            ),
          ))
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

  Widget _moduleListBuilder(BuildContext context, int i) {
    String moduleDescription =
        currentModules[i].getModuleName + '(' + currentModules[i].getCode + ')';
    return Text(
      moduleDescription,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.05,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget ok = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('OK'));

    AlertDialog requestAlert = AlertDialog(
        title: const Text("Alert"),
        content: const Text("Your request has been sent!!"),
        actions: [
          ok,
        ]);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return requestAlert;
        });
  }
}
