import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:tesma/constants/color.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import '../../models/CheckBoxState.dart';
import 'package:tesma/models/firebase_database.dart';

//ignore: must_be_immutable
class InputClassScreen extends StatefulWidget {
  InputClassScreen(this.rendering);

  @override
  _InputClassScreen createState() {
    return _InputClassScreen();
  }

  Function rendering;
}

class _InputClassScreen extends State<InputClassScreen> {
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController maxstudentsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isFilledInAll = false;
  String isErrorFromServe = "";

  Map<String, dynamic> newClass = {};

  DateTime startDate = DateTime.now();
  int numberOfStudents = 0;
  int maxStudent = 15;

  final List<CheckBoxState> dayOfWeek = [
    CheckBoxState(title: 'Monday'),
    CheckBoxState(title: 'Tuesday'),
    CheckBoxState(title: 'Wednesday'),
    CheckBoxState(title: 'Thursday'),
    CheckBoxState(title: 'Friday'),
    CheckBoxState(title: 'Saturday'),
    CheckBoxState(title: 'Sunday'),
  ];

  String valueChooseSubject;
  List listSubject = ["Math", "English", "Literature", "Physics", "Chemistry"];
  String valueChooseGrade;
  List listGrade = ["10", "11", "12"];
  String valueChooseHour;
  List listHour = [
    "00",
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23"
  ];
  String valueChooseMinute;
  List listMinute = [
    "00",
    "01",
    "02",
    "03",
    "04",
    "05",
    "06",
    "07",
    "08",
    "09",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31",
    "32",
    "33",
    "34",
    "35",
    "36",
    "37",
    "38",
    "39",
    "40",
    "41",
    "42",
    "43",
    "44",
    "45",
    "46",
    "47",
    "48",
    "49",
    "50",
    "51",
    "52",
    "53",
    "54",
    "55",
    "56",
    "57",
    "58",
    "59"
  ];

  String getStartDate() {
    if (startDate == null) {
      return 'Date';
    } else {
      return '${startDate.day}/${startDate.month}/${startDate.year}';
    }
  }

