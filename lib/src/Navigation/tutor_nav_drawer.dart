import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../../services/services/tutor_services.dart';
import '../tutorProfilePages/settings_pofile_view.dart';
import 'package:tutor_me/src/authenticate/register_or_login.dart';

// ignore: must_be_immutable
class TutorNavigationDrawerWidget extends StatefulWidget {
  Tutors user;

  TutorNavigationDrawerWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TutorNavigationDrawerState();
  }
}

class TutorNavigationDrawerState extends State<TutorNavigationDrawerWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  late Uint8List tutorImage;
  bool doesUserImageExist = false;

  getTutorProfileImage() async {
    try {
      final image = await TutorServices.getTutorProfileImage(widget.user.getId);

      setState(() {
        tutorImage = image;
        doesUserImageExist = true;
      });
    } catch (e) {
      setState(() {
        tutorImage = Uint8List(128);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getTutorProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
          color: const Color(0xFFD6521B),
          child: ListView(
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                buildNavHeader(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                buildMenu(
                  text: 'My Account',
                  icon: Icons.account_circle_outlined,
                  onClicked: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           TutorProfileEdit(user: widget.user),
                    //     ));
                  },
                ),
                buildMenu(
                    text: 'Settings',
                    icon: Icons.settings,
                    onClicked: () => selected(context, 1)),
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
      onTap: () async {
        final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorSettingsProfileView(
                  user: widget.user,
                  image: tutorImage,
                  imageExists: doesUserImageExist),
            ));
        Navigator.pop(context);
        setState(() {
          widget.user = result.user;
        });

        getTutorProfileImage();
      },
      child: Container(
        padding: padding.add(EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.05)),
        child: Row(children: <Widget>[
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.08,
            child: doesUserImageExist
                ? ClipOval(
                    child: Image.memory(
                      tutorImage,
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
                    fontSize: MediaQuery.of(context).size.width * 0.055,
                    color: colorWhite),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.01),
              Text(
                widget.user.getEmail,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
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
