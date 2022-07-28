import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/theme/themes.dart';

import '../theme/themes.dart';
// import 'package:theme_example/provider/theme_provider.dart';
// import 'package:flutter/material.dart';/

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return  Row(
      children: [
        const Text("      Light Mode",style: TextStyle(fontSize: 15, color:  colorWhite ),),
        Switch.adaptive(
          value: themeProvider.isDarkMode,
          onChanged: (value)  {
            final provider = Provider.of<ThemeProvider>(context,listen: false);
            provider.toggleTheme(value);

          },
        ),
        // const Text("   Dark Mode",style: TextStyle(fontSize: 15, color: colorWhite) ),


      ],
    );
  }
}
