import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tesma/max_width_container.dart';
import 'package:tesma/constants/size_config.dart';
import '../../models/firebase_authen.dart';
import 'package:provider/provider.dart';
import 'package:tesma/views/regis_screens/regis_screen.dart';
import 'package:tesma/responsive_layout.dart';
import 'package:tesma/constants/color.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var borderRadius = BorderRadius.circular(15);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MaxWidthContainer(
          child: ReponsiveLayout(
        mobileBody: LoginMobileContent(),
        tabletBody: LoginMobileContent(),
      )),
    );
  }
}

class LoginMobileContent extends StatefulWidget {
  @override
  _LoginMobileContentState createState() => _LoginMobileContentState();
}

class _LoginMobileContentState extends State<LoginMobileContent> {
  final TextEditingController userController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool showPassword = false;
  bool isFilledInAll = false;

  void _showToast(String context) {
    Fluttertoast.showToast(
      msg: context,
      backgroundColor: redColor,
      textColor: whiteColor,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color getbackgroudcolor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return lightPurpleColor;
      }
      return darkPurpleColor;
    }

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              color: darkPurpleColor,
              child: Column(
                children: [
                  Container(
                    height: 18 * SizeConfig.heightMultiplier,
                    padding: EdgeInsets.fromLTRB(
                        0, 6 * SizeConfig.heightMultiplier, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log in',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'SegoeUI',
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 82 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ],
                      color: Colors.white,
                    ),
                    //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: EdgeInsets.all(4 * SizeConfig.heightMultiplier),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Welcome Back",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'SegoeUI',
                              color: blackColor,
                              fontSize: 4.21 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Hello there, sign in to continue",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'SegoeUI',
                              color: greyColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 2.10 * SizeConfig.textMultiplier,
                            ),
                          ),
                        ),
                        Container(
                          height: 3.95 * SizeConfig.heightMultiplier,
                          child: Text(
                            "Email",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'SegoeUI',
                              color: blackColor,
                              fontSize: 2.10 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 6.58 * SizeConfig.heightMultiplier,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(
                                    2 * SizeConfig.heightMultiplier),
                                labelStyle: TextStyle(
                                  height: 6.58 * SizeConfig.heightMultiplier,
                                  fontFamily: 'SegoeUI',
                                  color: greyColor,
                                  fontSize: 2.10 * SizeConfig.textMultiplier,
                                ),
                                border: OutlineInputBorder(),
                                counterText: "",
                                hintText: 'Enter your Email',
                              ),
                              controller: userController,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          height: 3.95 * SizeConfig.heightMultiplier,
                          child: Text(
                            "Password",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'SegoeUI',
                              color: blackColor,
                              fontSize: 2.10 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 6.58 * SizeConfig.heightMultiplier,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(
                                    2 * SizeConfig.heightMultiplier),
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
                                labelStyle: TextStyle(
                                  height: 6.58 * SizeConfig.heightMultiplier,
                                  fontFamily: 'SegoeUI',
                                  color: greyColor,
                                  fontSize: 2.10 * SizeConfig.textMultiplier,
                                ),
                                border: OutlineInputBorder(),
                                counterText: "",
                                hintText: 'Enter your password',
                              ),
                              controller: passwordController,
                              obscureText: !showPassword,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(children: [
                            Text(
                              "Forgot password ?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'SegoeUI',
                                  color: lightPurpleColor,
                                  fontSize: 2.10 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w600),
                            ),
                          ]),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    if (userController.text == "" ||
                                        passwordController.text == "") {
                                      isFilledInAll = false;
                                    } else {
                                      isFilledInAll = true;
                                    }
                                    if (!isFilledInAll) {
                                      _showToast(
                                          'Bạn chưa điền đầy đủ thông tin');
                                    } else {
                                      context.read<AuthService>().signIn(
                                          userController.text,
                                          passwordController.text);
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              getbackgroudcolor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ))),
                                  child: Container(
                                      width: 49.74 * SizeConfig.widthMultiplier,
                                      height:
                                          5.66 * SizeConfig.heightMultiplier,
                                      child: Center(
                                          child: Text(
                                        "Log in",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'SegoeUI',
                                            color: whiteColor,
                                            fontSize: 2.10 *
                                                SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w900),
                                      )))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Or sign in with",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'SegoeUI',
                                    color: greyColor,
                                    fontSize: 2.10 * SizeConfig.textMultiplier,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<AuthService>()
                                      .signInWithGoogle();
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/image/google.png',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<AuthService>()
                                      .signInWithFacebook();
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/image/facebook.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Don’t have an account ? ",
                                    style: TextStyle(
                                      fontFamily: 'SegoeUI',
                                      color: greyColor,
                                      fontSize:
                                          2.10 * SizeConfig.textMultiplier,
                                    ),
                                  ),
                                ]),
                              ),
                              new GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyRegisterScreen()),
                                  );
                                },
                                child: new Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: lightPurpleColor,
                                      fontSize:
                                          2.10 * SizeConfig.textMultiplier,
                                      fontFamily: 'SegoeUI',
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
