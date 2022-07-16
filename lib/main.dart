import 'package:flutter/material.dart';
// import 'package:tutor_me/src/authenticate/register_or_login.dart';
// import 'src/settings/settings_controller.dart';
// import 'src/settings/settings_service.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/tutorAndTuteeCollaboration/tuteeGroups/tuteeGroupSettings.dart';
import 'src/tutorAndTuteeCollaboration/tuteeGroups/tuteeGroups.dart';

// import 'src/app.dart';

void main() async {
  // await TuteeServices().sendRequest('6b85813b-7c2d-45da-ab35-0b18d47b1327', '887d2493-c136-4ec1-800b-f2c68e762367');
  // await TutorServices().acceptRequest('6666EB8B-2AE2-4872-9595-9830C8912243');

  // final settingsController = SettingsController(SettingsService());
  // await dotenv.load(fileName: ".env");

  // await settingsController.loadSettings();
  runApp(MaterialApp(home: TuteeGroupsSettings()));
}
