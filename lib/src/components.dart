import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({
    Key? key,
    required this.btnName,
    required Function() onPressed,
    required this.btnIcon,
  }) : super(key: key);
  final String btnName;
  final IconData btnIcon;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.065,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorTurqoise,
      ),
      child: TextButton(
        onPressed: () {},
        child: Row(
          children: [
            Icon(
              btnIcon,
              color: colorWhite,
            ),
            Text(
              btnName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DowloadLinkButton extends StatelessWidget {
  const DowloadLinkButton({
    Key? key,
    required this.btnName,
    required Function() onPressed,
  }) : super(key: key);
  final String btnName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.065,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: TextButton(
        onPressed: () {},
        child: Row(
          children: [
            const Icon(
              Icons.download,
              color: colorOrange,
            ),
            Text(
              btnName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
