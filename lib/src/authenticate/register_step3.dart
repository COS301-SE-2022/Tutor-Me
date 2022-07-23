// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/services/services/tutor_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tutor_page.dart';
import '../../services/models/tutees.dart';
import '../../services/services/module_services.dart';
import '../../services/services/tutee_services.dart';
import '../components.dart';
import '../tutee_page.dart';
import 'register_step1.dart';

// ignore: must_be_immutable
class RegisterStep3 extends StatefulWidget {
  final email;
  final password;
  final confirmPassword;
  final fullName;
  final lastName;
  final dob;
  final gender;
  final toRegister;

  const RegisterStep3(
      {Key? key,
      this.email,
      this.password,
      this.confirmPassword,
      this.fullName,
      this.lastName,
      this.dob,
      this.gender,
      this.toRegister})
      : super(key: key);

  @override
  _RegisterStep3State createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  final FocusNode institutionFocusNode = FocusNode();
  final FocusNode courseFocusNode = FocusNode();

  final TextEditingController institutionController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  late Tutors tutor;
  late Tutees tutee;
  int currentStep = 2;

  register() async {
    if (widget.toRegister == "Tutor") {
      try {
        tutor = await TutorServices.registerTutor(
            widget.fullName,
            widget.lastName,
            widget.dob,
            widget.gender,
            institutionController.text,
            widget.email,
            widget.password,
            // courseController.text,
            //yearLvl
            widget.confirmPassword,
            '1', //TODO:change to actual value
            'Bsc Computer Sciences');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TutorPage(user: tutor)),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("One Or More Errors Occured"),
              content: Text(e.toString()),
              backgroundColor: colorWhite,
              titleTextStyle: TextStyle(
                color: colorOrange,
                fontSize: MediaQuery.of(context).size.height * 0.03,
                fontWeight: FontWeight.bold,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Retry"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      try {
        tutee = await TuteeServices.registerTutee(
            widget.fullName,
            widget.lastName,
            widget.dob,
            widget.gender,
            institutionController.text,
            widget.email,
            widget.password,
            // courseController.text,
            //yearLvl
            widget.confirmPassword,
            '1', //TODO: Change to actual value
            'Bsc Computer Sciences' //TODO: change to actual value
            );

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TuteePage(
                    user: tutee,
                  )),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("One Or More Errors Occured"),
              content: Text(e.toString()),
              backgroundColor: colorWhite,
              titleTextStyle: TextStyle(
                color: colorOrange,
                fontSize: MediaQuery.of(context).size.height * 0.03,
                fontWeight: FontWeight.bold,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Retry"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  List items = List<String>.empty();

  getInstitutions() async {
    final insitutions = await ModuleServices.getInstitutions();
    setState(() {
      items = insitutions;
    });
  }

  List<String> yearlevels = [
    "Year - 1",
    "Year - 2",
    "Year - 3",
    "Year - 4",
    "Postgraduate",
  ];

  String? institution;
  String? yearLvl;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    getInstitutions();

    return Scaffold(
      // key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [Colors.black, Colors.transparent],
            ).createShader(rect),
            blendMode: BlendMode.darken,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Pictures/register_login.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black54,
                        BlendMode.darken,
                      ))),
            ),
          ),
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Flexible(
                child: Text(
                  'Lets Continue...',
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: MediaQuery.of(context).size.width * 0.12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Theme(
                  data: ThemeData(
                      primarySwatch: Colors.green,
                      canvasColor: Colors.transparent,
                      colorScheme: ColorScheme.fromSwatch().copyWith(
                          secondary: colorOrange, primary: colorOrange)),
                  child: Stepper(
                    type: StepperType.horizontal,
                    steps: getSteps(),
                    currentStep: currentStep,
                  ),
                ),
              ),
              TextInputField(
                icon: Icons.school,
                hint: 'Course',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                inputController: courseController,
                // inputFocus: courseFocusNode,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.007,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.07,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.06,
                    right: MediaQuery.of(context).size.width * 0.01),
                child: DropdownButton<String>(
                  dropdownColor: colorOrange,
                  icon: Icon(Icons.arrow_drop_down,
                      color: colorWhite,
                      size: MediaQuery.of(context).size.width * 0.08),
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                  hint: institution == null
                      ? Row(
                          children: [
                            const Icon(
                              Icons.grade_sharp,
                              color: colorWhite,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            const Text('Select Year Level',
                                style: TextStyle(color: colorWhite)),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(
                              Icons.school,
                              color: colorWhite,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text(
                              institution!,
                              style: const TextStyle(color: colorWhite),
                            ),
                          ],
                        ),
                  isExpanded: true,
                  value: yearLvl,
                  items: yearlevels.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.house_outlined,
                              color: colorWhite,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text(val),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        yearLvl = val;
                      },
                    );
                  },
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[500]!.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorOrange,
                    width: 1,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.07,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.06,
                    right: MediaQuery.of(context).size.width * 0.01),
                child: DropdownButton<String>(
                  dropdownColor: colorOrange,
                  icon: Icon(Icons.arrow_drop_down,
                      color: colorWhite,
                      size: MediaQuery.of(context).size.width * 0.08),
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                  hint: institution == null
                      ? Row(
                          children: [
                            const Icon(
                              Icons.school,
                              color: colorWhite,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            const Text('Select Institution',
                                style: TextStyle(color: colorWhite)),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(
                              Icons.school,
                              color: colorWhite,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text(
                              institution!,
                              style: const TextStyle(color: colorWhite),
                            ),
                          ],
                        ),
                  isExpanded: true,
                  value: institution,
                  items: items.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.house_outlined,
                              color: colorWhite,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text(val),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        institution = val;
                      },
                    );
                  },
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[500]!.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorOrange,
                    width: 1,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  '',
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colorOrange,
                ),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    String errMsg = "";
                    institution ??= "";

                    if (institution == "" || courseController.text == "") {
                      errMsg += "ERROR: One or more parametres missing\n";
                    } else {}

                    if (errMsg != "") {
                      setState(() {
                        isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("One Or More Errors Occured"),
                            content: Text(errMsg),
                            backgroundColor: colorWhite,
                            titleTextStyle: TextStyle(
                              color: colorOrange,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  "Retry",
                                  style: TextStyle(color: colorWhite),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterStep1()),
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      register();
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Register",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Container(),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Text(
            'Personal',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Container(),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const Text(
            'Education',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Container(),
        ),
      ];
}
