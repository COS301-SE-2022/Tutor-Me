import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:tutor_me/src/authenticate/register_or_login.dart';
// import 'src/settings/settings_controller.dart';
// import 'src/settings/settings_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/services/models/globals.dart';
import 'package:tutor_me/src/authenticate/login.dart';
import 'package:tutor_me/src/landingPages/landing_page.dart';
// import 'package:tutor_me/src/pages/recorded_videos.dart';
import 'package:tutor_me/src/theme/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/src/tutor_page.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

// ignore: must_be_immutable
class MyAppState extends State<MyApp> {
  SharedPreferences? preferences;

  initPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        initPreferences();
      });
    });
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
        if (preferences != null) {
          final isFirstTime = preferences!.getBool('isFirstTime');
          if (isFirstTime == null) {
            return MaterialApp(
              themeMode: themeProvider.themeMode,
              debugShowCheckedModeBanner: false,
              theme: Themes.lightTheme,
              darkTheme: Themes.darkTheme,
              home: const LandingPage(),
            );
          } else {
            final globalsJson = preferences!.getString('globals');
            if (globalsJson == null) {
              return MaterialApp(
                themeMode: themeProvider.themeMode,
                debugShowCheckedModeBanner: false,
                theme: Themes.lightTheme,
                darkTheme: Themes.darkTheme,
                home: const Login(),
              );
            } else {
              final globals = Globals.fromJson(jsonDecode(globalsJson));
              globals.setHeader = {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                'Authorization': globals.getToken,
              };
              return MaterialApp(
                themeMode: themeProvider.themeMode,
                debugShowCheckedModeBanner: false,
                theme: Themes.lightTheme,
                darkTheme: Themes.darkTheme,
                home: TutorPage(globals: globals),
              );
            }
          }
        }
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      });
}
