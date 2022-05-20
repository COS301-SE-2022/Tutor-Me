import 'package:flutter/material.dart';
// import 'package:tutor_me/src/colorPalette.dart';

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
    return Scaffold(
        body: Stack(children: <Widget>[
      Positioned(
        top: 0,
        right: 0,
        left: 0,
        child: Container(
          height: 80,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Pictures/background.jpg"),
                  fit: BoxFit.fill)),
          child: Container(
            padding: const EdgeInsets.only(top: 30, left: 100),
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
          padding: const EdgeInsets.only(top: 20, left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  // text: "Rose Tumil",
                  // style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: "Get yourself a personal \n tutor, or be a tutor",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 19,
                          color: Color(0x00000000),
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 0.2,
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
      Positioned(
        top: 190,
        right: 30,
        left: 30,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: ElevatedButton(
                onPressed: () {},
                child: Image.asset("assets/Pictures/student.jpg"),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    primary: const Color(0xffD6521B)),
              ),
              height: 180,
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
              padding: const EdgeInsets.only(
                  top: 60, left: 50, right: 50, bottom: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "   Register as \nTutor or Tutee",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
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
          ],
        ),
      ),
      Positioned(
        top: 420,
        right: 30,
        left: 30,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: ElevatedButton(
                onPressed: () {},
                child: Image.asset("assets/Pictures/tutor.jpg"),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    primary: const Color(0xffD6521B)),
              ),
              height: 180,
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
              padding: const EdgeInsets.only(
                  top: 60, left: 50, right: 50, bottom: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "   Login as \nTutor or Tutee",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
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
          ],
        ),
      ),
    ]));
  }
}
