// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../services/models/globals.dart';
import '../../services/services/admin_services.dart';
import '../components.dart';
// import '../../services/services/module_services.dart';

class AddModule extends StatefulWidget {
  final Globals global;
  const AddModule({Key? key, required this.global}) : super(key: key);

  @override
  AddModuleState createState() => AddModuleState();
}

class AddModuleState extends State<AddModule> {
  final FocusNode idFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController codecontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController institutioncontroller = TextEditingController();
  final TextEditingController facultycontroller = TextEditingController();
  final TextEditingController yearcontroller = TextEditingController();

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
                      icon: Icons.book,
                      hint: 'Module Code',
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      inputController: codecontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.book,
                      hint: 'Module Name',
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      inputController: namecontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.house,
                      hint: 'Institution Id',
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      inputController: institutioncontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.house,
                      hint: 'Faculty',
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      inputController: facultycontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.calendar_today,
                      hint: 'Year',
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      inputController: yearcontroller,
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
                    if (codecontroller.text.isEmpty) {
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
                    AdminServices.addModule(
                        codecontroller.text,
                        namecontroller.text,
                        institutioncontroller.text,
                        facultycontroller.text,
                        yearcontroller.text,
                        widget.global);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Success"),
                          content:
                              Text("Module " + namecontroller.text + " Added"),
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
                      : const Text("Add Module",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                ),
              ),
              const SizedBox(
                height: 200,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
