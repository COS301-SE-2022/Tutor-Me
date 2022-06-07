import 'package:flutter/material.dart';
import 'package:tutor_me/src/authenticate/login.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/tutorProfilePages/settings_pofile_view.dart';

import '../components.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode emailFocusNode = FocusNode();
    final FocusNode passwordFocusNode = FocusNode();
    final FocusNode confirmPasswordFocusNode = FocusNode();
    final FocusNode firstNameFocusNode = FocusNode();
    final FocusNode lastNameFocusNode = FocusNode();
    final FocusNode dobFocusNode = FocusNode();
    final FocusNode genderFocusNode = FocusNode();
    final FocusNode institutionFocusNode = FocusNode();
    final FocusNode courseFocusNode = FocusNode();

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController dobController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    final TextEditingController institutionController = TextEditingController();
    final TextEditingController courseController = TextEditingController();

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
            TextInputField(
              icon: Icons.person_outline,
              hint: 'Enter Full Name',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
              inputController: firstNameController,
              inputFocus: firstNameFocusNode,
            ),
            TextInputField(
              icon: Icons.person_outline,
              hint: 'Enter Last Name',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
              inputController: lastNameController,
              inputFocus: lastNameFocusNode,
            ),
            TextInputField(
              icon: Icons.calendar_month_outlined,
              hint: 'Enter DOB (DD/MM/YYYY)',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
              inputController: dobController,
              inputFocus: dobFocusNode,
            ),
            TextInputField(
              icon: Icons.female_outlined,
              hint: 'Gender',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
              inputController: genderController,
              inputFocus: genderFocusNode,
            ),
            TextInputField(
              icon: Icons.school_outlined,
              hint: 'Enter Institution Name',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
              inputController: institutionController,
              inputFocus: institutionFocusNode,
            ),
            TextInputField(
              icon: Icons.email_outlined,
              hint: 'Enter Your Email',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
              inputController: emailController,
              inputFocus: emailFocusNode,
            ),
            //second input
            PasswordInput(
              icon: Icons.lock_outline_rounded,
              hint: 'Password',
              inputAction: TextInputAction.done,
              inputType: TextInputType.text,
              inputValue: (value) {},
            ),

            PasswordInput(
              icon: Icons.password_outlined,
              hint: 'Confirm Password',
              inputAction: TextInputAction.done,
              inputType: TextInputType.text,
              inputValue: (value) {},
            ),

            OrangeButton(
              btnName: "Register",
              onPressed: () {},
            ),
          ]),
        )
      ],
    );
  }
}
