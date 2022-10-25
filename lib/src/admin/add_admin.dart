// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../services/models/globals.dart';
import '../../services/services/admin_services.dart';
import '../components.dart';
// import '../../services/services/module_services.dart';

class AddAdmin extends StatefulWidget {
  final Globals global;
  const AddAdmin({Key? key, required this.global}) : super(key: key);

  @override
  AddAdminState createState() => AddAdminState();
}

class AddAdminState extends State<AddAdmin> {
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmpasswordFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController lastNamecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
      bool obscureText = true;
  bool confirmObscureText = true;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    double textBoxWidth = MediaQuery.of(context).size.width * 0.4 * 2;
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;
    if (widthOfScreen >= 600.0) {
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
                      image: AssetImage("assets/Pictures/Admin_Background.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black54,
                        BlendMode.darken,
                      ))),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: Column(children: [
              const Flexible(
                child: Center(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.person,
                      hint: 'Admins Name',
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      inputController: namecontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.person,
                      hint: 'Admins LastName',
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      inputController: lastNamecontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.email,
                      hint: 'Admins Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.done,
                      inputController: emailcontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: PasswordInput(
                      icon: Icons.lock_clock_outlined,
                      hint: 'Password',
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      inputController: passwordcontroller,
                      inputFocus: passwordFocusNode,
                       obscureText: obscureText,
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: PasswordInput(
                      icon: Icons.lock_clock_outlined,
                      hint: 'Comfirm Password',
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      inputController: confirmpasswordcontroller,
                      inputFocus: confirmpasswordFocusNode,
                       obscureText: confirmObscureText,
                    onPressed: () {
                      setState(() {
                        confirmObscureText = !confirmObscureText;
                      });
                    },
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
                  color: colorBlack,
                  border: Border.all(color: colorWhite),
                ),
                child: TextButton(
                  onPressed: () async {
                    String errMsg = "";
                    if (namecontroller.text.isEmpty) {
                      errMsg += "Please fill in the Module Code \n";
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
                              color: colorBlack,
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
                    AdminServices.registerAdmin(
                        namecontroller.text,
                        lastNamecontroller.text,
                        emailcontroller.text,
                        passwordcontroller.text,
                        confirmpasswordcontroller.text);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Success"),
                          content: Text(namecontroller.text +
                              " " +
                              lastNamecontroller.text +
                              " Added"),
                          backgroundColor: colorWhite,
                          titleTextStyle: TextStyle(
                            color: colorBlack,
                            fontSize: MediaQuery.of(context).size.height * 0.03,
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
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Add Admin",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                ),
              ),
              const SizedBox(
                height: 240,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
