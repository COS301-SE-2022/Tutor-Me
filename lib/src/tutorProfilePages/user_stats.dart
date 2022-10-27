import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/theme/themes.dart';

class TuteeUserStats extends StatelessWidget {
  final int numTutees;

  const TuteeUserStats(
      {Key? key,
      required this.numTutees,})
      : super(key: key);

  

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color secondaryTextColor;

    if (provider.themeMode == ThemeMode.dark) {
      secondaryTextColor = colorGrey;
    } else {
      secondaryTextColor = colorOrange;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(
            text: '  Tutors', value: numTutees, color: secondaryTextColor),
       
      ],
    );
  }

 

  buildButton(
      {required String text, required int value, required Color color}) {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(vertical: 4),
      onPressed: () {},
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: colorBlueTeal,
            ),
          ),
        ],
      ),
    );
  }
}

class TutorUserStats extends StatelessWidget {
  final int rating;
  final int numTutees;

  const TutorUserStats(
      {Key? key,
      required this.rating,
      required this.numTutees,})
      : super(key: key);

  

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color secondaryTextColor;

    if (provider.themeMode == ThemeMode.dark) {
      secondaryTextColor = colorGrey;
    } else {
      secondaryTextColor = colorOrange;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(text: 'Rating', value: rating, color: secondaryTextColor),
        buildDivider(),
        buildButton(
            text: '  Tutees', value: numTutees, color: secondaryTextColor),
       
      ],
    );
  }

  Widget buildDivider() => Container(
        height: 33,
        color: Colors.black12,
        child: const VerticalDivider(),
        width: 2,
      );

  buildButton(
      {required String text, required int value, required Color color}) {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(vertical: 4),
      onPressed: () {},
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: colorBlueTeal,
            ),
          ),
        ],
      ),
    );
  }
}