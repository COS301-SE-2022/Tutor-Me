import 'package:flutter/material.dart';
// import 'package:tutor_me/src/colorPalette.dart';

class EditTuteeProfilePage extends StatefulWidget {
  @override
  _EditTuteeProfilePageState createState() => _EditTuteeProfilePageState();
}

class _EditTuteeProfilePageState extends State<EditTuteeProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 170,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Pictures/flower.jpg"),
                      fit: BoxFit.fill)),
              child: Container(
                padding: const EdgeInsets.only(top: 60, left: 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        // text: "Rose Tumil",
                        // style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Rose Tamil',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
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
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepOrangeAccent),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: null,
                      child: const Text("Tutee"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 95,
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width - 220,
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                    image: AssetImage("assets/Pictures/profilePic.jpg")),
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
            top: 50,
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width - 270,
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromRGBO(214, 82, 7, 1),
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
            top: 230,
            left: 30,
            child: Container(
              height: 30,
              width: 255,
              child: Column(children: [
                RichText(
                    text: const TextSpan(
                        text: "Editing profile details for Rose Tumil...",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        )))
              ]),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black54,
              ),
            ),
          ),
          Positioned(
            top: 260,
            left: 25,
            child: Container(
              height: 320,
              width: 240,
              margin: const EdgeInsets.all(15.0),
              // padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepOrangeAccent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(padding: Padding. ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "Enter new username",
                        labelText: "Click here to Change Username",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        )),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "Location here",
                        labelText: "Click here to Change Location",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        )),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "Bio here",
                        labelText: "Click here to Change Bio",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 0),
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black54),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 54, 33, 27),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                            "Select the following according to your Tutor preferences\n"),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(40, 5, 10, 0),
                        ),
                        // Padding(padding: Padding. ),
                        DropdownButton<String>(
                          hint: const Text("Gender"),
                          items: <String>['Female', 'Male', 'Other']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        DropdownButton<String>(
                          hint: const Text("Age"),
                          items: <String>[
                            '16-19',
                            '20-23',
                            '24-28',
                            '29-35',
                            '36-40'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {},
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 600,
            left: 100,
            child: SizedBox(
              width: 120,
              height: 30,
              child: ElevatedButton(
                onPressed: null,
                child: const Text("Save"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.deepOrangeAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
