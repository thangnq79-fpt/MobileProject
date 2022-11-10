import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tesma/constants/color.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/models/classinf.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class QrClass extends StatefulWidget {
  final ClassInf classinf;
  final String userType;
  const QrClass({Key key, @required this.classinf, @required this.userType})
      : super(key: key);
  @override
  _QrClassState createState() => _QrClassState();
}

class _QrClassState extends State<QrClass> {
  ClassInf classinf;
  String qrcode = "";
  bool hasGenerateQrCode = false;
  @override
  void initState() {
    super.initState();
    classinf = widget.classinf;
  }

  Color getbackgroudcolor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return lightPurpleColor;
    }
    return redColor;
  }

  String dateToString(DateTime aDayTime) {
    String day = aDayTime.day.toString();
    String month = aDayTime.month.toString();
    String year = aDayTime.year.toString();
    if (day.length == 1) day = '0' + day;
    if (month.length == 1) month = '0' + month;
    return day + '-' + month + '-' + year;
  }

  Random random = new Random();

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(random.nextInt(_chars.length))));

  void createQrCode() {
    if (hasGenerateQrCode == false) {
      setState(() {
        DateTime now = DateTime.now();
        hasGenerateQrCode = true;
        qrcode = classinf.classid + dateToString(now) + getRandomString(10);
        FirebaseFirestore.instance
            .collection('classes')
            .doc(classinf.classid)
            .update({
          'qrCode': qrcode,
        });
      });
    } else {
      setState(() {
        qrcode = '';
        hasGenerateQrCode = false;
        FirebaseFirestore.instance
            .collection('classes')
            .doc(classinf.classid)
            .update({
          'qrCode': '',
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          //resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              //height: 61.1 * SizeConfig.heightMultiplier,
              width: 100 * SizeConfig.widthMultiplier,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 87),
              color: light_periwinkle,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: qrcode != ''
                        ? QrImage(
                            data: qrcode,
                            version: QrVersions.auto,
                            size: 30 * SizeConfig.heightMultiplier,
                          )
                        : Container(
                            alignment: Alignment.topCenter,
                            height: 30 * SizeConfig.heightMultiplier,
                            width: 30 * SizeConfig.heightMultiplier,
                          ),
                  ),
                  widget.userType == 'teacher'
                      ? Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: TextButton(
                                onPressed: createQrCode,
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          royalBlueColor),
                                  backgroundColor: hasGenerateQrCode
                                      ? MaterialStateProperty.all<Color>(
                                          mediumPink)
                                      : MaterialStateProperty.all<Color>(
                                          lightGreenColor),
                                ),
                                child: Text(
                                  hasGenerateQrCode
                                      ? 'CLICK HERE IF YOU WANT TO CLOSE THIS QR CODE'
                                      : 'CLICK HERE IF YOU WANT TO CREATE A NEW QR CODE',
                                  style: TextStyle(
                                    fontFamily: 'SegoeUI',
                                    color: royalBlueColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: Text(
                                'QR SCAN',
                                style: TextStyle(
                                  fontFamily: 'SegoeUI',
                                  color: royalBlueColor,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              child: Text(
                                "Give this code to your student to make a roll-call",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SegoeUI',
                                  color: royalBlueColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 200),
                          child: Text(
                            'ONLY TEACHERS CAN CREATE QR CODES',
                            style: TextStyle(
                              fontFamily: 'SegoeUI',
                              color: royalBlueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
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
