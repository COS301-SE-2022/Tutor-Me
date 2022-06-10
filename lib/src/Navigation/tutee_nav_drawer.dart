import 'package:flutter/material.dart';
import 'package:tutor_me/services/models/tutees.dart';
import '../tuteeProfilePages/tutee_profile.dart';

class TuteeNavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  final Tutees user;

  const TuteeNavigationDrawerWidget({Key? key, required this.user}) : super(key: key);
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
    
   Navigator.of(context).pop();
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TuteeProfilePage(
            user: user,),
      ));
    }
    // else if(index == 1) {
    //   Navigator.of(context).push(MaterialPageRoute(builder: builder))
    // }
  }
}
