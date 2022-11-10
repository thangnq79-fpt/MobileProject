import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/constants/color.dart';

const String patternVietnamese =
    '[^aAàÀảẢãÃáÁạẠăĂằẰẳẲẵẴắẮặẶâÂầẦẩẨẫẪấẤậẬbBcCdDđĐeEèÈẻẺẽẼéÉẹẸêÊềỀểỂễỄếẾệỆfFgGhHiIìÌỉỈĩĨíÍịỊjJkKlLmMnNoOòÒỏỎõÕóÓọỌôÔồỒổỔỗỖốỐộỘơƠờỜởỞỡỠớỚợỢpPqQrRsStTuUùÙủỦũŨúÚụỤưƯừỪửỬữỮứỨựỰvVwWxXyYỳỲỷỶỹỸýÝỵỴzZ0123456789 ]';

class MyRegisterScreen extends StatefulWidget {
  @override
  _MyRegisterScreen createState() {
    return _MyRegisterScreen();
  }
}

class _MyRegisterScreen extends State<MyRegisterScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final maxLengthTextField = 30;

  bool agreeTerms = false;
  bool isFilledInAll = false;
  bool showPassword = false;
  String isErrorFromServe = "";

  Future<void> userSetup(String displayName, String email, String numberPhone,
      String password) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    users.doc(uid).set({
      'userName': displayName,
      'email': email,
      'numberPhone': numberPhone,
      'password': password,
      'uid': uid,
    });
  }

  void _showToast(String context) {
    Fluttertoast.showToast(
      msg: context,
      backgroundColor: redColor,
      textColor: whiteColor,
      gravity: ToastGravity.CENTER,
    );
  }

  Color getbackgroudcolor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Color(0xff7243cf);
    }
    return Color(0xff7243cf);
  }

  bool isCapitalLetter(String letter) {
    String letterToUpperCase =
        letter.replaceAll(RegExp(patternVietnamese), '').toUpperCase();
    return letter == letterToUpperCase ? true : false;
  }

  bool isNumberPhone(String numberPhone) {
    if (numberPhone == null) {
      return false;
    }
    return int.tryParse(numberPhone) != null;
  }

  Future<void> signUpOnServe() async {
    try {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      User updateUser = FirebaseAuth.instance.currentUser;
      updateUser.updateProfile(displayName: userController.text);
      userSetup(userController.text, emailController.text,
          numberPhoneController.text, passwordController.text);
    } on FirebaseAuthException catch (e) {
      isErrorFromServe = e.code.toString();
      // print(isErrorFromServe);
    } catch (e) {
      isErrorFromServe = e.toString();
      // print(isErrorFromServe);
    }
    if (isErrorFromServe == "") {
      Navigator.pop(context);
    } else {
      _showToast(isErrorFromServe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: darkPurpleColor,
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(4 * SizeConfig.heightMultiplier),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          height: 11.2 * SizeConfig.heightMultiplier,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 6.8 * SizeConfig.heightMultiplier,
                                    padding: EdgeInsets.only(
                                      top: 1 * SizeConfig.heightMultiplier,
                                      bottom: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    alignment: Alignment.bottomLeft,
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Username ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'SegoeUI',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '(write in capital letters)',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'SegoeUI',
                                            ),
                                          ),
                                        ],
                                      ),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 2 * SizeConfig.widthMultiplier,
                                      right: 2 * SizeConfig.widthMultiplier,
                                    ),
                                    height: 7 * SizeConfig.heightMultiplier,
                                    child: TextField(
                                      controller: userController,
                                      maxLength: maxLengthTextField,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        hintText: 'Enter your username',
                                        hintStyle: TextStyle(
                                          color: Color(0xffd7cee9),
                                          fontFamily: 'SegoeUI',
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xffe5e8fb),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              ),
                              height: 13.8 * SizeConfig.heightMultiplier,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 6.8 * SizeConfig.heightMultiplier,
                                    padding: EdgeInsets.only(
                                      top: 1 * SizeConfig.heightMultiplier,
                                      bottom: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      'Email',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 2 * SizeConfig.widthMultiplier,
                                      right: 2 * SizeConfig.widthMultiplier,
                                    ),
                                    height: 7 * SizeConfig.heightMultiplier,
                                    child: TextField(
                                      controller: emailController,
                                      maxLength: maxLengthTextField,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        hintText: 'Enter your email',
                                        hintStyle: TextStyle(
                                          color: Color(0xffd7cee9),
                                          fontFamily: 'SegoeUI',
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xffe5e8fb),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              ),
                              height: 13.8 * SizeConfig.heightMultiplier,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 6.8 * SizeConfig.heightMultiplier,
                                    padding: EdgeInsets.only(
                                      top: 1 * SizeConfig.heightMultiplier,
                                      bottom: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      'Phone',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 2 * SizeConfig.widthMultiplier,
                                      right: 2 * SizeConfig.widthMultiplier,
                                    ),
                                    height: 7 * SizeConfig.heightMultiplier,
                                    child: TextField(
                                      controller: numberPhoneController,
                                      maxLength: maxLengthTextField,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        hintText: 'Enter your number phone',
                                        hintStyle: TextStyle(
                                          color: Color(0xffd7cee9),
                                          fontFamily: 'SegoeUI',
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xffe5e8fb),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              ),
                              height: 13.8 * SizeConfig.heightMultiplier,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 6.8 * SizeConfig.heightMultiplier,
                                    padding: EdgeInsets.only(
                                      top: 1 * SizeConfig.heightMultiplier,
                                      bottom: 1 * SizeConfig.heightMultiplier,
                                    ),
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      'Password',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                      left: 2 * SizeConfig.widthMultiplier,
                                    ),
                                    height: 7 * SizeConfig.heightMultiplier,
                                    child: TextField(
                                      controller: passwordController,
                                      maxLength: maxLengthTextField,
                                      decoration: InputDecoration(
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                          child: Icon(showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                        ),
                                        border: InputBorder.none,
                                        counterText: "",
                                        hintText: 'Enter your password',
                                        hintStyle: TextStyle(
                                          color: Color(0xffd7cee9),
                                          fontFamily: 'SegoeUI',
                                        ),
                                      ),
                                      obscureText: !showPassword,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xffe5e8fb),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              ),
                              height: 13.8 * SizeConfig.heightMultiplier,
                              margin: EdgeInsets.only(
                                  bottom: 1 * SizeConfig.heightMultiplier),
                            ),
                            Container(
                              height: 4 * SizeConfig.heightMultiplier,
                              margin: EdgeInsets.only(
                                  bottom: 5.8 * SizeConfig.heightMultiplier),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Theme(
                                    data: ThemeData(
                                      checkboxTheme: CheckboxThemeData(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      unselectedWidgetColor: Colors.redAccent,
                                    ),
                                    child: Checkbox(
                                      checkColor: Colors.greenAccent,
                                      activeColor: Colors.green,
                                      value: this.agreeTerms,
                                      onChanged: (bool value) {
                                        setState(() {
                                          this.agreeTerms = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    'I accept the terms of the agreement',
                                    style: TextStyle(
                                      color: Color(0xffd7cee9),
                                      fontSize: 12,
                                      fontFamily: 'SegoeUI',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 5 * SizeConfig.heightMultiplier,
                          margin: EdgeInsets.only(
                              bottom: 5 * SizeConfig.widthMultiplier),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (userController.text == "" ||
                                    emailController.text == "" ||
                                    numberPhoneController.text == "" ||
                                    passwordController.text == "") {
                                  isFilledInAll = false;
                                } else {
                                  isFilledInAll = true;
                                }
                                if (!isFilledInAll) {
                                  _showToast('Bạn chưa điền đầy đủ thông tin');
                                } else if (!isCapitalLetter(
                                    userController.text)) {
                                  _showToast(
                                      'Username phải ghi in hoa và không có ký tự đặt biệt');
                                } else if (!isNumberPhone(
                                    numberPhoneController.text)) {
                                  _showToast(
                                      'Nhập số điện thoại không chính xác');
                                } else if (passwordController.text.length < 8) {
                                  _showToast('Mật khẩu ít nhất 8 ký tự');
                                } else if (!agreeTerms) {
                                  _showToast(
                                      'Bạn chưa đọc và chấp nhận điều khoản');
                                } else {
                                  isErrorFromServe = "";
                                  signUpOnServe();
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          getbackgroudcolor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ))),
                              child: Container(
                                width: 40 * SizeConfig.widthMultiplier,
                                child: Center(
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'SegoeUI',
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 6 * SizeConfig.heightMultiplier,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(
                                    color: Color(0xffd7cee9),
                                    fontSize: 16,
                                    fontFamily: 'SegoeUI',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Color(0xff7243cf),
                                    fontSize: 16,
                                    fontFamily: 'SegoeUI',
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
