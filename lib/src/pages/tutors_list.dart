import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/tutor_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../services/models/tutees.dart';
import '../tutorProfilePages/tutor_profile_view.dart';
import 'package:tutor_me/services/models/tutors.dart';
// import 'package:tutor_me/modules/api.services.dart';
// import 'package:tutor_me/modules/tutors.dart';
// import 'tutorProfilePages/tutor_profile_view.dart';
// import 'Navigation/nav_drawer.dart';
// import 'theme/themes.dart';

class TutorsList extends StatefulWidget {
  final Tutees tutee;
  const TutorsList({Key? key, required this.tutee}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorsListState();
  }
}

class TutorsListState extends State<TutorsList> {
  // TutorRepo tutorRepo = TutorRepo();
  String query = '';
  final textControl = TextEditingController();
  List<Tutors> tutorList = List<Tutors>.empty();
  List<Tutors> saveTutors = List<Tutors>.empty();
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
      tutorList = saveTutors;
    }
    final tutors = tutorList.where((tutor) {
      final nameToLower = tutor.getName.toLowerCase();
      final lastNameToLower = tutor.getLastName.toLowerCase();
      final lowerName = nameToLower + ' ' + lastNameToLower;
      final query = search.toLowerCase();

      return lowerName.contains(query);
    }).toList();

    setState(() {
      tutorList = tutors;
      query = search;
    });
  }

  void filterGender(String filter) {
    if (filter == 'Male') {
      filter = 'M';
    } else if (filter == 'Female') {
      filter = 'F';
    } else {
      setState(() {
        tutorList = saveTutors;
      });
    }
    final tutors = tutorList.where((tutor) {
      final tGender = tutor.getGender;

      return tGender.contains(filter);
    }).toList();

    setState(() {
      tutorList = tutors;
    });
  }

  void filterAge(String filter) {
    if (filter == '36+') {
      final tutors = tutorList.where((tutor) {
        bool val = false;
        if (tutor.getDateOfBirth != '') {
          String strAge = tutor.getAge;
          int age = int.parse(strAge);
          if (age >= 36) {
            val = true;
          }
        }

        return val;
      }).toList();

      setState(() {
        tutorList = tutors;
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

    final tutors = tutorList.where((tutor) {
      bool val = false;
      if (tutor.getDateOfBirth != '') {
        String strAge = tutor.getAge;
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
      tutorList = tutors;
    });
  }

  getTutors() async {
    final tutors = await TutorServices.getTutors();
    setState(() {
      tutorList = tutors;
      saveTutors = tutors;
    });
  }

  @override
  void initState() {
    super.initState();
    getTutors();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    filterContHeight = MediaQuery.of(context).size.height * 0.16;
    filterContWidth = MediaQuery.of(context).size.width * 0.9;
    return Material(
        child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                right: MediaQuery.of(context).size.width * 0.0001,
                left: MediaQuery.of(context).size.height * 0.02),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.07,
            child: TextField(
              cursorColor: colorOrange,
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
                              tutorList = saveTutors;
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1.0),
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
              size: MediaQuery.of(context).size.width * 0.09,
              color: colorBlack,
            ),
            onPressed: () {
              setState(() {
                collapsed = !collapsed;
              });
            },
          ),
        ],
      ),
      AnimatedContainer(
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
                    selectedColor: colorTurqoise.withOpacity(0.5),
                    label: Text(
                      'Male',
                      style: TextStyle(color: checkedColor),
                    ),
                    backgroundColor: Colors.white60,
                    shape: StadiumBorder(side: BorderSide(color: checkedColor)),
                    checkmarkColor: colorTurqoise,
                    onSelected: (isSelected) {
                      if (isFemaleSelected) {
                        tutorList = saveTutors;
                      }
                      String newGen = 'Male';
                      filterGender(newGen);
                      setState(() {
                        if (isSelected) {
                          checkedColor = colorTurqoise;
                          const snackBar = SnackBar(
                            content: Text('Filter option applied'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          isMaleSelected = isSelected;
                          isFemaleSelected = !isSelected;
                        } else {
                          checkedColor = colorBlack;
                          isMaleSelected = isSelected;
                          if (!isFirstSelected ||
                              !isSecondSelected ||
                              !isThirdSelected ||
                              !isForthSelected ||
                              !isFifthSelected) {
                            tutorList = saveTutors;
                          }
                        }
                      });
                    },
                    selected: isMaleSelected,
                    // avatar: const Icon(Icons.male),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  FilterChip(
                    selectedColor: colorTurqoise.withOpacity(0.5),
                    label: Text(
                      'Female',
                      style: TextStyle(color: checkedColor),
                    ),
                    backgroundColor: Colors.white60,
                    shape: StadiumBorder(side: BorderSide(color: checkedColor)),
                    checkmarkColor: colorTurqoise,
                    onSelected: (isSelected) {
                      if (isMaleSelected) {
                        tutorList = saveTutors;
                      }
                      String newGen = 'Female';
                      filterGender(newGen);
                      setState(() {
                        if (isSelected) {
                          checkedColor = colorTurqoise;
                          const snackBar = SnackBar(
                            content: Text('Filter option applied'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          isMaleSelected = !isSelected;
                          isFemaleSelected = isSelected;
                        } else {
                          checkedColor = colorBlack;
                          isFemaleSelected = isSelected;
                          if (!isFirstSelected ||
                              !isSecondSelected ||
                              !isThirdSelected ||
                              !isForthSelected ||
                              !isFifthSelected) {
                            tutorList = saveTutors;
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
              Row(
                children: <Widget>[
                  FilterChip(
                    selectedColor: colorTurqoise.withOpacity(0.5),
                    label: Text(
                      '16-18',
                      style: TextStyle(color: checkedColor),
                    ),
                    backgroundColor: Colors.white60,
                    shape: StadiumBorder(side: BorderSide(color: checkedColor)),
                    checkmarkColor: colorTurqoise,
                    onSelected: (isSelected) {
                      if (isSecondSelected ||
                          isThirdSelected ||
                          isForthSelected ||
                          isFifthSelected) {
                        tutorList = saveTutors;
                      }

                      String newAge = '16-18';
                      filterAge(newAge);
                      setState(() {
                        if (isSelected) {
                          checkedColor = colorTurqoise;
                          const snackBar = SnackBar(
                            content: Text('Filter option applied'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          isFirstSelected = isSelected;
                          isSecondSelected = !isSelected;
                          isThirdSelected = !isSelected;
                          isForthSelected = !isSelected;
                          isFifthSelected = !isSelected;
                        } else {
                          checkedColor = colorBlack;
                          isFirstSelected = isSelected;
                          tutorList = saveTutors;
                        }
                      });
                    },
                    selected: isFirstSelected,
                    // avatar: const Icon(Icons.male),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  FilterChip(
                    selectedColor: colorTurqoise.withOpacity(0.5),
                    label: Text(
                      '19-21',
                      style: TextStyle(color: checkedColor),
                    ),
                    backgroundColor: Colors.white60,
                    shape: StadiumBorder(side: BorderSide(color: checkedColor)),
                    checkmarkColor: colorTurqoise,
                    onSelected: (isSelected) {
                      if (isFirstSelected ||
                          isThirdSelected ||
                          isForthSelected ||
                          isFifthSelected) {
                        tutorList = saveTutors;
                      }
                      String newAge = '19-21';
                      filterAge(newAge);
                      setState(() {
                        if (isSelected) {
                          checkedColor = colorTurqoise;
                          const snackBar = SnackBar(
                            content: Text('Filter option applied'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          isSecondSelected = isSelected;
                          isFirstSelected = !isSelected;
                          isThirdSelected = !isSelected;
                          isForthSelected = !isSelected;
                          isFifthSelected = !isSelected;
                        } else {
                          checkedColor = colorBlack;
                          isSecondSelected = isSelected;
                          tutorList = saveTutors;
                        }
                      });
                    },
                    selected: isSecondSelected,
                    // avatar: const Icon(Icons.male),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  FilterChip(
                    selectedColor: colorTurqoise.withOpacity(0.5),
                    label: Text(
                      '22-25',
                      style: TextStyle(color: checkedColor),
                    ),
                    backgroundColor: Colors.white60,
                    shape: StadiumBorder(side: BorderSide(color: checkedColor)),
                    checkmarkColor: colorTurqoise,
                    onSelected: (isSelected) {
                      if (isFirstSelected ||
                          isSecondSelected ||
                          isForthSelected ||
                          isFifthSelected) {
                        tutorList = saveTutors;
                      }
                      String newAge = '22-25';
                      filterAge(newAge);
                      setState(() {
                        if (isSelected) {
                          checkedColor = colorTurqoise;
                          const snackBar = SnackBar(
                            content: Text('Filter option applied'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          isThirdSelected = isSelected;
                          isFirstSelected = !isSelected;
                          isSecondSelected = !isSelected;
                          isForthSelected = !isSelected;
                          isFifthSelected = !isSelected;
                        } else {
                          checkedColor = colorBlack;
                          isThirdSelected = isSelected;
                          tutorList = saveTutors;
                        }
                      });
                    },
                    selected: isThirdSelected,
                    // avatar: const Icon(Icons.male),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  FilterChip(
                    selectedColor: colorTurqoise.withOpacity(0.5),
                    label: Text(
                      '26-35',
                      style: TextStyle(color: checkedColor),
                    ),
                    backgroundColor: Colors.white60,
                    shape: StadiumBorder(side: BorderSide(color: checkedColor)),
                    checkmarkColor: colorTurqoise,
                    onSelected: (isSelected) {
                      if (isFirstSelected ||
                          isSecondSelected ||
                          isThirdSelected ||
                          isFifthSelected) {
                        tutorList = saveTutors;
                      }
                      String newAge = '26-35';
                      filterAge(newAge);
                      setState(() {
                        if (isSelected) {
                          checkedColor = colorTurqoise;
                          const snackBar = SnackBar(
                            content: Text('Filter option applied'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          isForthSelected = isSelected;
                          isFirstSelected = !isSelected;
                          isSecondSelected = !isSelected;
                          isThirdSelected = !isSelected;
                          isFifthSelected = !isSelected;
                        } else {
                          checkedColor = colorBlack;
                          isForthSelected = isSelected;
                          tutorList = saveTutors;
                        }
                      });
                    },
                    selected: isForthSelected,
                    // avatar: const Icon(Icons.male),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  FilterChip(
                    selectedColor: colorTurqoise.withOpacity(0.5),
                    label: Text(
                      '36+',
                      style: TextStyle(color: checkedColor),
                    ),
                    backgroundColor: Colors.white60,
                    shape: StadiumBorder(side: BorderSide(color: checkedColor)),
                    checkmarkColor: colorTurqoise,
                    onSelected: (isSelected) {
                      if (isFirstSelected ||
                          isSecondSelected ||
                          isThirdSelected ||
                          isForthSelected) {
                        tutorList = saveTutors;
                      }
                      String newAge = '36+';
                      filterAge(newAge);
                      setState(() {
                        if (isSelected) {
                          checkedColor = colorTurqoise;
                          const snackBar = SnackBar(
                            content: Text('Filter option applied'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          isFifthSelected = isSelected;
                          isFirstSelected = !isSelected;
                          isSecondSelected = !isSelected;
                          isThirdSelected = !isSelected;
                          isForthSelected = !isSelected;
                        } else {
                          checkedColor = colorBlack;
                          isFifthSelected = isSelected;
                          tutorList = saveTutors;
                        }
                      });
                    },
                    selected: isFifthSelected,
                    // avatar: const Icon(Icons.male),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      _isLoading
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                // padding: const EdgeInsets.all(10),
                itemCount: tutorList.length,
                itemBuilder: _cardBuilder,
              ),
            ),
    ])));
  }

  Widget _cardBuilder(BuildContext context, int i) {
    String name = tutorList[i].getName;
    name += ' ' + tutorList[i].getLastName;
    return GestureDetector(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: colorTurqoise, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/Pictures/penguin.png')),
                title: Text(name),
                subtitle: Text(
                  tutorList[i].getBio,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(tutorList[i].getRating),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    )
                  ],
                )),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TutorProfilePageView(
                  tutor: tutorList[i],
                  tutee: widget.tutee,
                )));
      },
    );
  }
}
