// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../components.dart';

class UpdateTutee extends StatefulWidget {
  const UpdateTutee({Key? key}) : super(key: key);

  @override
  UpdateTuteeState createState() => UpdateTuteeState();
}

class UpdateTuteeState extends State<UpdateTutee> {
  final FocusNode idFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController oldemailcontroller = TextEditingController();
  final TextEditingController newemailcontroller = TextEditingController();

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
                  TextInputField(
                    icon: Icons.email_outlined,
                    hint: 'Enter the old Email',
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                    inputController: oldemailcontroller,
                  ),
                  TextInputField(
                    icon: Icons.email_outlined,
                    hint: 'Enter the new Email',
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                    inputController: newemailcontroller,
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
                    String errMsg = "";
                    if (oldemailcontroller.text.isEmpty ||
                        newemailcontroller.text.isEmpty) {
                      errMsg +=
                          "Please fill in the Tutee's Old and New Email \n";
                    }

                    if (oldemailcontroller.text.isEmpty ==
                        newemailcontroller.text.isEmpty) {
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
                      : const Text("Update Tutee",
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
