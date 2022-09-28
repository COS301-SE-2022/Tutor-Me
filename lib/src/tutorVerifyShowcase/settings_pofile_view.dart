import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/services/services/institution_services.dart';
import 'package:tutor_me/services/services/module_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tutorProfilePages/tutor_profile_edit.dart';
import 'package:tutor_me/src/tutorProfilePages/user_stats.dart';

import '../../services/models/intitutions.dart';
import '../../services/models/modules.dart';
import '../../services/models/users.dart';
import '../../services/services/user_services.dart';
import '../components.dart';
import '../tutor_page.dart';
import 'edit_module_list.dart';
import 'tutor_profile_edit.dart';

// ignore: must_be_immutable
class ProfileShowCaseParent extends StatelessWidget {
  final Globals globals;
  Uint8List image;
  bool imageExists;

  ProfileShowCaseParent(
      {Key? key,
      required this.globals,
      required this.image,
      required this.imageExists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (_) => TutorShowCaseSettingsProfileView(
          globals: globals,
          image: image,
          imageExists: imageExists,
        ),
      ),
    );
  }
}

class ToReturn {
  Uint8List image;
  Users user;
  ToReturn(this.image, this.user);
}

// ignore: must_be_immutable
class TutorShowCaseSettingsProfileView extends StatefulWidget {
  Globals globals;
  Uint8List image;
  bool imageExists;
  TutorShowCaseSettingsProfileView(
      {Key? key,
      required this.globals,
      required this.image,
      required this.imageExists})
      : super(key: key);

  @override
  _TutorShowCaseSettingsProfileViewState createState() =>
      _TutorShowCaseSettingsProfileViewState();
}

