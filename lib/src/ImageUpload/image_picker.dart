import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    print("In picker");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                  onPressed: (() {}), child: const Text("pick gallery")),
              ElevatedButton(
                  onPressed: () => pickImage(), child: const Text("pick camera"))
            ],
          ),
        ),
      ),
    );
  }
}
