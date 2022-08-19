import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';

class UserStats extends StatelessWidget {
  final String rating;
  final int numConnections;
  final int numTutees;

  const UserStats(
      {Key? key,
      required this.rating,
      required this.numTutees,
      required this.numConnections})
      : super(key: key);

  int convertRating() {
    List<String> rat = rating.split(',');
    return int.parse(rat[0]);
  }

  @override
  Widget build(BuildContext context) {
    int rating = convertRating();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(text: 'Rating', value: rating),
        buildDivider(),
        buildButton(text: '  Tutors', value: numTutees),
        buildDivider(),
        buildButton(text: '  Connections', value: numConnections),
      ],
    );
  }

  Widget buildDivider() => Container(
        height: 33,
        color: Colors.black12,
        child: const VerticalDivider(),
        width: 2,
      );

  buildButton({required String text, required int value}) {
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorTurqoise,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: colorOrange,
            ),
          ),
        ],
      ),
    );
  }
}
