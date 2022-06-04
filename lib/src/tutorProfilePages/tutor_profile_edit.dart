import 'package:flutter/material.dart';
import 'package:tutor_me/src/authenticate/login.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:tutor_me/src/components.dart';

class TutorProfileEdit extends StatefulWidget {
  const TutorProfileEdit({Key? key}) : super(key: key);

  @override
  _TutorProfileEditState createState() => _TutorProfileEditState();
}

class _TutorProfileEditState extends State<TutorProfileEdit> {
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
        UploadButton(
          btnIcon: Icons.upload,
          btnName: "    Upload Latest Transcript",
          onPressed: () {},
        ),
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
            margin: const EdgeInsets.only(bottom: 78),
            child: buildCoverImage()),
        Positioned(
          top: 100,
          child: buildProfileImage(),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.27,
          left: MediaQuery.of(context).size.height * 0.26,
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
        backgroundColor: Colors.grey.shade800,
        backgroundImage: const AssetImage("assets/Pictures/tutorProfile.jpg"),
      );

  Widget buildEditImageIcon() => const CircleAvatar(
        radius: 18,
        backgroundColor: colorOrange,
        child: Icon(
          Icons.add_a_photo_outlined,
          color: Colors.white,
        ),
      );
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
