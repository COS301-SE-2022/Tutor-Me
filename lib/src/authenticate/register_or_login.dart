import 'package:flutter/material.dart';
import 'register_step1.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'login.dart';
import '../admin/admin_home.dart';

// ignore: must_be_immutable
class RegisterOrLogin extends StatefulWidget {
  const RegisterOrLogin({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterOrLoginState createState() => _RegisterOrLoginState();
}

class _RegisterOrLoginState extends State<RegisterOrLogin> {
  @override
  Widget build(BuildContext context) {
    final screenWidthSize = MediaQuery.of(context).size.width;
    final screenHeightSize = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(children: <Widget>[
      Positioned(
        top: 0,
        right: 0,
        left: 0,
        child: Container(
          height: screenHeightSize * 0.15,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Pictures/background.jpg"),
                  fit: BoxFit.fill)),
          child: Container(
            padding: EdgeInsets.only(
                top: screenHeightSize * 0.8, left: screenWidthSize * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    // text: "Rose Tumil",
                    // style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: "Tutor Me",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 6.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 100,
        right: 0,
        left: 0,
        child: Container(
          padding: EdgeInsets.only(
              top: screenHeightSize * 0.03, left: screenWidthSize * 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  // text: "Rose Tumil",
                  // style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: "Get yourself a personal \n tutor, or be a tutor",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: screenHeightSize * 0.03,
                          color: colorBlack,
                          shadows: const <Shadow>[
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 0.2,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AdminHome()));
                },
                child: const Text(
                  "        Admin",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: screenHeightSize * 0.3,
        right: screenWidthSize * 0.1,
        left: screenWidthSize * 0.1,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: ElevatedButton(
                onPressed: () {
                  goToRegister(context);
                },
                child: Image.asset("assets/Pictures/student.jpg"),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    primary: const Color(0xffD6521B)),
              ),
              height: screenHeightSize * 0.28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(214, 82, 7, 1),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: screenHeightSize * 0.06,
                  left: screenWidthSize * 0.15,
                  right: screenWidthSize * 0.15,
                  bottom: screenHeightSize * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "   Register as \nTutor or Tutee",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeightSize * 0.034,
                              shadows: const <Shadow>[
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 6.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: screenHeightSize * 0.65,
        right: screenWidthSize * 0.1,
        left: screenWidthSize * 0.1,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: ElevatedButton(
                onPressed: () {
                  goToLogin(context);
                },
                child: Image.asset("assets/Pictures/tutor.jpg"),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    primary: const Color(0xffD6521B)),
              ),
              height: screenHeightSize * 0.28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(214, 82, 7, 1),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: screenHeightSize * 0.06,
                  left: screenWidthSize * 0.15,
                  right: screenWidthSize * 0.15,
                  bottom: screenHeightSize * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "   Login as \nTutor or Tutee",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeightSize * 0.034,
                              shadows: const <Shadow>[
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 6.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]));
  }

  void goToRegister(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RegisterStep1()));
  }

  void goToLogin(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Login()));
  }
}