class _TutorShowCaseSettingsProfileViewState
    extends State<TutorShowCaseSettingsProfileView> {
  List<Modules> currentModules = List<Modules>.empty();
  late Institutions institution;
  late int numConnections;
  int numTutees = 0;
  bool _isLoading = true;
  final key = GlobalKey();
  final key2 = GlobalKey();
  final key3 = GlobalKey();
  final ScrollController scrollController = ScrollController();

  getCurrentModules() async {
   
    try {
      final currentModulesList = await ModuleServices.getUserModules(
          widget.globals.getUser.getId, widget.globals);
      log(currentModules.length.toString());
      setState(() {
        currentModules = currentModulesList;
      });
    } catch (e) {
      const snackBar = SnackBar(content: Text('Error loading'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    getInstitution();
  }

  getInstitution() async {
    try {
      final tempInstitution = await InstitutionServices.getUserInstitution(
          widget.globals.getUser.getInstitutionID, widget.globals);

      institution = tempInstitution;
      log(currentModules.length.toString());
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      const snackBar = SnackBar(content: Text('Error loading'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  void getConnections() async {
    try {
      final tutors = await UserServices.getConnections(widget.globals.getUser.getId,
          widget.globals.getUser.getUserTypeID, widget.globals);

          numTutees = tutors.length;
     

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      const snackBar = SnackBar(content: Text('Error loading'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();

    getCurrentModules();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([key]);
    });
    // numConnections = getNumConnections();
    // numTutees = getNumTutees();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          floatingActionButton: Showcase(
            key: key,
            description: 'click here to add modules that you want to tutor',
            onTargetClick: () async {
              final modules = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditModuleShowCaseParent(
                          globals: widget.globals,
                          currentModules: currentModules,
                        )),
              );

              setState(() {
                if (modules != null) {
                  currentModules = modules;
                }
              });

              WidgetsBinding.instance.addPostFrameCallback((_) {
                ShowCaseWidget.of(context).startShowCase([key2]);
              });
            },
            disposeOnTap: true,
            child: FloatingActionButton.extended(
              label: const Text('Edit Module list'),
              onPressed: () async {
                final modules = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditModuleShowCaseParent(
                            globals: widget.globals,
                            currentModules: currentModules,
                          )),
                );

                setState(() {
                  if (modules != null) {
                    currentModules = modules;
                  }
                });
              },
              backgroundColor: colorBlueTeal,
              elevation: 0,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : WillPopScope(
                  onWillPop: () async {
                    Navigator.pop(context,
                        ToReturn(widget.image, widget.globals.getUser));
                    return false;
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      topDesign(),
                      // readyToTutor(),
                      buildBody(),
                    ],
                  ),
                )),
    );
  }

  Widget buildBody() {
    final screenWidthSize = MediaQuery.of(context).size.width;
    final screenHeightSize = MediaQuery.of(context).size.height;
    String userName = widget.globals.getUser.getName +
        ' ' +
        widget.globals.getUser.getLastName;
    String courseInfo = institution.getName;
    String personalDets = userName + '(' + widget.globals.getUser.getAge + ')';
    String gender = "";
    if (widget.globals.getUser.getGender == "F") {
      gender = "Female";
    } else {
      gender = "Male";
    }
    return Column(children: [
      Text(
        personalDets,
        style: TextStyle(
          fontSize: screenHeightSize * 0.04,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SmallTagButton(
        btnName: "Tutor",
        onPressed: () {},
        backColor: colorOrange,
      ),
      SizedBox(height: screenHeightSize * 0.01),
      Text(
        courseInfo,
        style: TextStyle(
          fontSize: screenHeightSize * 0.04,
          fontWeight: FontWeight.normal,
          color: colorBlueTeal,
        ),
      ),
      SizedBox(height: screenHeightSize * 0.02),
      TutorUserStats(
        rating: widget.globals.getUser.getRating,
        numTutees: numTutees,
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
              fontSize: screenHeightSize * 0.04,
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
            left: screenWidthSize * 0.06,
            top: screenHeightSize * 0.01,
            bottom: screenWidthSize * 0.06,
          ),
          child: Text(widget.globals.getUser.getBio,
              style: TextStyle(
                fontSize: screenHeightSize * 0.033,
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
                fontSize: screenHeightSize * 0.04,
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
                fontSize: screenHeightSize * 0.033,
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
                fontSize: screenHeightSize * 0.04,
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
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.05,
          child: Showcase(
            key: key3,
            description: 'Click here to go back',
            onTargetClick: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TutorPage(globals: widget.globals)),
                  (route) => false);
            },
            disposeOnTap: true,
            child: IconButton(
                color: colorWhite,
                iconSize: MediaQuery.of(context).size.height * 0.05,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TutorPage(globals: widget.globals)),
                      (route) => false);
                },
                icon: const Icon(Icons.arrow_back)),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.17,
          left: MediaQuery.of(context).size.width * 0.9,
          child: Showcase(
            key: key2,
            description: 'click here to edit profile',
            onTargetClick: () async {
              final results = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileEditShowCaseParent(
                          globals: widget.globals,
                          image: widget.image,
                          imageExists: widget.imageExists)));

              setState(() {
                if (results.image != null) {
                  widget.image = results.image;
                }
                widget.globals.setUser = results.user;
              });
            },
            disposeOnTap: true,
            child: GestureDetector(
              onTap: () async {
                final results = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TutorProfileEdit(
                            globals: widget.globals,
                            image: widget.image,
                            imageExists: widget.imageExists)));

                setState(() {
                  if (results.image != null) {
                    widget.image = results.image;
                  }
                  widget.globals.setUser = results.user;
                });

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ShowCaseWidget.of(context).startShowCase([key3]);
                });
              },
              child: Icon(
                Icons.edit,
                color: colorBlueTeal,
                size: MediaQuery.of(context).size.height * 0.05,
              ),
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
        radius: MediaQuery.of(context).size.height * 0.06,
        child: widget.imageExists
            ? ClipOval(
                child: Image.memory(
                  widget.image,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.253,
                  height: MediaQuery.of(context).size.height * 0.253,
                ),
              )
            : ClipOval(
                child: Image.asset(
                "assets/Pictures/penguin.png",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.253,
                height: MediaQuery.of(context).size.height * 0.253,
              )),
      );

  Widget buildEditImageIcon() => const CircleAvatar(
        radius: 18,
        backgroundColor: colorBlueTeal,
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
          color: colorOrange,
        ),
        Expanded(
          child: Text(
            moduleDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              color: Colors.black,
            ),
          ),
        ),
      ],
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

class SmallTagBtn extends StatelessWidget {
  const SmallTagBtn({
    Key? key,
    required this.btnName,
    required this.backColor,
    required this.funct,
  }) : super(key: key);
  final String btnName;

  final Color backColor;
  final Function() funct;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.05,
      width: size.width * 0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backColor,
      ),
      child: TextButton(
        onPressed: funct,
        child: Text(
          btnName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
