import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './user_screen.dart';
import '../model/user.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  List<User> users = [];
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  SnackBar snackBar = SnackBar(
    content: Text('Sign-in Successful'),
  );

  Future<List<User>> _getUsers() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/users");
    var jsonData = json.decode(data.body);
    for (var u in jsonData) {
      User user = User(u["id"], u["name"], u["username"], u["email"]);
      users.add(user);
    }

    print(users.length);

    return users;
  }

  @override
  initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          height: deviceSize.height,
          width: deviceSize.width,
          child: signInCard(),
        ),
      ),
    );
  }

  Widget signInCard() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty || value.length < 4) {
                      print('value = $value');
                      return 'Username is too short!';
                    }
                    if (!checkUsername(value)) {
                      return 'Username invalid';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(45),
                        gapPadding: 0.0),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      print('value = $value');
                      return 'Password is too short!';
                    }
                    if (!checkPassword(value)) {
                      return 'Password invalid';
                    }
                    if (!checkUsernamePassword(
                        usernameController.text, value)) {
                      return 'Username and Password do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.indigo),
                ),
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
//                color: Theme.of(context).primaryColor,
                onPressed: () {
                  signInButton();
                },
                color: Colors.cyan,
                child: Text(
                  'Sign In',
                ),
                textColor: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Are you a new User? '),
                      Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void signInButton() {
    String username;
    String password;
    var result = false;

    if (usernameController != null) username = usernameController.text;
    if (passwordController != null) password = passwordController.text;

    var isValid = _formKey.currentState.validate();

    if (isValid == false) {
      return;
    }

    try {
      result = checkUsernamePassword(username, password);
    } catch (_) {
      print('Error');
    }
    print(result);

    if (result) {
      Navigator.of(context).pushNamed(UserScreen.routeName);
    }
  }

  bool checkUsername(String username) {
    if (users.any((user) => user.username == username)) {
      return true;
    }
    return false;
  }

  bool checkPassword(String password) {
    if (users.any((user) => user.email == password)) {
      return true;
    }
    return false;
  }

  bool checkUsernamePassword(String username, String password) {
    if (users
        .any((user) => user.username == username && user.email == password)) {
      return true;
    }
    return false;
  }
}
