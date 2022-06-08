import 'package:flutter/material.dart';
import 'package:tutor_me/services/services/tutor_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
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

    // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

            TextInputField(
              icon: Icons.person_outline,
              hint: 'Enter Full Name',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              inputController: firstNameController,
              inputFocus: firstNameFocusNode,
            ),
            TextInputField(
              icon: Icons.person_outline,
              hint: 'Enter Last Name',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              inputController: lastNameController,
              inputFocus: lastNameFocusNode,
            ),
            TextInputField(
              icon: Icons.calendar_month_outlined,
              hint: 'Enter DOB (DD/MM/YYYY)',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              inputController: dobController,
              inputFocus: dobFocusNode,
            ),
            TextInputField(
              icon: Icons.female_outlined,
              hint: 'Gender',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              inputController: genderController,
              inputFocus: genderFocusNode,
            ),
            TextInputField(
              icon: Icons.school_outlined,
              hint: 'Course',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              inputController: courseController,
              inputFocus: courseFocusNode,
            ),
            TextInputField(
              icon: Icons.school_outlined,
              hint: 'Enter Institution Name',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              inputController: institutionController,
              inputFocus: institutionFocusNode,
            ),
            TextInputField(
              icon: Icons.email_outlined,
              hint: 'Enter Your Email',
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              inputController: emailController,
              inputFocus: emailFocusNode,
            ),
            PasswordInput(
              icon: Icons.lock_outline_rounded,
              hint: 'Password',
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,
              inputController: passwordController,
              inputFocus: passwordFocusNode,
            ),
            PasswordInput(
              icon: Icons.password_outlined,
              hint: 'Confirm Password',
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,
              inputController: confirmPasswordController,
              inputFocus: confirmPasswordFocusNode,
            ),
            // const SizedBox(
            //   height: 25,
            // ),
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: colorOrange,
              ),
              child: TextButton(
                onPressed: () {
                  TutorServices.registerTutor(
                    firstNameController.text,
                    lastNameController.text,
                    dobController.text,
                    genderController.text,
                    institutionController.text,
                    emailController.text,
                    passwordController.text,
                    // courseController.text,
                    confirmPasswordController.text,
                  );
                },
                child: const Text("Register",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
            ),
          ]),
        )
      ],
    );
  }
}
