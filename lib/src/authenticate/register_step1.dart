import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../components.dart';
import 'register_step2.dart';

class RegisterStep1 extends StatefulWidget {
  const RegisterStep1({Key? key}) : super(key: key);

  @override
  _RegisterStep1State createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String toRegister = 'Tutor';
  int currentStep = 0;

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
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Flexible(
                child: Text(
                  'Hi, Welcome!',
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
              // Flexible(

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
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextInputField(
                icon: Icons.email_outlined,
                hint: 'Enter Your Email',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                inputController: emailController,
                // inputFocus: emailFocusNode,
              ),
              PasswordInput(
                icon: Icons.lock_outline_rounded,
                hint: 'Password',
                inputAction: TextInputAction.next,
                inputType: TextInputType.text,
                inputController: passwordController,
                inputFocus: passwordFocusNode,
              ),
              PasswordInput(
                icon: Icons.password_outlined,
                hint: 'Confirm Password',
                inputAction: TextInputAction.next,
                inputType: TextInputType.text,
                inputController: confirmPasswordController,
                inputFocus: confirmPasswordFocusNode,
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
                    String errMsg = "";

                    if (emailController.text == "" ||
                        passwordController.text == "" ||
                        confirmPasswordController.text == "") {
                      errMsg += "ERROR: One or more parametres missing\n";
                    } else {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        errMsg += "ERROR: Passwords do not match\n";
                      }

                      if (passwordController.text.length < 8 ||
                          confirmPasswordController.text.length < 8) {
                        errMsg +=
                            "ERROR: Password must be at least 8 characters long\n";
                      }

                      if (emailController.text.contains("@") == false ||
                          emailController.text.contains(".") == false) {
                        errMsg += "ERROR: Invalid Email\n";
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
