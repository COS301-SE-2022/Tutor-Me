import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutors.dart';
import 'package:tutor_me/src/colorpallete.dart';
import '../tutorProfilePages/settings_pofile_view.dart';

class TutorNavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  final Tutors user;

  const TutorNavigationDrawerWidget({Key? key, required this.user})
      : super(key: key);
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
                    onClicked: () => selected(context, 0)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                buildMenu(
                    text: 'Settings',
                    icon: Icons.settings,
                    onClicked: () => selected(context, 1)),
              ])),
    );
  }

  Widget buildNavHeader(BuildContext context) {
    String name = user.getName;
    String fullName = name + ' ' + user.getLastName;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorSettingsProfileView(user: user),
            ));
      },
      child: Container(
        padding: padding.add(EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.05)),
        child: Row(children: <Widget>[
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.08,
            backgroundImage: const AssetImage('assets/Pictures/penguin.png'),
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
                user.getEmail,
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
