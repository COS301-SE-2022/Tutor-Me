import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/services/services/user_services.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/components.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/models/globals.dart';
import '../../services/models/users.dart';

class ToReturn {
  Uint8List image;
  Users user;

  ToReturn(this.image, this.user);
}

// ignore: must_be_immutable
class TutorProfileEdit extends StatefulWidget {
  final Globals globals;
  Uint8List image;
  final bool imageExists;

  TutorProfileEdit(
      {Key? key,
      required this.globals,
      required this.image,
      required this.imageExists})
      : super(key: key);

  @override
  _TutorProfileEditState createState() => _TutorProfileEditState();
}

class _TutorProfileEditState extends State<TutorProfileEdit> {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  File? image;
  bool isImagePicked = false;
  bool isSaveLoading = false;

  Future pickImage(ImageSource source) async {
    final imageChosen = await ImagePicker().pickImage(source: source);
    if (imageChosen == null) {
      return;
    }

    final imageTempPath = File(imageChosen.path);
    setState(() {
      image = imageTempPath;
      isImagePicked = true;
      Navigator.pop(context);
    });
  }

  ImageProvider buildImage() {
    if (image != null) {
      return FileImage(image!);
    }
    return const AssetImage('assets/Pictures/penguin.png');
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
    String nameToEdit = widget.globals.getUser.getName +
        ' ' +
        widget.globals.getUser.getLastName;
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
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Change to: ",
              labelText: nameToEdit,
              labelStyle: TextStyle(
                color: colorBlueTeal,
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
            controller: bioController,
            decoration: InputDecoration(
              hintText: "Change To:",
              labelText: widget.globals.getUser.getBio,
              labelStyle: TextStyle(
                color: colorBlueTeal,
                overflow: TextOverflow.visible,
                fontSize: screenWidthSize * 0.05,
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeightSize * 0.05),
        UploadButton(
          btnIcon: Icons.upload,
          btnName: "    Upload Latest Transcript",
          onPressed: () async {
            final filePick = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );

            File? fileToUpload = File(filePick!.files.single.path!);

           

            // OpenFile.open(file.path.toString());

            try {
              log('here man');
              await UserServices.updateTranscript(
                  fileToUpload, widget.globals.getUser.getId, widget.globals);
            } catch (e) {
              try {
                await UserServices.uploadTranscript(
                    fileToUpload, widget.globals.getUser.getId, widget.globals);
              } catch (e) {
                const snackBar =
                    SnackBar(content: Text('Failed to upload transcript'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }
          },
        ),
        SizedBox(height: screenHeightSize * 0.03),
        DowloadLinkButton(btnName: "Download Transcript", onPressed: () {}),
        SizedBox(height: screenHeightSize * 0.03),
        UploadButton(
          btnName: "    Upload Id",
          btnIcon: Icons.upload,
          onPressed: () {
            pickImage(ImageSource.gallery);
          },
        ),
        SizedBox(height: screenHeightSize * 0.03),
        OrangeButton(
            btnName: isSaveLoading ? "Saving" : 'Save',
            onPressed: () async {
              setState(() {
                isSaveLoading = true;
              });
              if (image != null) {
                try {
                  await UserServices.updateProfileImage(
                      image!, widget.globals.getUser.getId, widget.globals);
                } catch (e) {
                  try {
                    await UserServices.uploadProfileImage(
                        image!, widget.globals.getUser.getId, widget.globals);
                  } catch (e) {
                    const snackBar = SnackBar(
                        content: Text('Failed to upload profile picture'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                try {
                  await UserServices.uploadProfileImage(
                      image, widget.globals.getUser.getId, widget.globals);
                } catch (e) {
                  const snack =
                      SnackBar(content: Text("Error uploading image"));
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                }
              }
              if (bioController.text.isNotEmpty) {
                await UserServices.updateTutorBio(widget.globals.getUser.getId,
                    bioController.text, widget.globals);

                widget.globals.getUser.setBio = bioController.text;

                final globalJson = json.encode(widget.globals.toJson());
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();

                preferences.setString('globals', globalJson);
              }
              if (nameController.text.isNotEmpty ||
                  bioController.text.isNotEmpty) {}
              setState(() {
                isSaveLoading = false;
              });

              Navigator.pop(
                  context, ToReturn(widget.image, widget.globals.getUser));
            })
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
        radius: MediaQuery.of(context).size.width * 0.127,
        backgroundImage: isImagePicked ? buildImage() : null,
        child: isImagePicked
            ? null
            : widget.imageExists
                ? ClipOval(
                    child: Image.memory(
                      widget.image,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.253,
                      height: MediaQuery.of(context).size.width * 0.253,
                    ),
                  )
                : ClipOval(
                    child: Image.asset(
                    "assets/Pictures/penguin.png",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.253,
                    height: MediaQuery.of(context).size.width * 0.253,
                  )),
      );

  Widget buildEditImageIcon() => ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: colorBlueTeal,
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
          // Navigator.pop(context);
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
            color: colorBlueTeal,
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
                    color: colorOrange,
                  ),
                ),
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black)),
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: colorOrange),
            keyboardType: inputType,
            textInputAction: inputAction,
          ),
        ),
      ),
    );
  }
}
