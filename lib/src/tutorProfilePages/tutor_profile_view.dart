import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/services/models/tutees.dart';
import 'package:tutor_me/services/services/tutee_services.dart';
// import 'package:tutor_me/src/colorPalette.dart';

import '../../services/models/modules.dart';
import '../../services/services/tutor_services.dart';
import '../colorpallete.dart';
import '../components.dart';
import 'user_stats.dart';

class TutorProfilePageView extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  TutorProfilePageView({Key? key, required this.tutor, required this.tutee})
      : super(key: key);
  final Tutors tutor;
  final Tutees tutee;

  static const String route = '/tutor_profile_view';

  @override
  _TutorProfilePageViewState createState() => _TutorProfilePageViewState();
}

class _TutorProfilePageViewState extends State<TutorProfilePageView> {
  List<Modules> currentModules = List<Modules>.empty();
  List<bool> isChecked = List<bool>.empty();
  late int numConnections;
  late int numTutees;
  bool isRequestLoading = false;
  bool isRequestDone = false;
  List<Tutors> tutors = List<Tutors>.empty();
  bool isConnected = false;
  int rating = 0;
  Color colorOne = Colors.yellow;
  Color colorTwo = Colors.grey;
  bool firstSelected = true;
  bool secondSelected = false;
  bool thirdSelected = false;
  bool forthSelected = false;
  bool fifthSelected = false;
  bool? value = false;
  late Uint8List bytes;
  bool isImageDisplayed = false;
  late bool doesImageExist;
  bool isLoading = true;

  getCurrentModules() async {
    final current = await TutorServices.getTutorModules(widget.tutor.getId);
    setState(() {
      currentModules = current;
    });
    getProfileImage();
  }

  int getNumConnections() {
    var allConnections = widget.tutor.getConnections.split(',');

    return allConnections.length;
  }

  int getNumTutees() {
    var allTutees = widget.tutor.getTuteesCode.split(',');

    return allTutees.length;
  }

  getProfileImage() async {
    try {
      final image =
          await TutorServices.getTutorProfileImage(widget.tutor.getId);
      setState(() {
        isLoading = false;
        bytes = image;
        isImageDisplayed = true;
      });
    } catch (e) {
      doesImageExist = false;
      setState(() {
        isLoading = false;
      });
    }
  }

  getConnections() async {
    if (!widget.tutee.getConnections.contains('No connections added')) {
      List<String> connections = widget.tutee.getConnections.split(',');
      int conLength = connections.length;
      for (int i = 0; i < conLength; i++) {
        final tutor = await TutorServices.getTutor(connections[i]);
        setState(() {
          isLoading = false;
          tutors += tutor;
        });
        isConnected = checkConnection();
      }
    }
  }

  bool checkConnection() {
    bool val = false;
    for (int i = 0; i < tutors.length; i++) {
      if (tutors[i].getId == widget.tutor.getId) {
        val = true;
        break;
      }
    }

    return val;
  }

