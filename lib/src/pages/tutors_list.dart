import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/services/services/module_services.dart';
import 'package:tutor_me/services/services/user_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../services/models/modules.dart';
import '../../services/models/users.dart';
import '../theme/themes.dart';
import '../tutee_page.dart';
import '../tutorProfilePages/tutor_profile_view.dart';
// import 'package:tutor_me/services/models/tutors.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'theme/themes.dart';

class Tutor {
  Users tutor;
  Uint8List image = Uint8List(128);
  bool hasImage = false;
  Tutor(this.tutor, this.image, this.hasImage);
}

class TutorList extends StatefulWidget {
  final Globals globals;
  const TutorList({Key? key, required this.globals}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorListState();
  }
}

class TutorListState extends State<TutorList> {
  String query = '';
  final textControl = TextEditingController();
  List<Users> tutorList = List<Users>.empty();
  List<Tutor> saveTutors = List<Tutor>.empty();
  List<Uint8List> tutorImages = List<Uint8List>.empty(growable: true);
  List<Tutor> tutors = List<Tutor>.empty(growable: true);
  List<int> hasImage = List<int>.empty(growable: true);
  List<Users> connectedTutors = List<Users>.empty();
  double filterContHeight = 0.0;
  double filterContWidth = 0.0;
  bool collapsed = true;
  bool isMaleSelected = false;
  bool isFemaleSelected = false;
  bool isFirstSelected = false;
  bool isSecondSelected = false;
  bool isThirdSelected = false;
  bool isForthSelected = false;
  bool isFifthSelected = false;
  Color checkedColor = colorBlack;
  bool _isLoading = true;

  void search(String search) {
    if (search == '') {
      tutors = saveTutors;
    }
    final searchedTutors = tutors.where((tutor) {
      final nameToLower = tutor.tutor.getName.toLowerCase();
      final lastNameToLower = tutor.tutor.getLastName.toLowerCase();
      final lowerName = nameToLower + ' ' + lastNameToLower;
      final query = search.toLowerCase();

      return lowerName.contains(query);
    }).toList();

    setState(() {
      tutors = searchedTutors;
      query = search;
    });
  }

// 0644013797
  void filterGender(String filter) {
    if (filter == 'Male') {
      filter = 'M';
    } else if (filter == 'Female') {
      filter = 'F';
    } else {
      setState(() {
        tutors = saveTutors;
      });
    }
    final filteredTutors = tutors.where((tutor) {
      final tGender = tutor.tutor.getGender;

      return tGender.contains(filter);
    }).toList();

    setState(() {
      tutors = filteredTutors;
    });
  }

  void filterAge(String filter) {
    if (filter == '36+') {
      final filteredTutors = tutors.where((tutor) {
        bool val = false;
        if (tutor.tutor.getDateOfBirth != '') {
          String strAge = tutor.tutor.getDateOfBirth;
          int age = int.parse(strAge);
          if (age >= 36) {
            val = true;
          }
        }

        return val;
      }).toList();

      setState(() {
        tutors = filteredTutors;
      });
      return;
    }
    String first = "";
    String second = "";
    for (int i = 0; i < 2; i++) {
      first += filter[i];
    }

    for (int i = 3; i < 5; i++) {
      second += filter[i];
    }

    var f = int.parse(first);
    var s = int.parse(second);

    final filteredTutors = tutors.where((tutor) {
      bool val = false;
      if (tutor.tutor.getDateOfBirth != '') {
        String strAge = tutor.tutor.getAge;
        int age = int.parse(strAge);
        for (int i = f; i < s + 1; i++) {
          if (age == i) {
            val = true;
          }
        }
      }

      return val;
    }).toList();

    setState(() {
      tutors = filteredTutors;
    });
  }

