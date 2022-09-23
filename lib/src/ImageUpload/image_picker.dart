import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../colorpallete.dart';
import '../theme/themes.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImageUploadState();
  }
}

class ImageUploadState extends State<ImageUpload> {
  Future pickImage() async {
    await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Color textColor;

    if (provider.themeMode == ThemeMode.dark) {
      textColor = colorWhite;
    } else {
      textColor = colorDarkGrey;
    }

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                  onPressed: (() {}),
                  child: Text(
                    "pick gallery",
                    style: TextStyle(
                      color: textColor,
                    ),
                  )),
              ElevatedButton(
                  onPressed: () => pickImage(),
                  child: Text(
                    "pick camera",
                    style: TextStyle(
                      color: textColor,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
