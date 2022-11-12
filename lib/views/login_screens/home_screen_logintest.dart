import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/firebase_authen.dart';

class HomePageLoginTest extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Center(
          child: Container(
            child: Text(
              "Register",
              style: TextStyle(
                fontSize: 40.0,
              ),
            ),
            margin: const EdgeInsets.only(top: 40),
            height: 48.0,
          ),
        ),
        Text('Homepage'),
        Center(
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthService>().signOut();
            },
            child: Text("Signout"),
          ),
        ),
      ]),
    );
  }
}
