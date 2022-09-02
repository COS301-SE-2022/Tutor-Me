import 'package:flutter/material.dart';
// import 'package:tutor_me/src/authenticate/register_or_login.dart';
// import 'src/settings/settings_controller.dart';
// import 'src/settings/settings_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:tutor_me/src/landingPages/landing_page.dart'; 

import 'package:tutor_me/src/theme/themes.dart';

//import 'src/authenticate/register_or_login.dart';
// import 'src/tutorAndTuteeCollaboration/tutorGroups/tutor_remove_participants.dart';

// import 'src/app.dart';

void main() async {
//   // await TuteeServices().sendRequest('6b85813b-7c2d-45da-ab35-0b18d47b1327', '887d2493-c136-4ec1-800b-f2c68e762367');
//   // await TutorServices().acceptRequest('6666EB8B-2AE2-4872-9595-9830C8912243');

//   // final settingsController = SettingsController(SettingsService());
   await dotenv.load(fileName: ".env");

//   // await settingsController.loadSettings();
runApp(const MyApp());
//   runApp( Chna(
//     create: (context) =>,
//     builder:(context,_){
//     return MaterialApp(home: const RegisterOrLogin(),
//     themeMode: ThemeMode.system,
//     theme: Themes.lightTheme,
//     darkTheme: Themes.darkTheme,  ),
// }));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    
    builder: (context, _) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
      return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme, 
      home: const LandingPage(),
      );
    });
}