  Future pickStartDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => startDate = newDate);
  }

  void _showToast(String context) {
    Fluttertoast.showToast(
      msg: context,
      backgroundColor: redColor,
      textColor: whiteColor,
      gravity: ToastGravity.CENTER,
    );
  }

  Widget buildCheckbox({
    @required CheckBoxState notification,
    @required VoidCallback onClicked,
  }) =>
      ListTile(
        onTap: onClicked,
        leading: Checkbox(
          value: notification.value,
          onChanged: (value) => onClicked(),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontFamily: 'SegoeUI',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget buildSingleCheckbox(CheckBoxState notification) => buildCheckbox(
        notification: notification,
        onClicked: () {
          setState(() {
            final newValue = !notification.value;
            notification.value = newValue;
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    Future<void> classSetup(
        String classname,
        String subject,
        String grade,
        String startdate,
        String time,
        String location,
        String fee,
        int numberofstudents,
        String maxstudents,
        List<CheckBoxState> dayofweek) async {
      int students = int.parse(maxstudents);
      CollectionReference classes =
          FirebaseFirestore.instance.collection('classes');
      DateTime createdate = DateTime.now();
      List<bool> schedule = dayofweek.map((element) => element.value).toList();
      String hostID = FirebaseAuth.instance.currentUser.uid;
      final currentUser =
          FirebaseFirestore.instance.collection('users').doc(hostID);
      var datauser = await currentUser.get();
      classes.add({
        'className': classname,
        'subject': subject,
        'grade': grade,
        'time': time,
        'createDate': createdate,
        'start': startdate,
        'dayofweek': schedule,
        'location': location,
        'fee': fee,
        'hostID': hostID,
        'numberofstudents': numberofstudents,
        'maxstudents': students,
        'teachername': datauser.data()['userName'],
      }).then((value) {
        currentUser.get().then((userSnapShot) {
          List<dynamic> listClass = [];
          if (userSnapShot.data().containsKey('listClass')) {
            listClass = userSnapShot.data()['listClass'];
            listClass.add(value.id);
            currentUser.update({'listClass': listClass});
          } else {
            listClass.add(value.id);
            currentUser.update({'listClass': listClass});
          }
        });
      }).then((value) {
        newClass = {
          'className': classname,
          'subject': subject,
          'grade': grade,
          'time': time,
          'createDate': createdate,
          'start': startdate,
          'dayofweek': schedule,
          'location': location,
          'fee': fee,
          'hostID': hostID,
          'numberofstudents': numberofstudents,
          'maxstudents': students,
        };
        Notif().createNotif(
            'You have successfully created a new class: ' + classname,
            'You have successfully created a new class  ' + classname,
            'class',
            hostID,
            createdate);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Create class successfully"),
                actions: <Widget>[
                  Container(
                      child: Center(
                    child: FloatingActionButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ))
                ],
              );
            });
        widget.rendering(newClass);
      }).onError((error, stackTrace) {
        print(error.code);
      });
      return;
    }

    bool isSchedule(List<CheckBoxState> schedule) {
      if (schedule.map((element) => element.value).contains(true)) {
        return true;
      }
      return false;
    }

    bool isFee(String fee) {
      if (fee == null) {
        return false;
      }
      return int.tryParse(fee) != null;
    }

    Future<void> createClassOnServe() async {
      try {
        await Firebase.initializeApp();
        bool isNewClass =
            await ClassInfor().isNewClass(classNameController.text.toString());
        if (isNewClass) {
          await classSetup(
            classNameController.text,
            valueChooseSubject,
            valueChooseGrade,
            startDate.toString(),
            valueChooseHour + ":" + valueChooseMinute,
            locationController.text,
            feeController.text,
            numberOfStudents,
            maxstudentsController.text,
            dayOfWeek,
          );
        } else
          _showToast('Class name đã bị trùng');
      } on FirebaseAuthException catch (e) {
        print(e.code);
      } catch (e) {
        print(e.toString());
      }
    }

    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: new CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
              child: Container(
                  padding: EdgeInsets.all(4 * SizeConfig.heightMultiplier),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Create class',
                            style: TextStyle(
                              color: darkPurpleColor,
                              fontSize: 40,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          height: 10 * SizeConfig.heightMultiplier,
                        ),
                      ]),
                      Container(
                        child: Text(
                          'CLASS NAME',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      Container(
                        height: 5 * SizeConfig.heightMultiplier,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: TextField(
                            controller: classNameController,
                            decoration: new InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              0,
                              2 * SizeConfig.heightMultiplier,
                              0,
                              1 * SizeConfig.heightMultiplier),
                          child: Container(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 5, right: 10),
                                    child: Text(
                                      'SUBJECT',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 10),
                                    child: Text(
                                      'GRADE',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'SegoeUI',
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ]))),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              0, 0, 0, 1 * SizeConfig.heightMultiplier),
                          child: Container(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 3, right: 30),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 5 * SizeConfig.heightMultiplier,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButton(
                                        hint: Text("Subject"),
                                        icon: Icon(Icons.arrow_drop_down_sharp),
                                        iconSize: 35,
                                        underline: SizedBox(),
                                        value: valueChooseSubject,
                                        onChanged: (newValue) {
                                          setState(() {
                                            valueChooseSubject = newValue;
                                          });
                                        },
                                        items: listSubject.map((valueItem) {
                                          return DropdownMenuItem(
                                            value: valueItem,
                                            child: Text(valueItem),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 50),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 5 * SizeConfig.heightMultiplier,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButton(
                                        hint: Text("Grade"),
                                        icon: Icon(Icons.arrow_drop_down_sharp),
                                        iconSize: 35,
                                        underline: SizedBox(),
                                        value: valueChooseGrade,
                                        onChanged: (newValue) {
                                          setState(() {
                                            valueChooseGrade = newValue;
                                          });
                                        },
                                        items: listGrade.map((valueItem) {
                                          return DropdownMenuItem(
                                            value: valueItem,
                                            child: Text(valueItem),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ]))),
                      Container(
                        child: Text(
                          "SCHEDULE",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'SegoeUI',
                            color: Color(0xff000000),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        height: 245,
                        child: GridView.extent(
                          padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 3,
                          primary: false,
                          maxCrossAxisExtent: 190,
                          children: dayOfWeek.map(buildSingleCheckbox).toList(),
                        ),
                      ),
                      Container(
                          child: Container(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  'TIME',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'SegoeUI',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 10),
                                child: Text(
                                  'FEE',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'SegoeUI',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ]))),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            2 * SizeConfig.heightMultiplier,
                            0,
                            2 * SizeConfig.heightMultiplier),
                        child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 3),
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      height: 5 * SizeConfig.heightMultiplier,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButton(
                                        hint: Text("__"),
                                        icon: Icon(Icons.arrow_drop_down_sharp),
                                        iconSize: 35,
                                        underline: SizedBox(),
                                        value: valueChooseHour,
                                        onChanged: (newValue) {
                                          setState(() {
                                            valueChooseHour = newValue;
                                          });
                                        },
                                        items: listHour.map((valueItem) {
                                          return DropdownMenuItem(
                                            value: valueItem,
                                            child: Text(valueItem),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 23),
                                    child: Container(
                                      height: 5 * SizeConfig.heightMultiplier,
                                      alignment: Alignment.centerRight,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButton(
                                        hint: Text("__"),
                                        icon: Icon(Icons.arrow_drop_down_sharp),
                                        iconSize: 35,
                                        underline: SizedBox(),
                                        value: valueChooseMinute,
                                        onChanged: (newValue) {
                                          setState(() {
                                            valueChooseMinute = newValue;
                                          });
                                        },
                                        items: listMinute.map((valueItem) {
                                          return DropdownMenuItem(
                                            value: valueItem,
                                            child: Text(valueItem),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: 5 * SizeConfig.heightMultiplier,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 2),
                                      child: TextField(
                                        controller: feeController,
                                        decoration: new InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      Container(
                          child: Container(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Text(
                                'START DATE',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'SegoeUI',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 10),
                                child: Text(
                                  'STUDENTS',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'SegoeUI',
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ]))),
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              0,
                              2 * SizeConfig.heightMultiplier,
                              0,
                              3 * SizeConfig.heightMultiplier),
                          child: Container(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: 5 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ElevatedButton.icon(
                                        onPressed: () => pickStartDate(context),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        icon: Icon(
                                          Icons.date_range_sharp,
                                          color: Colors.blue,
                                        ),
                                        label: Text(
                                          getStartDate(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontFamily: 'SegoeUI',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 40),
                                    child: Container(
                                      height: 5 * SizeConfig.heightMultiplier,
                                      child: NumberInputWithIncrementDecrement(
                                        controller: maxstudentsController,
                                        initialValue: maxStudent,
                                        min: 0,
                                        max: 100,
                                        incIconSize: 27,
                                        decIconSize: 27,
                                        buttonArrangement:
                                            ButtonArrangement.incRightDecLeft,
                                        onChanged: (value) => setState(() {
                                          maxStudent = value;
                                        }),
                                      ),
                                    ),
                                  ),
                                )
                              ]))),
                      Container(
                        child: Text(
                          'LOCATION',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            2 * SizeConfig.heightMultiplier,
                            0,
                            1 * SizeConfig.heightMultiplier),
                        child: Container(
                          height: 5 * SizeConfig.heightMultiplier,
                          child: TextField(
                            controller: locationController,
                            decoration: new InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.all(2 * SizeConfig.heightMultiplier),
                        child: Container(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 2),
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.deepOrange,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                      child: Container(
                                        child: Center(
                                          child: Text(
                                            'Cancel',
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
                                Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 2),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (classNameController.text == "" ||
                                              feeController.text == "" ||
                                              locationController.text == "" ||
                                              valueChooseSubject == null ||
                                              valueChooseGrade == null ||
                                              valueChooseMinute == null ||
                                              valueChooseHour == null) {
                                            isFilledInAll = false;
                                          } else {
                                            isFilledInAll = true;
                                          }
                                          if (!isFilledInAll) {
                                            _showToast(
                                                'Bạn chưa điền đầy đủ thông tin');
                                          } else if (!isFee(
                                              feeController.text)) {
                                            _showToast(
                                                'Nhập học phí không chính xác');
                                          } else if (!isSchedule(dayOfWeek)) {
                                            _showToast(
                                                'Vui lòng chọn lịch học');
                                          } else {
                                            isErrorFromServe = "";
                                            createClassOnServe();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.pink,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              'Create',
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
                                    )),
                              ]),
                        ),
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
