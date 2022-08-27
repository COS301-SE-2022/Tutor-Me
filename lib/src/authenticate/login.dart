import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tutor_me/src/authenticate/register_step1.dart';
import 'package:tutor_me/src/colorpallete.dart';
// import '../../services/models/tutees.dart';
// import '../../services/models/tutors.dart';
import '../../services/services/user_services.dart';
import '../../services/models/users.dart';
import '../components.dart';
import '../tutor_page.dart';
import '../tutee_page.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late Users tutor;
  late Users tutee;
  String toRegister = 'Tutor';

  bool isLoading = false;
  int? initialIndex = 0;
  @override
  Widget build(BuildContext context) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    double toggleWidth = MediaQuery.of(context).size.width * 0.4;
    double textBoxWidth = MediaQuery.of(context).size.width * 0.4 * 2;
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;
    if (widthOfScreen >= 400.0) {
      toggleWidth = toggleWidth / 2;
      buttonWidth = buttonWidth / 2;
      textBoxWidth = textBoxWidth / 2;
    }
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
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.height,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.email_outlined,
                      hint: 'Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      inputController: emailController,
                      // inputFocus: emailFocusNode,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: PasswordInput(
                      icon: Icons.lock_clock_outlined,
                      hint: 'Password',
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      inputController: passwordController,
                      inputFocus: passwordFocusNode,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
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
                    String errMsg = "";
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      errMsg += "Please fill in all fields";
                    }

                    // if (passwordController.text.length < 8) {
                    //   errMsg += "Password must be at least 6 characters";
                    // }

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
                                  style: TextStyle(color: colorOrange),
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
                      if (toRegister == "Tutor") {
                        try {
                          // TutorServices tutor = TutorServices.Login(
                          tutor = await UserServices.logInTutor(
                              emailController.text, passwordController.text);
                          tutor.setStatus = true;
                          await UserServices.updateTutor(tutor);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TutorPage(user: tutor)),
                          );

                          setState(() {
                            isLoading = false;
                          });
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
                          tutee = await UserServices.logInTutee(
                              emailController.text, passwordController.text);
                          tutee.setStatus = true;
                          await UserServices.updateTutee(tutee);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TuteePage(user: tutee)),
                          );

                          setState(() {
                            isLoading = false;
                          });
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("One Or More Errors Occured"),
                                content: const Text(
                                    "Invalid Password, Email or Network Connection"),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterStep1()),
                  );
                },
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
