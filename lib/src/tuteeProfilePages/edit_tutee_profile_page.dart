// import 'package:flutter/material.dart';
// import 'tutee_data.dart';
// import 'tutee_profile.dart';
// // import 'package:tutor_me/src/colorPalette.dart';

// class EditTuteeProfilePage extends StatefulWidget {
//   const EditTuteeProfilePage({Key? key}) : super(key: key);
//   @override
//   _EditTuteeProfilePageState createState() => _EditTuteeProfilePageState();
// }

// class _EditTuteeProfilePageState extends State<EditTuteeProfilePage> {
//   final unController = TextEditingController();
//   final bController = TextEditingController();
//   final lController = TextEditingController();
//   Tutee tutee = Tutee();
//   var genderItems = ['Male', 'Female', 'Other'];
//   // ignore: prefer_typing_uninitialized_variables
//   var username;
//   // ignore: prefer_typing_uninitialized_variables
//   var bio;
//   // ignore: prefer_typing_uninitialized_variables
//   var location;
//   // ignore: prefer_typing_uninitialized_variables
//   var age;
//   // ignore: prefer_typing_uninitialized_variables
//   var gender;

//   // ignore: prefer_typing_uninitialized_variables
//   var vGender;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             right: 0,
//             left: 0,
//             child: Container(
//               height: 170,
//               decoration: const BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("assets/Pictures/flower.jpg"),
//                       fit: BoxFit.fill)),
//               child: Container(
//                 padding: const EdgeInsets.only(top: 60, left: 140),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                         children: <TextSpan>[
//                           TextSpan(
//                               text: tutee.username,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 25,
//                                 shadows: <Shadow>[
//                                   Shadow(
//                                     offset: Offset(2.0, 2.0),
//                                     blurRadius: 6.0,
//                                     color: Color.fromARGB(255, 0, 0, 0),
//                                   ),
//                                 ],
//                               )),
//                         ],
//                       ),
//                     ),
//                     TextButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(
//                             Colors.deepOrangeAccent),
//                         foregroundColor:
//                             MaterialStateProperty.all<Color>(Colors.white),
//                       ),
//                       onPressed: null,
//                       child: const Text("Tutee"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 95,
//             child: Container(
//               height: 120,
//               width: MediaQuery.of(context).size.width - 220,
//               margin: const EdgeInsets.symmetric(
//                 horizontal: 12,
//               ),
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                     image: AssetImage("assets/Pictures/profilePic.jpg")),
//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 15,
//                     spreadRadius: 5,
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 50,
//             child: Container(
//               height: 60,
//               width: MediaQuery.of(context).size.width - 270,
//               margin: const EdgeInsets.symmetric(
//                 horizontal: 0,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: const Color.fromRGBO(214, 82, 7, 1),
//                 boxShadow: const [
//                   BoxShadow(
//                     blurRadius: 15,
//                     spreadRadius: 5,
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 230,
//             left: 30,
//             child: Container(
//               height: 30,
//               width: 255,
//               child: Column(children: [
//                 RichText(
//                     text: const TextSpan(
//                         text: "Editing profile details for Rose Tumil...",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                         )))
//               ]),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 260,
//             left: 25,
//             child: Container(
//               height: 320,
//               width: 240,
//               margin: const EdgeInsets.all(15.0),
//               // padding: const EdgeInsets.all(3.0),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.deepOrangeAccent),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Padding(padding: Padding. ),
//                   TextFormField(
//                     validator: (username) {
//                       if (username == null || username.isEmpty) {
//                         return 'Please enter valid text';
//                       }
//                       return null;
//                     },
//                     controller: unController,
//                     decoration: const InputDecoration(
//                         hintText: "Enter new username",
//                         labelText: "Click here to Change Username",
//                         contentPadding:
//                             EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
//                         labelStyle: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black,
//                         )),
//                   ),
//                   TextFormField(
//                     validator: (location) {
//                       if (location == null || location.isEmpty) {
//                         return 'Please enter valid text';
//                       }
//                       return null;
//                     },
//                     controller: lController,
//                     decoration: const InputDecoration(
//                         hintText: "Location here",
//                         labelText: "Click here to Change Location",
//                         contentPadding:
//                             EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
//                         labelStyle: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black,
//                         )),
//                   ),
//                   TextFormField(
//                     validator: (bio) {
//                       if (bio == null || bio.isEmpty) {
//                         return 'Please enter valid text';
//                       }
//                       return null;
//                     },
//                     controller: bController,
//                     decoration: const InputDecoration(
//                         hintText: "Bio here",
//                         labelText: "Click here to Change Bio",
//                         contentPadding:
//                             EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
//                         labelStyle: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black,
//                         )),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 0),
//                     width: 200,
//                     height: 150,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.black54),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Color.fromARGB(255, 54, 33, 27),
//                           blurRadius: 5,
//                           spreadRadius: 1,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                             "Select the following according to your Tutor preferences\n"),
//                         const Padding(
//                           padding: EdgeInsets.fromLTRB(40, 5, 10, 0),
//                         ),
//                         DropdownButton<String>(
//                           hint: const Text('GenderPreference'),
//                           value: vGender,
//                           items: genderItems.map(buildItems).toList(),
//                           onChanged: (String? newGender) {
//                             setState(() {
//                               vGender = newGender;
//                             });
//                           },
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 600,
//             left: 100,
//             child: SizedBox(
//               width: 120,
//               height: 30,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => TuteeProfilePage(
//                               username: unController.text,
//                               location: lController.text,
//                               bio: bController.text,
//                               gender: vGender)));
//                 },
//                 child: const Text("Save"),
//                 style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all(Colors.deepOrangeAccent),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   DropdownMenuItem<String> buildItems(String item) => DropdownMenuItem(
//       value: item,
//       child: Text(item,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)));
// }
