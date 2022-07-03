import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/services/services/tutor_services.dart';
import 'package:tutor_me/src/authenticate/register_step3.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tutor_page.dart';
import '../../services/models/tutees.dart';
import '../../services/services/tutee_services.dart';
import '../components.dart';
import '../tutee_page.dart';

// ignore: must_be_immutable
class RegisterStep2 extends StatefulWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RegisterStep2(this.emailController, this.passwordController,
      this.confirmPasswordController,
      {Key? key})
      : super(key: key);

  @override
  _RegisterStep2State createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode dobFocusNode = FocusNode();
  final FocusNode genderFocusNode = FocusNode();
  final FocusNode institutionFocusNode = FocusNode();
  final FocusNode courseFocusNode = FocusNode();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  String toRegister = 'Tutor';
  late Tutors tutor;
  late Tutees tutee;

  // register() async {
  //   if (toRegister == "Tutor") {
  //     try {
  //       tutor = await TutorServices.registerTutor(
  //         firstNameController.text,
  //         lastNameController.text,
  //         dobController.text,
  //         genderController.text,
  //         institutionController.text,
  //         emailController.text,
  //         passwordController.text,
  //         // courseController.text,
  //         confirmPasswordController.text,
  //       );
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const TutorPage()),
  //       );
  //     } catch (e) {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: const Text("One Or More Errors Occured"),
  //             content: Text(e.toString()),
  //             backgroundColor: colorWhite,
  //             titleTextStyle: TextStyle(
  //               color: colorOrange,
  //               fontSize: MediaQuery.of(context).size.height * 0.03,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: const Text("Retry"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   } else {
  //     try {
  //       tutee = await TuteeServices.registerTuee(
  //         firstNameController.text,
  //         lastNameController.text,
  //         dobController.text,
  //         genderController.text,
  //         institutionController.text,
  //         emailController.text,
  //         passwordController.text,
  //         confirmPasswordController.text,
  //       );

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const TuteePage()),
  //       );
  //     } catch (e) {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: const Text("One Or More Errors Occured"),
  //             content: Text(e.toString()),
  //             backgroundColor: colorWhite,
  //             titleTextStyle: TextStyle(
  //               color: colorOrange,
  //               fontSize: MediaQuery.of(context).size.height * 0.03,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: const Text("Retry"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

  int current_step = 0;
  // List<Step> stepsOfRegister  =[
  //   Step(title: title, content: content)
  // ]

  @override
  Widget build(BuildContext context) {
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
              Flexible(
                child: Text(
                  'Step 2/3 - Personal Information',
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Center(
                child: ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width * 0.4,
                  minHeight: MediaQuery.of(context).size.height * 0.06,
                  cornerRadius: MediaQuery.of(context).size.height * 0.07,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  iconSize: MediaQuery.of(context).size.height * 0.05,
                  activeBgColor: const [colorOrange],
                  activeFgColor: colorWhite,
                  inactiveBgColor: colorGrey,
                  inactiveFgColor: colorWhite,
                  totalSwitches: 2,
                  labels: const ['Tutor', 'Tutee'],
                  icons: const [Icons.edit, Icons.person_outlined],
                  onToggle: (index) {
                    if (index == 0) {
                      toRegister = "Tutor";
                    } else {
                      toRegister = "Tutee";
                    }
                  },
                ),
              ),

              TextInputField(
                icon: Icons.person_outline,
                hint: 'Enter Full Name',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                inputController: firstNameController,
                // inputFocus: firstNameFocusNode,
              ),
              TextInputField(
                icon: Icons.person_outline,
                hint: 'Enter Last Name',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                inputController: lastNameController,
                // inputFocus: lastNameFocusNode,
              ),
              TextInputField(
                icon: Icons.calendar_month_outlined,
                hint: 'Enter DOB (DD/MM/YYYY)',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                inputController: dobController,
                // inputFocus: dobFocusNode,
              ),
              TextInputField(
                icon: Icons.female_outlined,
                hint: 'Gender',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                inputController: genderController,
                // inputFocus: genderFocusNode,
              ),
              // TextInputField(
              //   icon: Icons.school_outlined,
              //   hint: 'Course',
              //   inputType: TextInputType.emailAddress,
              //   inputAction: TextInputAction.next,
              //   inputController: courseController,
              //   // inputFocus: courseFocusNode,
              // ),
              // TextInputField(
              //   icon: Icons.school_outlined,
              //   hint: 'Enter Institution Name',
              //   inputType: TextInputType.emailAddress,
              //   inputAction: TextInputAction.next,
              //   inputController: institutionController,
              //   // inputFocus: institutionFocusNode,
              // ),
              // Flexible(
              //   child: Text(
              //     '',
              //     style: TextStyle(
              //       color: colorWhite,
              //       fontSize: MediaQuery.of(context).size.width * 0.03,
              //       fontWeight: FontWeight.normal,
              //     ),
              //   ),
              // ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              // TextInputField(
              //   icon: Icons.email_outlined,
              //   hint: 'Enter Your Email',
              //   inputType: TextInputType.emailAddress,
              //   inputAction: TextInputAction.next,
              //   inputController: emailController,
              //   // inputFocus: emailFocusNode,
              // ),
              // PasswordInput(
              //   icon: Icons.lock_outline_rounded,
              //   hint: 'Password',
              //   inputAction: TextInputAction.next,
              //   inputType: TextInputType.text,
              //   inputController: passwordController,
              //   inputFocus: passwordFocusNode,
              // ),
              // PasswordInput(
              //   icon: Icons.password_outlined,
              //   hint: 'Confirm Password',
              //   inputAction: TextInputAction.next,
              //   inputType: TextInputType.text,
              //   inputController: confirmPasswordController,
              //   inputFocus: confirmPasswordFocusNode,
              // ),
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
                    String errMsg = "";

                    if (firstNameController.text == "" ||
                            lastNameController.text == "" ||
                            dobController.text == "" ||
                            genderController.text == ""
                        // institutionController.text == "" ||
                        // courseController.text == ""

                        ) {
                      errMsg += "ERROR: One or more parametres missing\n";
                    } else {
                      int day = int.parse(dobController.text.split("/")[0]);
                      int month = int.parse(dobController.text.split("/")[1]);
                      int year = int.parse(dobController.text.split("/")[2]);

                      if (
                          // zday > 31 ||
                          day < 1 ||
                              month > 12 ||
                              month < 1 ||
                              year < 1900 ||
                              year > 2020) {
                        errMsg += "ERROR: Invalid Date of Birth\n";
                      }

                      if (dobController.text.contains("/") == false) {
                        errMsg += "ERROR: Invalid Date of Birth\n";
                      }
                    }

                    if (errMsg != "") {
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
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterStep3()),
                      );
                    }
                  },
                  child: const Text("Continue",
                      style: TextStyle(
                        fontSize: 18,
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
}
