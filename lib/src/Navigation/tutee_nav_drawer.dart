import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/models/users.dart';
import 'package:tutor_me/src/Navigation/switch_change_theme.dart';
import 'package:tutor_me/src/theme/themes.dart';
import '../../services/services/tutee_services.dart';
import '../tuteeProfilePages/tutee_profile.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/authenticate/register_or_login.dart';

// ignore: must_be_immutable
class TuteeNavigationDrawerWidget extends StatefulWidget {
  Users user;

  TuteeNavigationDrawerWidget({
    Key? key,
    required this.user,
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
      final image = await TuteeServices.getTuteeProfileImage(widget.user.getId);

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
      drawerColor = colorOrange;
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
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                buildMenu(
                  text: 'Logout',
                  icon: Icons.logout,
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterOrLogin()),
                    );
                  },
                ),
              ])),
    );
  }

  Widget buildNavHeader(BuildContext context) {
    String name = widget.user.getName;
    String fullName = name + ' ' + widget.user.getLastName;
    return InkWell(
      onTap: isImageLoading
          ? () {}
          : () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TuteeProfilePage(
                        user: widget.user,
                        image: tuteeImage,
                        imageExists: doesUserImageExist),
                  ));

              setState(() {
                widget.user = result.user;
              });

              getTuteeProfileImage();
            },
      child: Container(
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
            backgroundColor: colorTurqoise,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                fullName,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.055,
                    color: colorWhite),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.01),
              Text(
                widget.user.getEmail,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    color: colorWhite),
              )
            ],
          )
        ]),
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
