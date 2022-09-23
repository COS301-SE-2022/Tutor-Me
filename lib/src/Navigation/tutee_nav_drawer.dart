import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/services/services/user_services.dart';
import 'package:tutor_me/src/Navigation/about.dart';
import 'package:tutor_me/src/Navigation/switch_change_theme.dart';
import 'package:tutor_me/src/authenticate/login.dart';
import 'package:tutor_me/src/theme/themes.dart';
import '../tuteeProfilePages/tutee_profile.dart';
import 'package:tutor_me/src/colorpallete.dart';

import 'contact_us.dart';

// ignore: must_be_immutable
class TuteeNavigationDrawerWidget extends StatefulWidget {
  Globals globals;

  TuteeNavigationDrawerWidget({
    Key? key,
    required this.globals,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TuteeNavigationDrawerState();
  }
}

class TuteeNavigationDrawerState extends State<TuteeNavigationDrawerWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  late Uint8List tuteeImage;
  bool doesUserImageExist = false;
  bool isImageLoading = true;

  getTuteeProfileImage() async {
    try {
      final image = await UserServices.getTuteeProfileImage(
          widget.globals.getUser.getId, widget.globals);

      setState(() {
        tuteeImage = image;
        doesUserImageExist = true;
        isImageLoading = false;
      });
    } catch (e) {
      setState(() {
        isImageLoading = false;
        tuteeImage = Uint8List(128);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTuteeProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    // final text = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    Color drawerColor;
    if (provider.themeMode == ThemeMode.dark) {
      drawerColor = colorDarkGrey;
    } else {
      drawerColor = colorBlueTeal.withOpacity(0.6);
    }

    return Drawer(
      child: Material(
          color: drawerColor,
          child: ListView(
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                buildNavHeader(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                // const Divider(
                //   color: colorWhite,
                // ),
                buildMenu(
                    text: 'My Stats report',
                    icon: Icons.info_outline,
                    onClicked: () => selected(context, 3)),
                buildMenu(
                  text: 'My Account',
                  icon: Icons.account_circle_outlined,
                  onClicked: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           TuteeProfileEdit(user: widget.user),
                    //     ));
                  },
                ),
                buildMenu(
                    text: 'Settings',
                    icon: Icons.settings,
                    onClicked: () => selected(context, 1)),
                const ChangeThemeButtonWidget(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06),
                  child: Text(
                    "Help?",
                    style: TextStyle(
                      color: colorDarkGrey.withOpacity(0.3),
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),

                buildMenu(
                    text: 'About ',
                    icon: Icons.info_outline,
                    onClicked: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const About(),
                              ))
                        }),
                buildMenu(
                    text: 'About Us & Contact Us ',
                    icon: Icons.contact_support_outlined,
                    onClicked: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactUs(),
                              ))
                        }),
                buildMenu(
                    text: 'Terms and Conditions',
                    icon: Icons.description_outlined,
                    onClicked: () => selected(context, 4)),

                buildMenuNoArrow(
                  text: 'Logout',
                  icon: Icons.logout,
                  onClicked: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                ),
              ])),
    );
  }

  Widget buildNavHeader(BuildContext context) {
    String name = widget.globals.getUser.getName;
    String fullName = name + ' ' + widget.globals.getUser.getLastName;
    return InkWell(
      onTap: isImageLoading
          ? () {}
          : () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TuteeProfilePage(
                        globals: widget.globals,
                        image: tuteeImage,
                        imageExists: doesUserImageExist),
                  ));

              setState(() {
                widget.globals.setUser = result.user;
              });

              getTuteeProfileImage();
            },
      child: Column(
        children: [
          Container(
            padding: padding.add(EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.08)),
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('assets/Pictures/profileBackground.jpg'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: Row(children: <Widget>[
              CircleAvatar(
                backgroundColor: colorOrange,
                radius: MediaQuery.of(context).size.width * 0.08,
                child: isImageLoading
                    ? const CircularProgressIndicator.adaptive()
                    : doesUserImageExist
                        ? ClipOval(
                            child: Image.memory(
                              tuteeImage,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.width * 0.2,
                            ),
                          )
                        : ClipOval(
                            child: Image.asset(
                            "assets/Pictures/penguin.png",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.253,
                            height: MediaQuery.of(context).size.width * 0.253,
                          )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      fullName,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          color: colorWhite),
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.01),
                    Text(
                      widget.globals.getUser.getEmail,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: colorWhite),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ]),
          ),
          Divider(
            color: colorLightGrey.withOpacity(0.5),
            thickness: 1,
            endIndent: MediaQuery.of(context).size.width * 0.08,
            indent: MediaQuery.of(context).size.width * 0.08,
          ),
        ],
      ),
    );
  }

  Widget buildMenu({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    return ListTile(
      contentPadding: padding,
      leading: Icon(
        icon,
        color: const Color(0xffFFFFFF),
      ),
      title: Text(text, style: const TextStyle(color: Color(0xffFFFFFF))),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: const Color(0xffFFFFFF),
        size: MediaQuery.of(context).size.width * 0.04,
      ),
      onTap: onClicked,
    );
  }

  Widget buildMenuNoArrow({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    return ListTile(
      contentPadding: padding,
      leading: Icon(
        icon,
        color: const Color(0xffFFFFFF),
      ),
      title: Text(text, style: const TextStyle(color: Color(0xffFFFFFF))),
      onTap: onClicked,
    );
  }

  void selected(BuildContext context, int index) {
    Navigator.pop(context);
    if (index == 0) {}
    // else if(index == 1) {
    //   Navigator.of(context).push(MaterialPageRoute(builder: builder))
    // }
  }
}
