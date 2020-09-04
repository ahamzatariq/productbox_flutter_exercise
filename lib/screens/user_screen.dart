import 'dart:io';

import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

import './view_image_screen.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int currentSteps = 0;
  var cvThumbnail;
  File _storedImageID;
  File _storedImageCV;
  File _storedImageLicense;
  File _storedImageCertificate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Upload Documents',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: StepProgressIndicator(
                      roundedEdges: Radius.circular(10),
                      totalSteps: 4,
                      currentStep: currentSteps,
                      selectedColor: Colors.blue,
                      unselectedColor: Colors.grey[300],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  idCard('ID Card'),
                  cvCard('CV'),
                  licenseCard('License'),
                  certificateCard('Certificate'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  elevation: 5,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  onPressed: () {
                    print(currentSteps);
                    print(_storedImageID);
                    print(_storedImageCV);
                    print(_storedImageLicense);
                    print(_storedImageCertificate);
                  },
                  color: currentSteps < 3 ? Colors.grey : Colors.cyan,
                  child: Text(
                    'Done',
                  ),
                  textColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget idCard(String title) {
    return GestureDetector(
      child: customCard(title, Icon(Icons.credit_card), 0),
      onTap: () {
        if (_storedImageID == null) {
          if (currentSteps == 0) openModalBottomSheet(context);
        } else if (currentSteps > 0) viewId();
      },
    );
  }

  Widget cvCard(String title) {
    return GestureDetector(
      child: customCard(title, Icon(Icons.insert_drive_file), 1),
      onTap: () {
        if (_storedImageCV == null) {
          if (currentSteps == 1) openModalBottomSheet(context);
        } else if (currentSteps > 1) viewCV();
      },
    );
  }

  Widget licenseCard(String title) {
    return GestureDetector(
      child: customCard(title, Icon(Icons.card_travel), 2),
      onTap: () {
        if (_storedImageLicense == null) {
          if (currentSteps == 2) openModalBottomSheet(context);
        } else if (currentSteps > 2) viewLicense();
      },
    );
  }

  Widget certificateCard(String title) {
    return GestureDetector(
      child: customCard(title, Icon(Icons.insert_drive_file), 3),
      onTap: () {
        if (_storedImageCertificate == null) {
          if (currentSteps == 3) openModalBottomSheet(context);
        } else if (currentSteps > 3) viewCertificate();
      },
    );
  }

  Widget customCard(String title, Icon icon, int cardNumber) {
    File _tempStoredFile;
    _tempStoredFile = null;
    switch (cardNumber) {
      case 0:
        _tempStoredFile = _storedImageID;
        break;

      case 1:
        _tempStoredFile = _storedImageCV;
        break;

      case 2:
        _tempStoredFile = _storedImageLicense;
        break;

      case 3:
        _tempStoredFile = _storedImageCertificate;
        break;

      default:
        _tempStoredFile = null;
    }

    return Card(
      margin: EdgeInsets.all(5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(45),
        side: BorderSide(
            color: currentSteps == cardNumber ? Colors.blue : Colors.black54),
      ),
      child: ListTile(
          title: Row(
            children: <Widget>[
              SizedBox(
                width: 7,
              ),
              Text(title),
            ],
          ),
          trailing: (_tempStoredFile != null &&
                  (_tempStoredFile.path.endsWith('.png') ||
                      _tempStoredFile.path.endsWith('.jpg')))
              ? Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(5),
                  child: Image.file(
                    _tempStoredFile,
                    fit: BoxFit.fill,
                  ),
                )
              : (_tempStoredFile != null &&
                      _tempStoredFile.path.endsWith('.pdf'))
                  ? Icon(
                      Icons.picture_as_pdf,
                      color: Colors.redAccent,
                      size: 45,
                    )
                  : icon),
    );
  }

  void openModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(15),
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Select source',
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      pickDocument();
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.insert_drive_file,
                          size: 48,
                          color: Colors.redAccent,
                        ),
                        Text('Document'),
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.blue,
                        ),
                        Text('Gallery'),
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      captureImage().then((value) {
                        setState(() {
                          currentSteps++;
                        });
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: Colors.black,
                        ),
                        Text('Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> captureImage() async {
    var tempFile;
    tempFile = null;
    // ignore: deprecated_member_use
    tempFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (tempFile == null) return null;
    setState(() {
      if (currentSteps == 0)
        _storedImageID = tempFile;
      else if (currentSteps == 1)
        _storedImageCV = tempFile;
      else if (currentSteps == 2)
        _storedImageLicense = tempFile;
      else if (currentSteps == 3) _storedImageCertificate = tempFile;
    });

//    final appDir = await sysPaths.getApplicationDocumentsDirectory();
//    final fileName = path.basename(tempFile.path);
//    final savedImage = await tempFile.copy('${appDir.path}/$fileName');
//    widget.onSelectImage(savedImage);
  }

  void pickImage() async {
    File tempFile;
    var tempPath;
    tempFile = null;
    tempPath = null;
    FilePickerCross filePickerCross = await FilePickerCross.importFromStorage(
      type: FileTypeCross
          .image, // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
//        fileExtension:
//            '.jpg, .png,' // Only if FileTypeCross.custom . May be any file extension like `.dot`, `.ppt,.pptx,.odp`
    );
    tempPath = filePickerCross.path;
    tempFile = File(tempPath);
    setState(() {
      if (currentSteps == 0)
        _storedImageID = tempFile;
      else if (currentSteps == 1)
        _storedImageCV = tempFile;
      else if (currentSteps == 2)
        _storedImageLicense = tempFile;
      else if (currentSteps == 3) _storedImageCertificate = tempFile;
    });

    if (tempFile != null) {
      setState(() {
        currentSteps++;
      });
    }
  }

  void pickDocument() async {
    File tempFile;
    var tempPath;
    tempFile = null;
    tempPath = null;
    FilePickerCross filePickerCross = await FilePickerCross.importFromStorage(
        type: FileTypeCross.custom,
        // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
        fileExtension:
            '.pdf' // Only if FileTypeCross.custom . May be any file extension like `.dot`, `.ppt,.pptx,.odp`
        );
    tempPath = filePickerCross.path;
    tempFile = File(tempPath);
    setState(() {
      if (currentSteps == 0)
        _storedImageID = tempFile;
      else if (currentSteps == 1)
        _storedImageCV = tempFile;
      else if (currentSteps == 2)
        _storedImageLicense = tempFile;
      else if (currentSteps == 3) _storedImageCertificate = tempFile;
    });

    if (tempFile != null) {
      setState(() {
        currentSteps++;
      });
    }
  }

  void viewId() {
    print('viewId');
    Navigator.of(context)
        .pushNamed(ViewImageScreen.routeName, arguments: _storedImageID);
  }

  void viewCV() {
    print('viewCV');
    Navigator.of(context)
        .pushNamed(ViewImageScreen.routeName, arguments: _storedImageCV);
  }

  void viewLicense() {
    print('viewLicense');
    Navigator.of(context)
        .pushNamed(ViewImageScreen.routeName, arguments: _storedImageLicense);
  }

  void viewCertificate() {
    print('viewCertificate');
    Navigator.of(context).pushNamed(ViewImageScreen.routeName,
        arguments: _storedImageCertificate);
  }
}
