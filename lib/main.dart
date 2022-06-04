import 'package:flutter/material.dart';
import 'package:tutor_me/src/tuteeProfilePages/edit_tutee_profile_page.dart';
import 'package:tutor_me/src/tuteeProfilePages/tutee_profile.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

// import 'src/app.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();
  runApp( MaterialApp(home: TuteeProfilePage(bio: 'yytyyyo', gender: 'Female', location: 'mmmmmmn', username: 'kmmkmk', )));
}
