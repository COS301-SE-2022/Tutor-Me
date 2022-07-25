import 'package:flutter/material.dart';

Widget chatAppbarWidget(Size size, BuildContext context, String groupName) {
  return Container(
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6),
    width: size.width,
    height: 100,
    color: Colors.orange[900],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'COS 301',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ],
    ),
  );
}
