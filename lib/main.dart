import 'package:flutter/material.dart';
import 'package:tutor_me/src/tutee_page.dart';
// import 'package:tutor_me/src/tutor_page.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
// import 'src/app.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();
  runApp(const MaterialApp(home: TuteePage()));
}
