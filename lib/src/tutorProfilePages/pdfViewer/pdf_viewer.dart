import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tutor_me/src/colorpallete.dart';

class PDFViewer extends StatelessWidget {
  final Uint8List pdf;

  const PDFViewer({Key? key, required this.pdf}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        backgroundColor: colorBlueTeal,
      ),
      body: Center(
        child: SfPdfViewer.memory(pdf),
      ),
    );
  }
}
