import 'package:flutter/material.dart';
import 'package:tutor_me/src/components.dart';

class TestButton extends StatelessWidget {
  const TestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: UploadButton(
        btnIcon: Icons.video_call,
        btnName: "   Test Video call components",
        onPressed: () {},
      )),
    );
  }
}
