import 'package:flutter/material.dart';

class ViewImageScreen extends StatelessWidget {
  static const routeName = '/view-image';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Image.file(
            ModalRoute.of(context).settings.arguments,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
