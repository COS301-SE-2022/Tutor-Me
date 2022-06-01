import 'package:flutter/material.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
// import 'src/app.dart';
import 'src/tutorProfilePages/settings_pofile_view.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();
  runApp(const MaterialApp(home: TutorSettingsProfileView()));
}
