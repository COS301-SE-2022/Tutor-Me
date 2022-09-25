// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../services/services/admin_services.dart';
import '../components.dart';

class AddBadge extends StatefulWidget {
  final Globals globals;
  const AddBadge({Key? key, required this.globals}) : super(key: key);

  @override
  AddBadgeState createState() => AddBadgeState();
}

class AddBadgeState extends State<AddBadge> {
  final FocusNode idFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  final TextEditingController imagecontroller = TextEditingController();
  final TextEditingController pointscontroller = TextEditingController();
  final TextEditingController pointstoachievecontroller =
      TextEditingController();

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
                      icon: Icons.perm_identity,
                      hint: 'Name of Badge',
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      inputController: namecontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.perm_identity,
                      hint: 'Description',
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      inputController: descriptioncontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.perm_identity,
                      hint: 'image',
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      inputController: imagecontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.perm_identity,
                      hint: 'Points',
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.done,
                      inputController: pointscontroller,
                    ),
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextInputField(
                      icon: Icons.perm_identity,
                      hint: 'Points To Achieve',
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.done,
                      inputController: pointstoachievecontroller,
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
                    if (namecontroller.text.isEmpty ||
                        descriptioncontroller.text.isEmpty ||
                        imagecontroller.text.isEmpty ||
                        pointscontroller.text.isEmpty ||
                        pointstoachievecontroller.text.isEmpty) {
                      errMsg += "Please fill in all fields \n";
                    }

                    int point = int.parse(pointscontroller.text);
                    int pointstoachieve =
                        int.parse(pointstoachievecontroller.text);

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
                    AdminServices.addBadge(
                        namecontroller.text,
                        descriptioncontroller.text,
                        imagecontroller.text,
                        point,
                        pointstoachieve,
                        widget.globals);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Success"),
                          content:
                              Text("Badge " + namecontroller.text + " Created"),
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
                      : const Text("Add Badge",
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
