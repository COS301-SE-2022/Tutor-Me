import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/users.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../components.dart';
import './admin_home.dart';
import '../../services/services/admin_services.dart';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({Key? key}) : super(key: key);

  @override
  LoginAdminState createState() => LoginAdminState();
}

class LoginAdminState extends State<LoginAdmin> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late Users admin;

  bool isLoading = false;
  int? initialIndex = 0;
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
                      image: AssetImage("assets/Pictures/Admin.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black54,
                        BlendMode.darken,
                      ))),
            ),
          ),
          Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  const Flexible(
                    child: Center(
                      child: Text(
                        'Admin',
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
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    TextInputField(
                      icon: Icons.email_outlined,
                      hint: 'Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      inputController: emailController,
                      // inputFocus: emailFocusNode,
                    ),
                    PasswordInput(
                      icon: Icons.lock_clock_outlined,
                      hint: 'Password',
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      inputController: passwordController,
                      inputFocus: passwordFocusNode,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: colorBlack,
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
                                  title:
                                      const Text("One Or More Errors Occured"),
                                  content: Text(errMsg),
                                  backgroundColor: colorWhite,
                                  titleTextStyle: TextStyle(
                                    color: colorBlack,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
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
                            try {
                              admin = await AdminServices.logInAdmin(
                                  emailController.text,
                                  passwordController.text);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AdminHome(user: admin)),
                              );
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "One Or More Errors Occured"),
                                    content:
                                        const Text("Invalid Password or Email"),
                                    backgroundColor: colorWhite,
                                    titleTextStyle: TextStyle(
                                      color: colorBlack,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.03,
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
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                      ),
                    ),
                  ]),
                ],
              )),
        ],
      ),
    );
  }
}
