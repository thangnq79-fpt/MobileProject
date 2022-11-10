import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tesma/constants/color.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesma/models/userinf.dart';

class QrScan extends StatefulWidget {
  final userdata;
  const QrScan({Key key, this.userdata}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  @override
  void initState() {
    super.initState();
    userinf = UserInf.fromSnapshot(widget.userdata);
  }

  UserInf userinf;
  Barcode result;
  String whyIsItWrongQr = '';
  bool isAllowed = true;
  bool isCorrectCode = false;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isUpdated = false;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  void _showToast(String context) {
    Fluttertoast.showToast(
      msg: context,
      backgroundColor: redColor,
      textColor: whiteColor,
      gravity: ToastGravity.CENTER,
    );
  }

  String dateToString(DateTime aDayTime) {
    String day = aDayTime.day.toString();
    String month = aDayTime.month.toString();
    String year = aDayTime.year.toString();
    if (day.length == 1) day = '0' + day;
    if (month.length == 1) month = '0' + month;
    return day + '-' + month + '-' + year;
  }

  void checkForRepetition(String notif) {
    if (whyIsItWrongQr != notif) {
      setState(() {
        whyIsItWrongQr = notif;
      });
      _showToast(notif);
    }
  }

  Future<void> checkQrCodeAndMarkAttendance(Barcode resultBarCode) async {
    if (isUpdated) return;
    DateTime now = DateTime.now();
    String resultCode = resultBarCode.code;
    if (resultCode.length == 0) {
      checkForRepetition('This QR Code is out of date');
      return;
    }
    if (resultCode.length != 40) {
      checkForRepetition('Wrong type QR Code');
      return;
    }
    String getClassID = resultCode.substring(0, 20);
    String getRamdomCode = resultCode.substring(30, 40);
    String codeFromServe = '';
    setState(() {
      result = resultBarCode;
    });
    setState(() {
      isAllowed = false;
    });
    await FirebaseFirestore.instance
        .collection('classes')
        .doc(getClassID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        codeFromServe = documentSnapshot.data()['qrCode'];
        if (codeFromServe.substring(30, 40) == getRamdomCode &&
            codeFromServe.substring(20, 30) == dateToString(now)) {
          FirebaseFirestore.instance
              .collection('classes')
              .doc(getClassID)
              .collection('schedule')
              .doc(userinf.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              List attendanceList = documentSnapshot.data()['attendance'];
              if (attendanceList == null || attendanceList.length == 0) {
                setState(() {
                  List<String> newList = [dateToString(now)];
                  FirebaseFirestore.instance
                      .collection('classes')
                      .doc(getClassID)
                      .collection('schedule')
                      .doc(userinf.uid)
                      .update({'attendance': newList});
                  isUpdated = true;
                  _showToast("You have been marked to attend today's lesson");
                });
              } else {
                String lastestAttendance = attendanceList[attendanceList.length - 1];
                if (lastestAttendance != dateToString(now)) {
                  setState(() {
                    attendanceList.add(dateToString(now));
                    FirebaseFirestore.instance
                        .collection('classes')
                        .doc(getClassID)
                        .collection('schedule')
                        .doc(userinf.uid)
                        .update({'attendance': attendanceList});
                    isUpdated = true;
                  });
                }
              }
            } else {
              checkForRepetition('You are not a member of this class');
            }
          });
        } else {
          checkForRepetition('This QR Code is out of date');
        }
      } else {
        checkForRepetition('Wrong type QR Code');
      }
    });
    setState(() {
      isAllowed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: IconButton(
                          icon: FutureBuilder<bool>(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Icon(snapshot.data ? Icons.flash_on : Icons.flash_off);
                              } else {}
                              return Text('Flash: ${snapshot.data}');
                            },
                          ),
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: IconButton(
                          icon: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Icon(Icons.switch_camera);
                              } else {
                                return Container();
                              }
                            },
                          ),
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                      '',
                      style: TextStyle(
                        color: royalBlueColor,
                        fontSize: 12,
                        fontFamily: 'SegoeUI',
                      ),
                    )
                  else
                    Text(
                      'Scanning QR code',
                      style: TextStyle(
                        color: royalBlueColor,
                        fontSize: 12,
                        fontFamily: 'SegoeUI',
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.all(8),
                    child: Text(
                      'QR SCAN',
                      style: TextStyle(
                        color: royalBlueColor,
                        fontSize: 40,
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      width: 200,
                      child: Text(
                        'Place your teacher code inside the frame to scan ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: royalBlueColor,
                          fontSize: 16,
                          fontFamily: 'SegoeUI',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
            ? 300.0
            : 500.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (isAllowed) checkQrCodeAndMarkAttendance(scanData);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
