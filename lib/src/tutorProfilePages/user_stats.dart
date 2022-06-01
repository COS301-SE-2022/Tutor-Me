import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';

class UserStats extends StatelessWidget {
  const UserStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(text: 'Rating', value: 4),
          buildDivider(),
          buildButton(text: '  Tutees', value: 2),
          buildDivider(),
          buildButton(text: '  Connections', value: 39),
        ],
      );

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
