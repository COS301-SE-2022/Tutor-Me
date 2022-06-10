import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({
    Key? key,
    required this.btnName,
    required this.onPressed,
    required this.btnIcon,
  }) : super(key: key);
  final String btnName;
  final IconData btnIcon;
  final Function() onPressed;
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
        onPressed: onPressed,
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

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key? key,
    required this.icon,
    required this.hint,
    required this.inputType,
    required this.inputAction,
    required this.inputController,
    // required this.inputFocus,
    // required this.inputValue,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  // final FocusNode inputFocus;
  final TextEditingController inputController;
  // final Function(String v) inputValue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: size.height * 0.07,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[500]!.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorOrange,
            width: 1,
          ),
        ),
        child: Center(
          child: TextField(
            // onChanged: inputValue,
            // onEditingComplete: () {
            //   FocusScope.of(context).requestFocus(inputFocus);
            // },
            // focusNode: inputFocus,
            controller: inputController,
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white)),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            keyboardType: inputType,
            textInputAction: inputAction,
          ),
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.inputType,
    required this.inputAction,
    required this.inputController,
    required this.inputFocus,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final FocusNode inputFocus;
  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[500]!.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorOrange,
            width: 1,
          ),
        ),
        child: Center(
          child: TextField(
            focusNode: inputFocus,
            controller: inputController,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(
                  icon,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white),
            ),
            obscureText: true,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            keyboardType: inputType,
            textInputAction: inputAction,
          ),
        ),
      ),
    );
  }
}

class SmallTagButton extends StatelessWidget {
  const SmallTagButton({
    Key? key,
    required this.btnName,
    required this.backColor,
    required Function() onPressed,
  }) : super(key: key);
  final String btnName;

  final Color backColor;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.05,
      width: size.width * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backColor,
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          btnName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class OrangeButton extends StatelessWidget {
  const OrangeButton({
    Key? key,
    required this.btnName,
    required this.onPressed,
  }) : super(key: key);
  final String btnName;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.06,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorOrange,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          btnName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
