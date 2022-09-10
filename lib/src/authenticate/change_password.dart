// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../services/services/user_services.dart';
import '../components.dart';
import '../tutee_page.dart';
import '../tutor_page.dart';

class ChangePassword extends StatefulWidget {
  final email;
  final toRegister;
  const ChangePassword({Key? key, this.email, this.toRegister})
      : super(key: key);

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  final FocusNode oldPasswordFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController newconfirmpasswordController =
      TextEditingController();
  late Globals globals;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            backgroundColor: Colors.transparent,
            body: Column(children: [
              const Flexible(
                child: Center(
                  child: Text(
                    'Tutor Me',
                    style: TextStyle(
                      color: colorWhite,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Flexible(
                child: Text(
                  '',
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.height,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PasswordInput(
                    icon: Icons.lock_clock_outlined,
                    hint: 'New Password',
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    inputController: newpasswordController,
                    inputFocus: oldPasswordFocusNode,
                  ),
                  PasswordInput(
                    icon: Icons.lock_clock_outlined,
                    hint: 'Confirm Password',
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    inputController: newconfirmpasswordController,
                    inputFocus: passwordFocusNode,
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
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
                    if (newpasswordController.text.isEmpty ||
                        newconfirmpasswordController.text.isEmpty) {
                      errMsg += "Please fill in all fields";
                    }

                    if (newpasswordController.text.length < 8) {
                      errMsg += "Password must be at least 6 characters";
                    }

                    if (newpasswordController.text !=
                        newconfirmpasswordController.text) {
                      errMsg += "Password must match";
                    }

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
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      if (widget.toRegister == "Tutor") {
                        try {
                          // TutorServices tutor = TutorServices.Login(
                          globals =
                              await UserServices.getTutorByEmail(widget.email, globals);
                          await UserServices.changePassword(newpasswordController.text, globals);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TutorPage(globals: globals)),
                          );
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("One Or More Errors Occured"),
                                content:
                                    const Text("Invalid Password or Email"),
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
                        }
                      } else {
                        try {
                          // TutorServices tutor = TutorServices.Login(
                          globals =
                              await UserServices.getTuteeByEmail(widget.email, globals);
                          await UserServices.changePassword(newpasswordController.text, globals);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TuteePage(globals: globals)),
                          );
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("One Or More Errors Occured"),
                                content:
                                    const Text("Invalid Password or Email"),
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
                        }
                      }
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                ),
              ),

              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  child: const Text(
                    "Create New Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              )

              //second input
            ]),
          )
        ],
      ),
    );
  }
}
