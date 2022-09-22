// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import '../colorpallete.dart';

// class TextRecognition extends StatefulWidget {
//   const TextRecognition({Key? key}) : super(key: key);

//   @override
//   State<TextRecognition> createState() => TextRecognitionState();
// }

// class TextRecognitionState extends State<TextRecognition> {
//   bool textScanning = false;

//   XFile? imageFile;

//   String scannedText = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: SingleChildScrollView(
//         child: Container(
//             margin: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (textScanning) const CircularProgressIndicator(),
//                 if (!textScanning && imageFile == null)
//                   Container(
//                     width: 300,
//                     height: 300,
//                     color: Colors.grey[300]!,
//                   ),
//                 if (imageFile != null) Image.file(File(imageFile!.path)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 5),
//                         padding: const EdgeInsets.only(top: 10),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: colorBlueTeal,
//                             foregroundColor: Colors.white,
//                             shadowColor: Colors.grey[400],
//                             elevation: 10,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0)),
//                           ),
//                           onPressed: () {
//                             getImage(ImageSource.gallery);
//                           },
//                           child: Container(
//                             color: colorBlueTeal,
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 5, horizontal: 5),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: const [
//                                 Icon(
//                                   Icons.image,
//                                   size: 30,
//                                 ),
//                                 Text(
//                                   "Gallery",
//                                   style: TextStyle(
//                                       fontSize: 13, color: Colors.white),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )),
//                     Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 5),
//                         padding: const EdgeInsets.only(top: 10),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: colorBlueTeal,
//                             foregroundColor: Colors.white,
//                             shadowColor: Colors.grey[400],
//                             elevation: 10,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0)),
//                           ),
//                           onPressed: () {
//                             getImage(ImageSource.camera);
//                           },
//                           child: Container(
//                             color: colorBlueTeal,
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 5, horizontal: 5),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: const [
//                                 Icon(
//                                   Icons.camera_alt,
//                                   size: 30,
//                                 ),
//                                 Text(
//                                   "Camera",
//                                   style: TextStyle(
//                                       fontSize: 13, color: Colors.white),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )),
//                     Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 5),
//                         padding: const EdgeInsets.only(top: 10),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: colorBlueTeal,
//                             foregroundColor: Colors.white,
//                             shadowColor: Colors.grey[400],
//                             elevation: 10,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0)),
//                           ),
//                           onPressed: () {
//                             if (scannedText != "") {
//                               Clipboard.setData(
//                                   ClipboardData(text: scannedText));
//                               Fluttertoast.showToast(
//                                 msg: "Scanned text has been copied.",
//                                 timeInSecForIosWeb: 1,
//                                 textColor: Colors.white,
//                                 backgroundColor: Colors.green,
//                                 fontSize: 16.0,
//                               );
//                             } else {
//                               Fluttertoast.showToast(
//                                 msg: "No text to copy.",
//                                 timeInSecForIosWeb: 1,
//                                 textColor: Colors.white,
//                                 backgroundColor: Colors.black,
//                                 fontSize: 16.0,
//                               );
//                             }
//                           },
//                           child: Container(
//                             color: colorBlueTeal,
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 5, horizontal: 5),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: const [
//                                 Icon(
//                                   Icons.copy,
//                                   size: 30,
//                                 ),
//                                 Text(
//                                   "Copy",
//                                   style: TextStyle(
//                                       fontSize: 13, color: Colors.white),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   scannedText,
//                   style: const TextStyle(fontSize: 20),
//                 )
//               ],
//             )),
//       )),
//     );
//   }

//   void getImage(ImageSource source) async {
//     try {
//       final pickedImage = await ImagePicker().pickImage(source: source);
//       if (pickedImage != null) {
//         textScanning = true;
//         imageFile = pickedImage;
//         setState(() {});
//         getRecognisedText(pickedImage);
//       }
//     } catch (e) {
//       textScanning = false;
//       imageFile = null;
//       scannedText = "Error occured while scanning";
//       setState(() {});
//     }
//   }

//   void getRecognisedText(XFile image) async {
//     final inputImage = InputImage.fromFilePath(image.path);
//     final textDetector = GoogleMlKit.vision.textDetector();
//     RecognisedText recognisedText = await textDetector.processImage(inputImage);
//     await textDetector.close();
//     scannedText = "";
//     for (TextBlock block in recognisedText.blocks) {
//       for (TextLine line in block.lines) {
//         scannedText = scannedText + line.text + "\n";
//         setState(() {
//           scannedText = scannedText;
//         });
//       }
//     }
//     textScanning = false;
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//   }
// }
