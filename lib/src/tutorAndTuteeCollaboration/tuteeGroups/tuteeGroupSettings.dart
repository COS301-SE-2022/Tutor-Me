// import 'dart:io';
// // import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:tutor_me/src/colorpallete.dart';
// import 'package:tutor_me/src/components.dart';
// import 'package:image_picker/image_picker.dart';

// class TuteeGroupsSettings extends StatefulWidget {
//   // final Tutees user;
//   const TuteeGroupsSettings({Key? key}) : super(key: key);

//   @override
//   _TuteeGroupsSettingsState createState() => _TuteeGroupsSettingsState();
// }

// class _TuteeGroupsSettingsState extends State<TuteeGroupsSettings> {
//   File? image;

//   Future pickImage(ImageSource source) async {
//     final image = await ImagePicker().pickImage(source: source);
//     if (image == null) {
//       return;
//     }

//     final imageTempPath = File(image.path);
//     setState(() => this.image = imageTempPath);
//   }

//   ImageProvider buildImage() {
//     if (image != null) {
//       return fileImage();
//     }
//     return const AssetImage('assets/Pictures/artificialintelligence.jpg');
//   }

//   FileImage fileImage() {
//     return FileImage(image!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidthSize = MediaQuery.of(context).size.width;
//     final screenHeightSize = MediaQuery.of(context).size.height;

//     return Scaffold(
//         appBar: AppBar(
//           // backgroundColor: const Color(0xffD6521B),
//           centerTitle: true,
//           title: const Text('COS341 - Group Settings'),
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//                 // borderRadius:
//                 //     BorderRadius.vertical(bottom: Radius.circular(60)),
//                 gradient: LinearGradient(
//                     colors: <Color>[Colors.orange, Colors.red],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter)),
//           ),
//         ),
//         body: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             topDesign(),
//             buildBody(),
//           ],
//         ));
//   }

//   Widget buildBody() {
//     final screenWidthSize = MediaQuery.of(context).size.width;
//     final screenHeightSize = MediaQuery.of(context).size.height;
//     // FilePickerResult? filePickerResult;
//     // String? fileName;
//     // PlatformFile? file;
//     // bool isUploading = false;
//     // File? fileToUpload;

//     return Column(
//       children: [
//         SizedBox(height: screenHeightSize * 0.3),
//         OrangeButton(btnName: "Save", onPressed: () {}),
//         SizedBox(height: screenHeightSize * 0.03),
//         GestureDetector(
//           // onTap: () {
//           //   Navigator.of(context).push(MaterialPageRoute(
//           //       builder: (context) => const ForgotPassword()));
//           // },
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.exit_to_app,
//                 color: colorRed,
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.02,
//               ),
//               const Text(
//                 "Leave Group",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.normal,
//                   color: colorRed,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: screenHeightSize * 0.03),
//         GestureDetector(
//           // onTap: () {
//           //   Navigator.of(context).push(MaterialPageRoute(
//           //       builder: (context) => const ForgotPassword()));
//           // },
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const Icon(
//                 Icons.thumb_down,
//                 color: colorRed,
//                 size: 18,
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.02,
//               ),
//               const Text(
//                 "Report Group",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.normal,
//                   color: colorRed,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget topDesign() {
//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.center,
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.3,
//           margin: const EdgeInsets.only(bottom: 40),
//         ),
//         Positioned(
//           left: MediaQuery.of(context).size.height * 0.018,
//           top: MediaQuery.of(context).size.height * 0.03,
//           child: buildProfileImage(),
//         ),
//         Positioned(
//           top: MediaQuery.of(context).size.height * 0.18,
//           left: MediaQuery.of(context).size.height * 0.17,
//           child: buildEditImageIcon(),
//         ),
//       ],
//     );
//   }

//   Widget buildCoverImage() => Container(
//         color: Colors.grey,
//         child: const Image(
//           image: AssetImage('assets/Pictures/tuteeCover.jpg'),
//           width: double.infinity,
//           height: 150,
//           fit: BoxFit.cover,
//         ),
//       );

//   Widget buildProfileImage() => Container(
//         height: MediaQuery.of(context).size.height * 0.2,
//         width: MediaQuery.of(context).size.width * 0.43,
//         decoration: const BoxDecoration(
//             color: colorTurqoise,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(15),
//                 topRight: Radius.circular(15),
//                 bottomLeft: Radius.circular(15),
//                 bottomRight: Radius.circular(15))),
//         child: ClipRRect(
//             child: Image(
//           image: buildImage(),
//         )),
//       );

//   Widget buildEditImageIcon() => ElevatedButton(
//         style: ElevatedButton.styleFrom(
//             primary: colorOrange,
//             shape: const CircleBorder(),
//             padding: const EdgeInsets.all(8)),
//         child: const Icon(
//           Icons.add_a_photo_outlined,
//           color: Colors.white,
//         ),
//         onPressed: () {
//           showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                     actions: [
//                       IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: const Icon(Icons.arrow_back)),
//                       TextButton(
//                           onPressed: () => pickImage(ImageSource.gallery),
//                           child: const Text('Open Gallery')),
//                       TextButton(
//                           onPressed: () => pickImage(ImageSource.camera),
//                           child: const Text('Open Camera'))
//                     ],
//                   ));
//         },
//       );
// }

// class TextInputFieldEdit extends StatelessWidget {
//   const TextInputFieldEdit({
//     Key? key,
//     required this.icon,
//     required this.hint,
//     required this.inputType,
//     required this.inputAction,
//     required this.height,
//   }) : super(key: key);

//   final IconData icon;
//   final String hint;
//   final TextInputType inputType;
//   final TextInputAction inputAction;
//   final double height;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Container(
//         height: size.height * height,
//         width: size.width * 0.8,
//         decoration: BoxDecoration(
//           color: colorWhite,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: colorOrange,
//             width: 1,
//           ),
//         ),
//         child: Center(
//           child: TextField(
//             decoration: InputDecoration(
//                 border: InputBorder.none,
//                 prefixIcon: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Icon(
//                     icon,
//                     size: 24,
//                     color: colorTurqoise,
//                   ),
//                 ),
//                 hintText: hint,
//                 hintStyle: const TextStyle(color: Colors.black)),
//             style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.normal,
//                 color: colorTurqoise),
//             keyboardType: inputType,
//             textInputAction: inputAction,
//           ),
//         ),
//       ),
//     );
//   }
// }
