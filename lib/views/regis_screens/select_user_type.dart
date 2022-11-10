import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tesma/constants/color.dart';

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

void _showToast(String context) {
  Fluttertoast.showToast(
    msg: context,
    backgroundColor: redColor,
    textColor: whiteColor,
    gravity: ToastGravity.CENTER,
  );
}

Future<void> userUpdate(String typeUser) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users.doc(currentUser.uid).update({
    'userType': typeUser,
  });
}

class MyTypeUserSelectionScreen extends StatefulWidget {
  final int countPopScreen;
  MyTypeUserSelectionScreen({Key key, @required this.countPopScreen})
      : super(key: key);

  @override
  _MyTypeUserSelectionScreen createState() {
    return _MyTypeUserSelectionScreen(countPopScreen);
  }
}

class _MyTypeUserSelectionScreen extends State<MyTypeUserSelectionScreen> {
  String typeUser = '';
  String isErrorFromServe;

  int countPopScreen;
  _MyTypeUserSelectionScreen(this.countPopScreen);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return Scaffold(
              backgroundColor: Color(0xFF181a54),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 10 * SizeConfig.heightMultiplier,
                    bottom: 10 * SizeConfig.heightMultiplier,
                    left: 10 * SizeConfig.widthMultiplier,
                    right: 10 * SizeConfig.widthMultiplier,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomLeft,
                        height: 7 * SizeConfig.heightMultiplier,
                        child: Text(
                          'Select User Type',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        height: 3.5 * SizeConfig.heightMultiplier,
                        child: Text(
                          'Please choose your profession',
                          style: TextStyle(
                            color: Color(0xffd7cee9),
                            fontSize: 16,
                            fontFamily: 'SegoeUI',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 2 * SizeConfig.heightMultiplier,
                        ),
                        alignment: Alignment.bottomLeft,
                        height: 2.5 * SizeConfig.heightMultiplier,
                        child: Container(
                          height: 1 * SizeConfig.heightMultiplier,
                          width: 17 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            color: Color(0xff7243cf),
                            borderRadius: BorderRadius.circular(3.5),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 7 * SizeConfig.heightMultiplier,
                          bottom: 7 * SizeConfig.heightMultiplier,
                        ),
                        alignment: Alignment.center,
                        height: 16 * SizeConfig.heightMultiplier,
                        width: 40 * SizeConfig.widthMultiplier,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              typeUser = 'teacher';
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 16 * SizeConfig.heightMultiplier,
                            width: 40 * SizeConfig.widthMultiplier,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.chalkboardTeacher,
                                  size: 6.5 * SizeConfig.heightMultiplier,
                                ),
                                Text(
                                  'Teacher',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'SegoeUI',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: typeUser == 'teacher'
                              ? lightGreenColor
                              : lightGreyColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 7 * SizeConfig.heightMultiplier,
                        ),
                        alignment: Alignment.center,
                        height: 16 * SizeConfig.heightMultiplier,
                        width: 40 * SizeConfig.widthMultiplier,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              typeUser = 'student';
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 16 * SizeConfig.heightMultiplier,
                            width: 40 * SizeConfig.widthMultiplier,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.userFriends,
                                  size: 6.5 * SizeConfig.heightMultiplier,
                                ),
                                Text(
                                  'Student',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'SegoeUI',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: typeUser == 'student'
                              ? lightGreenColor
                              : lightGreyColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 5 * SizeConfig.heightMultiplier,
                        width: 30 * SizeConfig.widthMultiplier,
                        child: ElevatedButton(
                          onPressed: () {
                            if (typeUser == '') {
                              _showToast('Vui lòng chọn loại tài khoản');
                            } else {
                              userUpdate(typeUser);
                              Navigator.of(context)
                                  .popUntil((_) => countPopScreen-- <= 0);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            // height: 5 * SizeConfig.heightMultiplier,
                            // width: 30 * SizeConfig.widthMultiplier,
                            child: Text(
                              'Start',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'SegoeUI',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      getbackgroudcolor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ))),
                        ),
                      ),
                    ],
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
