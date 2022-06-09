import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutors.dart';
import '../tuteeProfilePages/tutee_data.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                const SizedBox(height: 50),
                buildMenu(
                    text: 'Profile',
                    icon: Icons.account_circle_outlined,
                    onClicked: () => selected(context, 0)),
                const SizedBox(height: 50),
                buildMenu(
                    text: 'Settings',
                    icon: Icons.settings,
                    onClicked: () => selected(context, 1)),
              ])),
    );
  }

  Widget buildMenu({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xffFFFFFF),
      ),
      title: Text(text, style: const TextStyle(color: Color(0xffFFFFFF))),
      onTap: onClicked,
    );
  }

  void selected(BuildContext context, int index) {
    Tutee tutee = Tutee();
    tutee.setAttributes(
        "I am a hardworker,I absolutely love the field I am in.I'm constantly looking for ways to get things done",
        'Evander, Secunda\n',
        'Rose Tamil\n',
        '21 years old\n',
        'Female\n');
    Navigator.pop(context);
    if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorSettingsProfileView(user: user),
          ));
    }
    // else if(index == 1) {
    //   Navigator.of(context).push(MaterialPageRoute(builder: builder))
    // }
  }
}
