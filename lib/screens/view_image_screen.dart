import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class ViewImageScreen extends StatelessWidget {
  static const routeName = '/view-image';
  bool isPDF = false;
  bool isImage = false;

  @override
  Widget build(BuildContext context) {
    File tempFile = ModalRoute.of(context).settings.arguments;
    print(tempFile.path);
    if (tempFile != null) {
      if (tempFile.path.endsWith('.pdf')) {
        isPDF = true;
      } else {
        isImage = true;
      }
    }
    return Scaffold(
//      appBar: AppBar(),
      body: Container(
        child: Center(
          child: isImage
              ? Image.file(
                  tempFile,
                  fit: BoxFit.fitWidth,
                )
              : isPDF
                  ? PDFViewerScaffold(
                      path: tempFile.path,
                    )
                  : Center(
                      child: Text('Could not load file'),
                    ),
        ),
      ),
    );
  }
}
