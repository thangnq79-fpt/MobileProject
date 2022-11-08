import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:tesma/constants/color.dart';

class AuthService extends ChangeNotifier {
  final GoogleSignIn ggsignin = GoogleSignIn();
  final FirebaseAuth auth;

  bool _isSigningIn;

  AuthService(this.auth) {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Stream<User> get authStateChanges => auth.authStateChanges();
  Future createUser(String user, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signIn(String user, String password) async {
    isSigningIn = true;
    String err = "";
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user, password: password);
      isSigningIn = false;
      print("Signed in");
    } on FirebaseAuthException catch (e) {
      err = e.code;
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    isSigningIn = false;
    Fluttertoast.showToast(
      msg: err,
      backgroundColor: redColor,
      textColor: whiteColor,
      gravity: ToastGravity.CENTER,
    );
    print(err);
    return err;
  }

  Future signInWithGoogle() async {
    isSigningIn = true;

    final GoogleSignInAccount googleUser = await ggsignin.signIn();
    if (googleUser == null) {
      isSigningIn = false;
      return;
    } else {
      // Trigger the authentication flow

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      String uid = auth.currentUser.uid.toString();
      await users.doc(uid).get().then((docsnap) {
        if (docsnap.data() == null) {
          users.doc(uid).set({
            'userName': auth.currentUser.displayName,
            'email': auth.currentUser.email,
            'uid': uid,
          });
        }
      });

      isSigningIn = false;
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final AccessToken result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final facebookAuthCredential =
        FacebookAuthProvider.credential(result.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  Future signOut() async {
    isSigningIn = true;
    try {
      if (auth.currentUser.providerData[0].providerId == 'google.com') {
        await ggsignin.disconnect();
      }
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    isSigningIn = false;
  }
}