  getTutors() async {
    try {
      final tutors = await UserServices.getTutors(widget.globals);
      tutorList = tutors;
      log(tutorList.length.toString());
      getConnections();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  getConnections() async {
    try {
      List<int> indecies = List<int>.empty(growable: true);
      int tutorLength = tutorList.length;

      final tutors = await UserServices.getConnections(
          widget.globals.getUser.getId,
          widget.globals.getUser.getUserTypeID,
          widget.globals);

      connectedTutors = tutors;

      for (int i = 0; i < tutorLength; i++) {
        for (int j = 0; j < connectedTutors.length; j++) {
          if (tutorList[i].getId == connectedTutors[j].getId) {
            indecies.add(i);
          }
        }
      }
      List<Modules> tuteeModules = List<Modules>.empty();
      final tuteeModuleList = await ModuleServices.getUserModules(
          widget.globals.getUser.getId, widget.globals);
      tuteeModules = tuteeModuleList;
      for (int i = 0; i < tutorLength; i++) {
        bool val = false;
        if (tuteeModules.isNotEmpty) {
          List<Modules> tutorModules = List<Modules>.empty();
          final tutorModuleList = await ModuleServices.getUserModules(
              tutorList[i].getId, widget.globals);
          tutorModules = tutorModuleList;

          for (int k = 0; k < tutorModules.length; k++) {
            for (int l = 0; l < tuteeModules.length; l++) {
              if (tutorModules[k].getCode == tuteeModules[l].getCode) {
                val = true;
              }
            }
          }
        }

        if (!val) {
          indecies.add(i);
        }
      }

      if (tuteeModules.isEmpty) {
        setState(() {
          tutorList = List<Users>.empty();
        });
        const snackBar = SnackBar(
          content: Text('No Tutor suggestions'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        List<Users> tempList = List<Users>.empty(growable: true);

        for (int i = 0; i < tutorList.length; i++) {
          bool toAdd = true;
          for (int j = 0; j < indecies.length; j++) {
            if (i == indecies[j]) {
              toAdd = false;
            }
          }
          if (toAdd) {
            tempList.add(tutorList[i]);
          }
        }
        setState(() {
          tutorList = tempList;
        });
      }
    } catch (e) {
      for (var tutor in tutorList) {
        tutors.add(Tutor(tutor, Uint8List(128), false));
      }
      setState(() {
        _isLoading = false;
      });
      // getTutorProfileImages();
    }
  }

  getTutorProfileImages() async {
    try {
      for (int i = 0; i < tutorList.length; i++) {
        try {
          final image = await UserServices.getProfileImage(
              tutorList[i].getId, widget.globals);
          setState(() {
            tutorImages.add(image);
          });
        } catch (e) {
          final byte = Uint8List(128);
          tutorImages.add(byte);
          hasImage.add(i);
        }
      }
      for (int i = 0; i < tutorList.length; i++) {
        setState(() {
          bool val = true;
          for (int j = 0; j < hasImage.length; j++) {
            if (hasImage[j] == i) {
              val = false;
              break;
            }
          }
          if (!val) {
            tutors.add(Tutor(tutorList[i], tutorImages[i], false));
          } else {
            tutors.add(Tutor(tutorList[i], tutorImages[i], true));
          }
        });
      }
      setState(() {
        saveTutors = tutors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        saveTutors = tutors;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTutors();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    Color textColor;
    Color secondaryTextColor;
    Color primaryColor;
    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      textColor = colorWhite;
      secondaryTextColor = colorGrey;
      primaryColor = colorLightGrey;
      highLightColor = colorLightBlueTeal;
    } else {
      textColor = Colors.black;
      secondaryTextColor = colorOrange;
      primaryColor = colorBlueTeal;
      highLightColor = colorOrange;
    }

    filterContHeight = MediaQuery.of(context).size.height * 0.16;
    filterContWidth = MediaQuery.of(context).size.width * 0.9;
    return Material(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.26,
            decoration: const BoxDecoration(
                // borderRadius:
                //     BorderRadius.vertical(botCentertom: Radius.circular(60)),
                image: DecorationImage(
              image: AssetImage("assets/Pictures/book.jpg"),
              fit: BoxFit.fill,
            )),
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                    bottom: MediaQuery.of(context).size.height * 0.1,
                    right: MediaQuery.of(context).size.width * 0.8),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TuteePage(globals: widget.globals)),
                    ),
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: colorWhite,
                    size: MediaQuery.of(context).size.width * 0.1,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.25),
              ),
            ]),
          ),
          SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.02),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Request for a Tutor",
                      style: TextStyle(
                          color: textColor,
                          fontSize: MediaQuery.of(context).size.height * 0.035,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          right: MediaQuery.of(context).size.width * 0.0001,
                          left: MediaQuery.of(context).size.height * 0.02),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextField(
                        cursorColor: primaryColor,
                        onChanged: (value) => search(value),
                        controller: textControl,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(0),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.black45,
                            ),
                            suffixIcon: query.isNotEmpty
                                ? GestureDetector(
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.black45,
                                    ),
                                    onTap: () {
                                      textControl.clear();
                                      setState(() {
                                        tutors = saveTutors;
                                      });
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 1.0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                            hintText: "Search for Tutors..."),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        size: MediaQuery.of(context).size.width * 0.095,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          collapsed = !collapsed;
                        });
                      },
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: collapsed ? 0 : filterContHeight,
                    width: filterContWidth,
                    curve: Curves.linear,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const Text('Gender:', textAlign: TextAlign.left),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FilterChip(
                                selectedColor: highLightColor.withOpacity(0.5),
                                label: Text(
                                  'Male',
                                  style: TextStyle(color: checkedColor),
                                ),
                                backgroundColor: Colors.white60,
                                shape: StadiumBorder(
                                    side: BorderSide(color: checkedColor)),
                                checkmarkColor: highLightColor,
                                onSelected: (isSelected) {
                                  if (isFemaleSelected) {
                                    tutors = saveTutors;
                                  }
                                  String newGen = 'Male';
                                  filterGender(newGen);
                                  setState(() {
                                    if (isSelected) {
                                      checkedColor = highLightColor;
                                      const snackBar = SnackBar(
                                        content: Text('Filter option applied'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      isMaleSelected = isSelected;
                                      isFemaleSelected = !isSelected;
                                    } else {
                                      checkedColor = textColor;
                                      isMaleSelected = isSelected;
                                      if (!isFirstSelected ||
                                          !isSecondSelected ||
                                          !isThirdSelected ||
                                          !isForthSelected ||
                                          !isFifthSelected) {
                                        tutors = saveTutors;
                                      }
                                    }
                                  });
                                },
                                selected: isMaleSelected,
                                // avatar: const Icon(Icons.male),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03),
                              FilterChip(
                                selectedColor: highLightColor.withOpacity(0.5),
                                label: Text(
                                  'Female',
                                  style: TextStyle(color: checkedColor),
                                ),
                                backgroundColor: Colors.white60,
                                shape: StadiumBorder(
                                    side: BorderSide(color: checkedColor)),
                                checkmarkColor: highLightColor,
                                onSelected: (isSelected) {
                                  if (isMaleSelected) {
                                    tutors = saveTutors;
                                  }
                                  String newGen = 'Female';
                                  filterGender(newGen);
                                  setState(() {
                                    if (isSelected) {
                                      checkedColor = highLightColor;
                                      const snackBar = SnackBar(
                                        content: Text('Filter option applied'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      isMaleSelected = !isSelected;
                                      isFemaleSelected = isSelected;
                                    } else {
                                      checkedColor = textColor;
                                      isFemaleSelected = isSelected;
                                      if (!isFirstSelected ||
                                          !isSecondSelected ||
                                          !isThirdSelected ||
                                          !isForthSelected ||
                                          !isFifthSelected) {
                                        tutors = saveTutors;
                                      }
                                    }
                                  });
                                },
                                selected: isFemaleSelected,
                                // avatar: const Icon(Icons.female),
                              ),
                            ],
                          ),
                          const Text('Age:'),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                FilterChip(
                                  selectedColor:
                                      highLightColor.withOpacity(0.5),
                                  label: Text(
                                    '16-18',
                                    style: TextStyle(color: checkedColor),
                                  ),
                                  backgroundColor: Colors.white60,
                                  shape: StadiumBorder(
                                      side: BorderSide(color: checkedColor)),
                                  checkmarkColor: colorOrange,
                                  onSelected: (isSelected) {
                                    if (isSecondSelected ||
                                        isThirdSelected ||
                                        isForthSelected ||
                                        isFifthSelected) {
                                      tutors = saveTutors;
                                    }

                                    String newAge = '16-18';
                                    filterAge(newAge);
                                    setState(() {
                                      if (isSelected) {
                                        checkedColor = highLightColor;
                                        const snackBar = SnackBar(
                                          content:
                                              Text('Filter option applied'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        isFirstSelected = isSelected;
                                        isSecondSelected = !isSelected;
                                        isThirdSelected = !isSelected;
                                        isForthSelected = !isSelected;
                                        isFifthSelected = !isSelected;
                                      } else {
                                        checkedColor = textColor;
                                        isFirstSelected = isSelected;
                                        tutors = saveTutors;
                                      }
                                    });
                                  },
                                  selected: isFirstSelected,
                                  // avatar: const Icon(Icons.male),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01),
                                FilterChip(
                                  selectedColor:
                                      highLightColor.withOpacity(0.5),
                                  label: Text(
                                    '19-21',
                                    style: TextStyle(color: checkedColor),
                                  ),
                                  backgroundColor: Colors.white60,
                                  shape: StadiumBorder(
                                      side: BorderSide(color: checkedColor)),
                                  checkmarkColor: highLightColor,
                                  onSelected: (isSelected) {
                                    if (isFirstSelected ||
                                        isThirdSelected ||
                                        isForthSelected ||
                                        isFifthSelected) {
                                      tutors = saveTutors;
                                    }
                                    String newAge = '19-21';
                                    filterAge(newAge);
                                    setState(() {
                                      if (isSelected) {
                                        checkedColor = highLightColor;
                                        const snackBar = SnackBar(
                                          content:
                                              Text('Filter option applied'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        isSecondSelected = isSelected;
                                        isFirstSelected = !isSelected;
                                        isThirdSelected = !isSelected;
                                        isForthSelected = !isSelected;
                                        isFifthSelected = !isSelected;
                                      } else {
                                        checkedColor = textColor;
                                        isSecondSelected = isSelected;
                                        tutors = saveTutors;
                                      }
                                    });
                                  },
                                  selected: isSecondSelected,
                                  // avatar: const Icon(Icons.male),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01),
                                FilterChip(
                                  selectedColor:
                                      highLightColor.withOpacity(0.5),
                                  label: Text(
                                    '22-25',
                                    style: TextStyle(color: checkedColor),
                                  ),
                                  backgroundColor: Colors.white60,
                                  shape: StadiumBorder(
                                      side: BorderSide(color: checkedColor)),
                                  checkmarkColor: highLightColor,
                                  onSelected: (isSelected) {
                                    if (isFirstSelected ||
                                        isSecondSelected ||
                                        isForthSelected ||
                                        isFifthSelected) {
                                      tutors = saveTutors;
                                    }
                                    String newAge = '22-25';
                                    filterAge(newAge);
                                    setState(() {
                                      if (isSelected) {
                                        checkedColor = highLightColor;
                                        const snackBar = SnackBar(
                                          content:
                                              Text('Filter option applied'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        isThirdSelected = isSelected;
                                        isFirstSelected = !isSelected;
                                        isSecondSelected = !isSelected;
                                        isForthSelected = !isSelected;
                                        isFifthSelected = !isSelected;
                                      } else {
                                        checkedColor = textColor;
                                        isThirdSelected = isSelected;
                                        tutors = saveTutors;
                                      }
                                    });
                                  },
                                  selected: isThirdSelected,
                                  // avatar: const Icon(Icons.male),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01),
                                FilterChip(
                                  selectedColor:
                                      highLightColor.withOpacity(0.5),
                                  label: Text(
                                    '26-35',
                                    style: TextStyle(color: checkedColor),
                                  ),
                                  backgroundColor: Colors.white60,
                                  shape: StadiumBorder(
                                      side: BorderSide(color: checkedColor)),
                                  checkmarkColor: highLightColor,
                                  onSelected: (isSelected) {
                                    if (isFirstSelected ||
                                        isSecondSelected ||
                                        isThirdSelected ||
                                        isFifthSelected) {
                                      tutors = saveTutors;
                                    }
                                    String newAge = '26-35';
                                    filterAge(newAge);
                                    setState(() {
                                      if (isSelected) {
                                        checkedColor = highLightColor;
                                        const snackBar = SnackBar(
                                          content:
                                              Text('Filter option applied'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        isForthSelected = isSelected;
                                        isFirstSelected = !isSelected;
                                        isSecondSelected = !isSelected;
                                        isThirdSelected = !isSelected;
                                        isFifthSelected = !isSelected;
                                      } else {
                                        checkedColor = textColor;
                                        isForthSelected = isSelected;
                                        tutors = saveTutors;
                                      }
                                    });
                                  },
                                  selected: isForthSelected,
                                  // avatar: const Icon(Icons.male),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01),
                                FilterChip(
                                  selectedColor:
                                      highLightColor.withOpacity(0.5),
                                  label: Text(
                                    '36+',
                                    style: TextStyle(color: checkedColor),
                                  ),
                                  backgroundColor: Colors.white60,
                                  shape: StadiumBorder(
                                      side: BorderSide(color: checkedColor)),
                                  checkmarkColor: highLightColor,
                                  onSelected: (isSelected) {
                                    if (isFirstSelected ||
                                        isSecondSelected ||
                                        isThirdSelected ||
                                        isForthSelected) {
                                      tutors = saveTutors;
                                    }
                                    String newAge = '36+';
                                    filterAge(newAge);
                                    setState(() {
                                      if (isSelected) {
                                        checkedColor = highLightColor;
                                        const snackBar = SnackBar(
                                          content:
                                              Text('Filter option applied'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        isFifthSelected = isSelected;
                                        isFirstSelected = !isSelected;
                                        isSecondSelected = !isSelected;
                                        isThirdSelected = !isSelected;
                                        isForthSelected = !isSelected;
                                      } else {
                                        checkedColor = textColor;
                                        isFifthSelected = isSelected;
                                        tutors = saveTutors;
                                      }
                                    });
                                  },
                                  selected: isFifthSelected,
                                  // avatar: const Icon(Icons.male),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                _isLoading
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      )
                    : tutors.isEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.50,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.person_add_disabled,
                                    size: MediaQuery.of(context).size.height *
                                        0.09,
                                    color: highLightColor,
                                  ),
                                  const Text('No Tutors available')
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.60,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ListView.builder(
                              // padding: const EdgeInsets.all(10),
                              itemCount: tutors.length,
                              itemBuilder: _cardBuilder,
                            ),
                          ),
              ])),
        ],
      ),
    ));
  }

  Widget _cardBuilder(BuildContext context, int i) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    Color textColor;
    Color secondaryTextColor;
    Color primaryColor;
    Color highLightColor;

    if (provider.themeMode == ThemeMode.dark) {
      textColor = colorWhite;
      secondaryTextColor = colorGrey;
      primaryColor = colorLightGrey;
      highLightColor = colorLightBlueTeal;
    } else {
      textColor = Colors.black;
      secondaryTextColor = colorOrange;
      primaryColor = colorBlueTeal;
      highLightColor = colorOrange;
    }

    String name = tutors[i].tutor.getName;
    name += ' ' + tutors[i].tutor.getLastName;
    int rating = tutors[i].tutor.getRating;
    return GestureDetector(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          // side: const BorderSide(color: colorOrange, width: 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        // color: Colors.transparent,
        color: const Color.fromARGB(77, 216, 216, 216),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                leading: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.070,
                  child: tutors[i].hasImage
                      ? ClipOval(
                          child: Image.memory(
                            tutors[i].image,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.18,
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                          "assets/Pictures/penguin.png",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                        )),
                ),
                title: Text(
                  name,
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  tutors[i].tutor.getBio,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(rating.toString()),
                    const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 255, 233, 31),
                    )
                  ],
                )),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TutorProfilePageView(
                  tutor: tutors[i].tutor,
                  globals: widget.globals,
                  image: tutors[i].image,
                  hasImage: tutors[i].hasImage,
                )));
      },
    );
  }
}
