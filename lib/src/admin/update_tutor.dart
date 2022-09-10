// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../components.dart';

class UpdateTutor extends StatefulWidget {
  const UpdateTutor({Key? key}) : super(key: key);

  @override
  UpdateTutorState createState() => UpdateTutorState();
}

class UpdateTutorState extends State<UpdateTutor> {
  final FocusNode idFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController oldemailcontroller = TextEditingController();
  final TextEditingController newemailcontroller = TextEditingController();

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
                child: Center(
                  child: Text(
                    'Update Email',
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
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.email_outlined,
                      hint: 'Enter the old Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      inputController: oldemailcontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.email_outlined,
                      hint: 'Enter the new Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      inputController: newemailcontroller,
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
                    if (oldemailcontroller.text.isEmpty ||
                        newemailcontroller.text.isEmpty) {
                      errMsg +=
                          "Please fill in the Tutor's Old and New Email \n";
                    }

                    if (oldemailcontroller.text == newemailcontroller.text) {
                      errMsg += "Old and new Email must differ \n";
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

                    //TODO fix this

                    // UserServices.updateTutorByEmail(
                    //     oldemailcontroller.text, newemailcontroller.text);
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update Tutor",
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
