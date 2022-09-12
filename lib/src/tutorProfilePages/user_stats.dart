import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/theme/themes.dart';

class UserStats extends StatelessWidget {
  final int rating;
  final int numConnections;
  final int numTutees;

  const UserStats(
      {Key? key,
      required this.rating,
      required this.numTutees,
      required this.numConnections})
      : super(key: key);

  int convertRating() {
    return rating;
  }

  @override
  Widget build(BuildContext context) {
    int rating = convertRating();

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
            text: '  Tutors', value: numTutees, color: secondaryTextColor),
        buildDivider(),
        buildButton(
            text: '  Connections',
            value: numConnections,
            color: secondaryTextColor),
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
