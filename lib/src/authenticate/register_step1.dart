import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tutor_me/src/authenticate/login.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../components.dart';
import 'register_step2.dart';
import 'package:email_auth/email_auth.dart';

class RegisterStep1 extends StatefulWidget {
  const RegisterStep1({Key? key}) : super(key: key);

  @override
  _RegisterStep1State createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  String inputOTP = "";
  String errMsg = "";
  EmailAuth emailAuth = EmailAuth(sessionName: "TutorWhizz");
  void sendOTP() async {
    var res = await emailAuth.sendOtp(
        recipientMail: emailController.text, otpLength: 5);
    if (res) {
      Fluttertoast.showToast(
          msg: "OTP sent to your Email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoading = false;
      });
    } else {
      errMsg += "Unable to send OTP\n";
    }
  }

  void verifyOTP() async {
    var res = emailAuth.validateOtp(
        recipientMail: emailController.text, userOtp: inputOTP);
    if (res) {
      Fluttertoast.showToast(
          msg: "OTP verified",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterStep2(
              email: emailController.text,
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
              toRegister: toRegister,
            ),
          ));
      setState(() {
        isLoading = false;
      });
    } else {
      errMsg += "invalid OTP input\n";
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Verify Email'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  inputOTP = value;
                  verifyOTP();
                });
              },
              controller: otpController,
              decoration: const InputDecoration(
                  hintText: "Enter OTP sent to your email"),
            ),
          );
        });
  }

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String toRegister = 'Tutor';
  int currentStep = 0;

  bool isLoading = false;
  int? initialIndex = 0;
  @override
  Widget build(BuildContext context) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    double stepperWidth = MediaQuery.of(context).size.width * 0.95;
    double toggleWidth = MediaQuery.of(context).size.width * 0.4;
    double textBoxWidth = MediaQuery.of(context).size.width * 0.4 * 2;
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;
    String welcome = "";
    if (widthOfScreen < 600.0) {
      welcome = "Hi, Welcome!";
    } else {
      stepperWidth = stepperWidth / 2;
      toggleWidth = toggleWidth / 2;
      buttonWidth = buttonWidth / 2;
      textBoxWidth = textBoxWidth / 2;
    }
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
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Flexible(
                child: Text(
                  welcome,
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: MediaQuery.of(context).size.height * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              // Flexible(

              SizedBox(
                width: stepperWidth,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Theme(
                  data: ThemeData(
                      primarySwatch: Colors.green,
                      canvasColor: Colors.transparent,
                      colorScheme: ColorScheme.fromSwatch().copyWith(
                          secondary: colorBlueTeal, primary: colorOrange)),
                  child: Stepper(
                    onStepCancel: null,
                    onStepContinue: null,
                    controlsBuilder: (context, details) =>
                        const SizedBox.shrink(),
                    type: StepperType.horizontal,
                    steps: getSteps(),
                    currentStep: currentStep,
                  ),
                ),
              ),

              Center(
                child: ToggleSwitch(
                  minWidth: toggleWidth,
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
                  initialLabelIndex: initialIndex,
                  onToggle: (index) {
                    if (index == 0) {
                      toRegister = "Tutor";
                    } else {
                      toRegister = "Tutee";
                    }
                    setState(() {
                      initialIndex = index;
                    });
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              SizedBox(
                width: textBoxWidth,
                child: TextInputField(
                  icon: Icons.email_outlined,
                  hint: 'Enter Your Email',
                  inputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  inputController: emailController,
                  // inputFocus: emailFocusNode,
                ),
              ),
              SizedBox(
                width: textBoxWidth,
                child: PasswordInput(
                  icon: Icons.lock_outline_rounded,
                  hint: 'Password',
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  inputController: passwordController,
                  inputFocus: passwordFocusNode,
                ),
              ),
              SizedBox(
                width: textBoxWidth,
                child: PasswordInput(
                  icon: Icons.password_outlined,
                  hint: 'Confirm Password',
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  inputController: confirmPasswordController,
                  inputFocus: confirmPasswordFocusNode,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: buttonWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colorOrange,
                ),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    if (emailController.text == "" ||
                        passwordController.text == "" ||
                        confirmPasswordController.text == "") {
                      errMsg += "One or more parametres missing\n";
                    } else {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        errMsg += "Passwords do not match\n";
                      }

                      if (passwordController.text.length < 8 ||
                          confirmPasswordController.text.length < 8) {
                        errMsg +=
                            "Password must be at least 8 characters long\n";
                      }

                      if (emailController.text.contains("@") == false ||
                          emailController.text.contains(".") == false) {
                        errMsg += "Invalid Email\n";
                      }
                    }

                    if (toRegister == "Tutor") {
                      // bool isThereTutorWithEmail =
                      //     await UserServices.isThereTutorByEmail(
                      //         emailController.text, );

                    } else {
                      // bool isThereTuteeWithEmail =
                      //     await UserServices.isThereTuteeByEmail(
                      //         emailController.text);

                    }

                    sendOTP();

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
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      _displayTextInputDialog(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => RegisterStep2(
                      //         email: emailController.text,
                      //         password: passwordController.text,
                      //         confirmPassword: confirmPasswordController.text,
                      //         toRegister: toRegister,
                      //       ),
                      //     ));
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Continue",
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterStep1()),
                  );
                },
                child: TextButton(
                  onPressed: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  }),
                  child: const Text(
                    "Already have and account? Login",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          ),
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
