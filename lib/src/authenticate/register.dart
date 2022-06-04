import 'package:flutter/material.dart';
import 'package:tutor_me/src/authenticate/login.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tutorProfilePages/settings_pofile_view.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black, Colors.transparent],
          ).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Pictures/register_login.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black54,
                      BlendMode.darken,
                    ))),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Column(children: [
            const Flexible(
              child: Center(
                child: Text(
                  'Tutor Me',
                  style: TextStyle(
                    color: colorWhite,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Flexible(
              child: Text(
                '',
                style: TextStyle(
                  color: colorWhite,
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const TextInputField(
              icon: Icons.person_outline,
              hint: 'Enter Full Name',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
            ),
            const TextInputField(
              icon: Icons.person_outline,
              hint: 'Enter Last Name',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
            ),
            const TextInputField(
              icon: Icons.calendar_month_outlined,
              hint: 'Enter DOB (DD/MM/YYYY)',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
            ),
            const TextInputField(
              icon: Icons.female_outlined,
              hint: 'Gender',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
            ),
            const TextInputField(
              icon: Icons.school_outlined,
              hint: 'Enter Institution Name',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
            ),
            const TextInputField(
              icon: Icons.email_outlined,
              hint: 'Enter Your Email',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
            ),
            //second input
            const PasswordInput(
              icon: Icons.lock_outline_rounded,
              hint: 'Password',
              inputAction: TextInputAction.done,
              inputType: TextInputType.text,
            ),

            const PasswordInput(
              icon: Icons.password_outlined,
              hint: 'Confirm Password',
              inputAction: TextInputAction.done,
              inputType: TextInputType.text,
            ),

            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Register(),
                ),
              ),
              child: OrangeButton(
                btnName: "Register",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TutorSettingsProfileView()));
                },
              ),
            ),
          ]),
        )
      ],
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
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;

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

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key? key,
    required this.icon,
    required this.hint,
    required this.inputType,
    required this.inputAction,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;

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
