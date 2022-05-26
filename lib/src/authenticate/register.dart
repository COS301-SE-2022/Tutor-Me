

import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 350,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/Pictures/background.jpg"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(350),
                ),
              ),
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
                              text: "Register",
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
            left: 30,
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width - 60,
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // ignore: prefer_const_constructors
                color: Color.fromARGB(255, 255, 255, 255),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 15,
                    spreadRadius: 5,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 80,
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width - 250,
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // ignore: prefer_const_constructors
                color: Color.fromARGB(255, 200, 97, 0),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 0,
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 165,
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width - 250,
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
              ),
     
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepOrangeAccent),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: null,
                child: const Text("Tutee"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
