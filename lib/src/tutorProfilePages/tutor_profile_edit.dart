import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/components.dart';
import 'package:image_picker/image_picker.dart';

class TutorProfileEdit extends StatefulWidget {
  const TutorProfileEdit({Key? key}) : super(key: key);

  @override
  _TutorProfileEditState createState() => _TutorProfileEditState();
}

class _TutorProfileEditState extends State<TutorProfileEdit> {
  File? image;

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    }

    final imageTempPath = File(image.path);
    setState(() => this.image = imageTempPath);
  }

  ImageProvider buildImage() {
    if (image != null) {
      return fileImage();
    }
    return const AssetImage('assets/Pictures/penguin.png');
  }

  FileImage fileImage() {
    return FileImage(image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        topDesign(),
        buildBody(),
      ],
    ));
  }

  Widget buildBody() {
    final screenWidthSize = MediaQuery.of(context).size.width;
    final screenHeightSize = MediaQuery.of(context).size.height;
    const nameToEdit = " Carol Timith";
    // FilePickerResult? filePickerResult;
    // String? fileName;
    // PlatformFile? file;
    // bool isUploading = false;
    // File? fileToUpload;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: screenWidthSize * 0.15, right: screenWidthSize * 0.15),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Change to: ",
              labelText: nameToEdit,
              labelStyle: TextStyle(
                color: colorTurqoise,
                fontSize: screenWidthSize * 0.05,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenWidthSize * 0.15, right: screenWidthSize * 0.15),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "Change To:",
              labelText:
                  "About Me: I am a self motivated individual who finds joy in exploring new technologies. I absolutely love teaching people. Fun fact: I love cooking. Always eager to help, feel free to hmu! ",
              labelStyle: TextStyle(
                color: colorTurqoise,
                overflow: TextOverflow.visible,
                fontSize: screenWidthSize * 0.05,
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeightSize * 0.05),
        // UploadButton(
        //   btnIcon: Icons.upload,
        //   btnName: "    Upload Latest Transcript",
        //   onPressed: () {},
          // onPressed: () async {
          //   try {
          //     setState(() {
          //       isUploading = true;
          //     });

          //     filePickerResult = await FilePicker.platform.pickFiles(
          //       type: FileType.any,
          //       allowMultiple: false,
          //       allowedExtensions: ['pdf'],
          //     );

          //     if (filePickerResult == null) {
          //       return;
          //     }
          //     fileName = filePickerResult!.files.first.name;
          //     file = filePickerResult!.files.first;
          //     fileToUpload = File(file!.path.toString());

          //     print("File name: " + fileName!);
          //     setState(() {
          //       isUploading = false;
          //     });
          //   } catch (e) {
          //     print(e);
          //   }
          // },
        // ),
        SizedBox(height: screenHeightSize * 0.03),
        // DowloadLinkButton(btnName: "Download Transcript", onPressed: () {}),
        SizedBox(height: screenHeightSize * 0.03),
        UploadButton(
            btnName: "    Upload Id",
            onPressed: () {},
            btnIcon: Icons.cloud_upload),
        SizedBox(height: screenHeightSize * 0.03),
        OrangeButton(btnName: "Save", onPressed: () {})
      ],
    );
  }

  Widget topDesign() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.25,
            margin: const EdgeInsets.only(bottom: 78),
            child: buildCoverImage()),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.18,
          child: buildProfileImage(),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.26,
          left: MediaQuery.of(context).size.height * 0.23,
          child: buildEditImageIcon(),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: const Image(
          image: AssetImage('assets/Pictures/tutorCover.jpg'),
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: 50,
        backgroundColor: const Color.fromRGBO(66, 66, 66, 1),
        backgroundImage: buildImage(),
      );

  Widget buildEditImageIcon() => ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: colorOrange,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8)),
        child: const Icon(
          Icons.add_a_photo_outlined,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actions: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back)),
                      TextButton(
                          onPressed: () => pickImage(ImageSource.gallery),
                          child: const Text('Open Gallery')),
                      TextButton(
                          onPressed: () => pickImage(ImageSource.camera),
                          child: const Text('Open Camera'))
                    ],
                  ));
        },
      );

  // uploadTranscript() {}
}

class TextInputFieldEdit extends StatelessWidget {
  const TextInputFieldEdit({
    Key? key,
    required this.icon,
    required this.hint,
    required this.inputType,
    required this.inputAction,
    required this.height,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final double height;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: size.height * height,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: colorWhite,
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
                    color: colorTurqoise,
                  ),
                ),
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black)),
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: colorTurqoise),
            keyboardType: inputType,
            textInputAction: inputAction,
          ),
        ),
      ),
    );
  }
}
