import 'package:flutter/material.dart';
import 'package:productbox_flutter_exercise/screens/view_image_screen.dart';

import './screens/sign_in_screen.dart';
import './screens/user_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignIn(),
      routes: {
        UserScreen.routeName: (context) => UserScreen(),
        ViewImageScreen.routeName: (context) => ViewImageScreen()
      },
    );
  }
}