  @override
  void initState() {
    super.initState();
    getCurrentModules();
    numConnections = getNumConnections();
    numTutees = getNumTutees();
    getConnections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : ListView(
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
      SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            right: screenWidthSize * 0.06,
            left: screenWidthSize * 0.06,
            top: screenHeightSize * 0.02,
            bottom: screenHeightSize * 0.04,
          ),
          child: Text(widget.tutor.getBio,
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
          child: ListView.separated(
            separatorBuilder: (BuildContext context, index) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02);
            },
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
                showModuleSelect(context);
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
        isConnected
            ? Positioned(
                top: MediaQuery.of(context).size.height * 0.27,
                left: MediaQuery.of(context).size.height * 0.01,
                child: ElevatedButton(
                    child: Row(
                      children: const <Widget>[
                        Text('Rate'),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        )
                      ],
                    ),
                    onPressed: () {
                      popUpDialog(context);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(colorTurqoise),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.1))))))
            : Container()
      ],
    );
  }

  void popUpDialog(BuildContext context) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return SimpleDialog(
            title: Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back)),
                Text(
                  'Give ' + widget.tutor.getName + ' a rating',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            children: <Widget>[
              Text(
                rating.toString(),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.07),
                textAlign: TextAlign.center,
              ),
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.star, color: colorOne),
                          onPressed: () {
                            setState(() {
                              rating = 1;
                              secondSelected = !firstSelected;
                              thirdSelected = !firstSelected;
                              forthSelected = !firstSelected;
                              fifthSelected = !firstSelected;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: secondSelected ? colorOne : colorTwo,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = 2;
                              secondSelected = true;
                              thirdSelected = false;
                              forthSelected = false;
                              fifthSelected = false;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: thirdSelected ? colorOne : colorTwo,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = 3;
                              secondSelected = true;
                              thirdSelected = true;
                              forthSelected = false;
                              fifthSelected = false;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: forthSelected ? colorOne : colorTwo,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = 4;
                              secondSelected = true;
                              thirdSelected = true;
                              forthSelected = true;
                              fifthSelected = false;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: fifthSelected ? colorOne : colorTwo,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = 5;
                              secondSelected = true;
                              thirdSelected = true;
                              forthSelected = true;
                              fifthSelected = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 2, color: colorTurqoise)),
                    onPressed: () async {
                      List<String> splitRating =
                          widget.tutor.getRating.split(',');
                      int tutorRating = int.parse(splitRating[0]);
                      int numRatings = int.parse(splitRating[1]);
                      numRatings++;
                      double updatedRating =
                          ((tutorRating + rating) / numRatings);
                      int asInt = updatedRating.round();
                      String ratingFormat =
                          asInt.toString() + ',' + numRatings.toString();
                      setState(() {
                        widget.tutor.setRating = ratingFormat;
                      });
                      try {
                        await TutorServices.updateTutor(widget.tutor);
                      } catch (e) {
                        const snackBar = SnackBar(
                          content: Text('Failed to upload rating'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: colorTurqoise),
                    )),
              )
            ],
          );
        });
      });

  Widget buildCoverImage() => const Image(
        image: AssetImage('assets/Pictures/tutorCover.jpg'),
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
      );

  Widget buildProfileImage() => CircleAvatar(
      radius: MediaQuery.of(context).size.width * 0.127,
      // backgroundColor: Colors.grey.shade800,
      // backgroundImage: !isImageDisplayed? const AssetImage("assets/Pictures/penguin.png"),

      child: isImageDisplayed
          ? ClipOval(
              child: Image.memory(
                bytes,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.253,
                height: MediaQuery.of(context).size.width * 0.253,
              ),
            )
          : ClipOval(
              child: Image.asset(
              "assets/Pictures/penguin.png",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.253,
              height: MediaQuery.of(context).size.width * 0.253,
            )));

  // ImageProvider buildImage() {
  //   if (image != null) {
  //     return DecorationImage(image: image);
  //   }
  //   return const AssetImage('assets/Pictures/penguin.png');
  // }

  // Image fileImage() {
  //   return Image.memory(image);
  // }

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
    return Row(
      children: [
        Icon(
          Icons.book,
          size: MediaQuery.of(context).size.height * 0.02,
          color: colorTurqoise,
        ),
        Expanded(
          child: Text(
            moduleDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  showModuleSelect(BuildContext context) {
    String titleMessage =
        "Choose the modules you are requesting this tutor for...";
    isChecked = List<bool>.filled(currentModules.length, false);
    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
              onWillPop: (() async => true),
              child: StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    title: Text(titleMessage),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.height * 0.9,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  scrollbarTheme: ScrollbarThemeData(
                                      thumbColor: MaterialStateProperty.all(
                                          colorTurqoise))),
                              child: Scrollbar(
                                thumbVisibility: true,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: isChecked[i],
                                        title: Text(currentModules[i].getCode),
                                        activeColor: colorOrange,
                                        onChanged: (newValue) {
                                          setState(() {
                                            isChecked[i] = newValue!;
                                          });
                                        });
                                  },
                                  itemCount: currentModules.length,
                                ),
                              ),
                            )),
                        SizedBox(
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      width: 2, color: colorTurqoise)),
                              onPressed: () {
                                Navigator.pop(context);
                                showConfirmRequest(context);
                              },
                              child: const Text(
                                'Next',
                                style: TextStyle(color: colorTurqoise),
                              )),
                        ),
                      ],
                    ));
              }));
        });
  }

  showConfirmRequest(BuildContext context) {
    String testMessage = "You are about to send a request to " +
        widget.tutor.getName +
        " " +
        widget.tutor.getLastName;
    List<String> modulesToRequest = List.empty(growable: true);
    for (int i = 0; i < currentModules.length; i++) {
      if (isChecked[i]) {
        modulesToRequest.add(currentModules[i].getCode);
      }
    }
    String modulesRequested = '';
    for (int i = 0; i < modulesToRequest.length; i++) {
      modulesRequested += modulesToRequest[i];
      if (i < modulesToRequest.length - 1) {
        modulesRequested += ',';
      }
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: (() async => false),
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                  title: const Text("Alert"),
                  content: Text(testMessage),
                  actions: [
                    isRequestLoading
                        ? const CircularProgressIndicator.adaptive()
                        : isRequestDone
                            ? Icon(
                                Icons.done,
                                color: colorTurqoise,
                                size: MediaQuery.of(context).size.width * 0.1,
                              )
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        width: 2, color: colorTurqoise)),
                                onPressed: () async {
                                  setState(() {
                                    isRequestLoading = true;
                                  });

                                  bool val = await TuteeServices().sendRequest(
                                      widget.tutor.getId,
                                      widget.tutee.getId,
                                      modulesRequested);

                                  if (val) {
                                    setState(() {
                                      isRequestLoading = false;
                                      isRequestDone = true;
                                    });
                                  }

                                  Future.delayed(
                                      const Duration(milliseconds: 1000), () {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(color: colorTurqoise),
                                )),
                    !isRequestLoading && !isRequestDone
                        ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    width: 2, color: colorOrange)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: colorOrange),
                            ))
                        : Container(),
                  ]);
            }),
          );
        });
  }
}
