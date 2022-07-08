// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../services/models/tutees.dart';
import '../../services/models/tutors.dart';
import '../components.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OTP extends StatefulWidget {
  final email;
  final emailAuth;
  const OTP({Key? key, this.email, this.emailAuth}) : super(key: key);

  @override
  OTPState createState() => OTPState();
}

class OTPState extends State<OTP> {
  final FocusNode emailFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController otpcontroller = TextEditingController();
  late Tutors tutor;
  late Tutees tutee;
  String toRegister = 'Tutor';
  bool isActive = false;

  void verifyOTP() async {
    var res = widget.emailAuth.validateOtp(
        recipientMail: widget.email, userOtp: otpcontroller.value.text);
    if (res) {
      Fluttertoast.showToast(
          msg: "OTP verified",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoading = false;
      });
      
    } else {
      Fluttertoast.showToast(
          msg: "invalid input",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

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

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.height,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextInputField(
                    icon: Icons.lock_clock_outlined,
                    hint: 'OTP',
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.done,
                    inputController: otpcontroller,
                    // inputFocus: passwordFocusNode,
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
                    verifyOTP();
                    String errMsg = "";
                    if (otpcontroller.text.isEmpty) {
                      errMsg += "Please fill in your OTP";
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
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Verify OTP",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                ),
              ), //second input
            ]),
          )
        ],
      ),
    );
  }
}
