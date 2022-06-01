import 'package:flutter/material.dart';
import 'package:tutor_me/src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
// import 'src/app.dart';
import 'src/authenticate/register_or_login.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();
  runApp(const MaterialApp(home: MyApp()));
}
