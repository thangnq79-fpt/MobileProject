import 'package:flutter/material.dart';
import 'package:tesma/views/main_screens/home_screen/tab_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesma/models/classinf.dart';
import 'package:tesma/models/userinf.dart';

import 'package:tesma/constants/size_config.dart';

class MyClassPage extends StatefulWidget {
  final DocumentSnapshot resultList;
  final UserInf currentUser;
  const MyClassPage({Key key, this.resultList, this.currentUser})
      : super(key: key);
  @override
  _MyClassPageState createState() => _MyClassPageState();
}

class _MyClassPageState extends State<MyClassPage> {
  @override
  Widget build(BuildContext context) {
    final classinf = ClassInf.fromSnapshot(widget.resultList);
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          body: Container(
              // height: 100 * SizeConfig.heightMultiplier,
              // width: 100 * SizeConfig.widthMultiplier,
              child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: new DecorationImage(
                    image: AssetImage(
                      'images/montoan.png',
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                height: 21.2 * SizeConfig.heightMultiplier,
                //width: 77.2 * SizeConfig.widthMultiplier,
              ),
              Container(
                height: 10.7 * SizeConfig.heightMultiplier,
                child: Center(
                  child: Text(
                    'Class ' + classinf.grade + ' ' + classinf.subject,
                    style: TextStyle(
                      color: Color(0xff181a54),
                      fontSize: 32,
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  child: TabControllerScreen(
                    classinf: classinf,
                    currentUser: widget.currentUser,
                  ),
                  height: 100 * SizeConfig.heightMultiplier,
                ),
              ),
              // Container(
              //   child: TabControllerScreen(),
              //   height: 7 * SizeConfig.heightMultiplier,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     border: Border.all(
              //       color: Color(0xfffff35f),
              //       // width: 1,
              //     ),
              //   ),
              // ),
            ]),
          )),
        );
      });
    });
  }
}
