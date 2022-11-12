import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesma/views/login_screens/loading.dart';
import 'package:tesma/views/login_screens/login_screen.dart';
import 'package:tesma/views/main_screens/userinformation.dart';
import 'package:tesma/views/regis_screens/select_user_type.dart';
import '../../models/firebase_authen.dart';
import '../../models/firebase_database.dart';

class AuthenticationWrapper extends StatelessWidget {
  Future newUser(BuildContext context) async {
    bool newUser = await UserInfor().isNewUser();
    if (newUser) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyTypeUserSelectionScreen(countPopScreen: 1)));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: ChangeNotifierProvider(
          create: (context) => AuthService(FirebaseAuth.instance),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<AuthService>(context);
              if (provider.isSigningIn) {
                return Loading();
              } else if (snapshot.hasData) {
                newUser(context);
                return UserInformation();
              } else {
                return LoginForm();
              }
            },
          ),
        ),
      );
  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      );
}
