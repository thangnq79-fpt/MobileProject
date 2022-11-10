import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesma/models/classinf.dart';
import 'package:tesma/models/userinf.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/views/main_screens/search_screen/tab_controller_class_info_only.dart';

class MyClassPageOnlyClassInfo extends StatefulWidget {
  final DocumentSnapshot resultList;
  final UserInf currentUser;
  const MyClassPageOnlyClassInfo({Key key, this.resultList, this.currentUser})
      : super(key: key);
  @override
  _MyClassPageOnlyClassInfoState createState() =>
      _MyClassPageOnlyClassInfoState();
}

class _MyClassPageOnlyClassInfoState extends State<MyClassPageOnlyClassInfo> {
  @override
  Widget build(BuildContext context) {
    final classinf = ClassInf.fromSnapshot(widget.resultList);
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          body: Container(
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
                  child: TabControllerOnlyClassInfo(
                    classinf: classinf,
                    currentUser: widget.currentUser,
                  ),
                  height: 100 * SizeConfig.heightMultiplier,
                ),
              ),
            ]),
          )),
        );
      });
    });
  }
}
