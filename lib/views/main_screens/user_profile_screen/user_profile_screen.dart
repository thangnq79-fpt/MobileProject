import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tesma/models/firebase_authen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/constants/color.dart';
import 'package:tesma/models/userinf.dart';
import 'package:tesma/views/main_screens/user_profile_screen/edit_profile.dart';

class UserProfile extends StatefulWidget {
  final DocumentSnapshot userdata;
  //final UserInf userinfor;
  const UserProfile({Key key, this.userdata}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  //final String currentUid = FirebaseAuth.instance.currentUser.uid;
  @override
  void initState() {
    super.initState();
    userinf = UserInf.fromSnapshot(widget.userdata);
    getUserinf();
  }

  UserInf userinf;
  String highSchool = '';
  String faceBook = '';
  String phoneNumber = '';

  getUserinf() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userinf.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          highSchool = documentSnapshot.data()['highSchool'];
          faceBook = documentSnapshot.data()['faceBook'];
          phoneNumber = documentSnapshot.data()['numberPhone'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -5 * SizeConfig.heightMultiplier,
            right: 0 * SizeConfig.widthMultiplier,
            left: 0 * SizeConfig.widthMultiplier,
            child: Container(
                height: 40 * SizeConfig.heightMultiplier,
                decoration: BoxDecoration(
                  color: darkPurpleColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 10,
                    )
                  ],
                ),
                child: Container(
                    padding: EdgeInsets.only(
                        top: 10 * SizeConfig.heightMultiplier,
                        left: 10 * SizeConfig.widthMultiplier),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: "PROFILE",
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'SegoeUI',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(
                          width: 10 * SizeConfig.widthMultiplier,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pressEdit();
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.yellow,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5 * SizeConfig.widthMultiplier),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )
                      ],
                    ))),
          ),
          //  Profile - Edit
          Positioned(
            top: 14 * SizeConfig.heightMultiplier,
            child: Container(
              height: 31.5 * SizeConfig.heightMultiplier,
              width: MediaQuery.of(context).size.width -
                  20 * SizeConfig.widthMultiplier,
              margin: EdgeInsets.symmetric(
                  horizontal: 10 * SizeConfig.widthMultiplier),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ]),
              child: Column(
                children: [
                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),
                  Container(
                    width: 20 * SizeConfig.widthMultiplier,
                    height: 11.42826 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            width: 1 * SizeConfig.widthMultiplier,
                            color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://cdns-images.dzcdn.net/images/artist/061868f886135e41428193285fc9de31/264x264.jpg'))),
                  ),
                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),
                  Text(
                    userinf.userName,
                    style: TextStyle(
                      fontSize: 3 * SizeConfig.textMultiplier,
                      fontFamily: 'SegoeUIB',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),
                  Text(
                    userinf.userType.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SegoeUI',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            userinf.listClass != null
                                ? userinf.listClass.length.toString()
                                : '0',
                            style: TextStyle(
                              color: Color(0xff181a54),
                              fontSize: 25,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text('Classes',
                              style: TextStyle(
                                fontFamily: 'SegoeUI',
                                fontWeight: FontWeight.w900,
                              ))
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          //  Common information
          Positioned(
            top: 47.5 * SizeConfig.heightMultiplier,
            child: Container(
              height: 11.5 * SizeConfig.heightMultiplier,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width -
                  20 * SizeConfig.widthMultiplier,
              margin: EdgeInsets.symmetric(
                  horizontal: 10 * SizeConfig.widthMultiplier),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.school,
                    size: 10 * SizeConfig.imageSizeMultiplier,
                  ),
                  SizedBox(
                    width: 10 * SizeConfig.widthMultiplier,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "High School",
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontFamily: 'SegoeUI',
                          fontWeight: FontWeight.w900,
                          color: Color(0xff181a54),
                        ),
                      ),
                      SizedBox(
                        height: 0.25 * SizeConfig.heightMultiplier,
                      ),
                      Text(
                        highSchool == null ? '' : highSchool,
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontFamily: 'SegoeUIB',
                          fontWeight: FontWeight.w300,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          //  HighSchool
          Positioned(
            top: 61 * SizeConfig.heightMultiplier,
            child: Container(
              height: 11.5 * SizeConfig.heightMultiplier,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width -
                  20 * SizeConfig.widthMultiplier,
              margin: EdgeInsets.symmetric(
                  horizontal: 10 * SizeConfig.widthMultiplier),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.facebook,
                    size: 10 * SizeConfig.imageSizeMultiplier,
                  ),
                  SizedBox(
                    width: 10 * SizeConfig.widthMultiplier,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Facebook",
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SegoeUI',
                          color: Color(0xff181a54),
                        ),
                      ),
                      SizedBox(
                        height: 0.25 * SizeConfig.heightMultiplier,
                      ),
                      Text(
                        faceBook == null ? '' : faceBook,
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontFamily: 'SegoeUIB',
                          fontWeight: FontWeight.w300,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          //  Facebook
          Positioned(
            top: 74.5 * SizeConfig.heightMultiplier,
            child: Container(
              height: 11.5 * SizeConfig.heightMultiplier,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width -
                  20 * SizeConfig.widthMultiplier,
              margin: EdgeInsets.symmetric(
                  horizontal: 10 * SizeConfig.widthMultiplier),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 10 * SizeConfig.imageSizeMultiplier,
                  ),
                  SizedBox(
                    width: 10 * SizeConfig.widthMultiplier,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SegoeUI',
                          color: Color(0xff181a54),
                        ),
                      ),
                      SizedBox(
                        height: 0.25 * SizeConfig.heightMultiplier,
                      ),
                      Text(
                        phoneNumber == null ? '' : phoneNumber,
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontFamily: 'SegoeUIB',
                          fontWeight: FontWeight.w300,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          //  Phone Number
          Positioned(
            top: 90 * SizeConfig.heightMultiplier,
            child: Container(
              height: 5 * SizeConfig.heightMultiplier,
              width: MediaQuery.of(context).size.width -
                  60 * SizeConfig.widthMultiplier,
              margin: EdgeInsets.symmetric(
                  horizontal: 30 * SizeConfig.widthMultiplier),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 5,
                    )
                  ]),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink[400],
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.widthMultiplier),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  context.read<AuthService>().signOut();
                },
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'SegoeUI',
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
          //  SignOut
        ],
      ),
    );
  }

  void pressEdit() async {
    String result = '';
    result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfile(userdata: widget.userdata)),
    );
    if (result == 'updated') {
      setState(() {
        getUserinf();
      });
    }
  }
}
