import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tesma/constants/color.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/models/classinf.dart';
import 'package:tesma/models/firebase_database.dart';
import 'package:tesma/constants/datetime.dart';
import 'package:tesma/views/classes_screen/attendance_screen_forStudent.dart';

class AttendanceScreenTeacher extends StatefulWidget {
  final ClassInf classinf;
  const AttendanceScreenTeacher({Key key, @required this.classinf})
      : super(key: key);
  @override
  _AttendanceScreenTeacherState createState() =>
      _AttendanceScreenTeacherState();
}

class _AttendanceScreenTeacherState extends State<AttendanceScreenTeacher> {
  @override
  void initState() {
    super.initState();
    startDate = new DateTime.utc(
        int.parse(widget.classinf.startdate.substring(0, 4)),
        int.parse(widget.classinf.startdate.substring(5, 7)),
        int.parse(widget.classinf.startdate.substring(8, 10)));
    print(widget.classinf.classid);
    _classesStream = FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.classinf.classid)
        .snapshots();
    //print('lastday = ' + widget.classinf.lastday.toString());
    if ((widget.classinf.lastday == null) ||
        (!widget.classinf.lastday.isSameDate(DateTime.now()) &&
            widget.classinf.lastday.isBefore(DateTime.now()))) {
      ClassInfor().resetday(widget.classinf.classid, uid);
      widget.classinf.lastday = DateTime.now();
    }
    iscurrentlesson();
    print(currentlesson);
  }

  bool currentlesson = false;

  void iscurrentlesson() {
    final now = new DateTime.now();
    int currentday = now.weekday - 1;
    currentlesson = widget.classinf.schedule[currentday % 7];
  }

  String getNumOfAbsences(int timeOfALesson, List attendenceList) {
    if (startDate.compareTo(now) == 1) return '0';
    // get number of attendances
    int numOfAttendances = 0;
    if (attendenceList != null) numOfAttendances = attendenceList.length;
    // get number of learning days each week
    int learningDaysInWeek = 0;
    for (int i = 0; i < 7; i++)
      if (widget.classinf.schedule[i]) learningDaysInWeek++;
    // get number of lessons passed
    int numOfDayPassed = now.difference(startDate).inDays;
    int numOfLesson = (numOfDayPassed ~/ 7) * learningDaysInWeek;
    int firstLesson = startDate.weekday;
    for (int i = 0; i < numOfDayPassed % 7; i++)
      if (widget.classinf.schedule[(i + firstLesson - 1) % 7]) numOfLesson++;
    // check: is lesson today?
    int nowInMinutes = now.hour * 60 + now.minute;
    int startTimeInMinutes =
        int.parse(widget.classinf.time.substring(0, 2)) * 60 +
            int.parse(widget.classinf.time.substring(3, 5));
    if (nowInMinutes - startTimeInMinutes >= timeOfALesson &&
        widget.classinf.schedule[now.weekday - 1]) numOfLesson++;
    // return
    return (numOfLesson - numOfAttendances).toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showToast(String context) {
    Fluttertoast.showToast(
      msg: context,
      backgroundColor: redColor,
      textColor: whiteColor,
      gravity: ToastGravity.CENTER,
    );
  }

  final now = new DateTime.now();
  DateTime startDate;
  String uid = FirebaseAuth.instance.currentUser.uid;
  Stream<DocumentSnapshot> _classesStream;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Container(
          height: 61.1 * SizeConfig.heightMultiplier,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.fromLTRB(25, 10, 25, 25),
          child: Column(
            children: [
              Container(
                height: 6.58 * SizeConfig.heightMultiplier,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      labelStyle: TextStyle(
                        height: 6.58 * SizeConfig.heightMultiplier,
                        fontFamily: 'SegoeUI',
                        color: greyColor,
                        fontSize: 2.10 * SizeConfig.textMultiplier,
                      ),
                      border: OutlineInputBorder(),
                      counterText: "",
                      hintText: 'Enter a name',
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
              Container(
                height: 36 * SizeConfig.heightMultiplier,
                margin: EdgeInsets.only(
                  top: 3 * SizeConfig.heightMultiplier,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: _classesStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }
                      return ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: snapshot.data.data()['numberofstudents'],
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AttendanceScreenForStudent(
                                            classinf: widget.classinf,
                                            currentUserID: snapshot.data
                                                .data()['liststudent'][index]),
                                  ),
                                );
                              },
                              child: Container(
                                height: 6 * SizeConfig.heightMultiplier,
                                margin: EdgeInsets.only(
                                  top: 2 * SizeConfig.heightMultiplier,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('classes')
                                        .doc(widget.classinf.classid)
                                        .collection('schedule')
                                        .doc(snapshot.data.data()['liststudent']
                                            [index])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshotschedule) {
                                      if (snapshotschedule.data != null)
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 2 *
                                                    SizeConfig.widthMultiplier,
                                                right: 2 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    getNumOfAbsences(
                                                        90,
                                                        snapshotschedule.data
                                                                .data()[
                                                            'attendance']),
                                                    style: TextStyle(
                                                      color: Color(0xffef4874),
                                                      fontSize: 16,
                                                      fontFamily: 'SegoeUI',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Absence',
                                                    style: TextStyle(
                                                      color: Color(0xff181a54),
                                                      fontSize: 8,
                                                      fontFamily: 'SegoeUI',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 2 *
                                                    SizeConfig.widthMultiplier,
                                                right: 2 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                snapshot.data
                                                    .data()['liststudentname']
                                                        [index]
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Color(0xff181a54),
                                                  fontFamily: 'SegoeUI',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            (snapshotschedule.data
                                                    .data()['today'])
                                                ? GestureDetector(
                                                    onTap: () {
                                                      if (currentlesson)
                                                        ClassInfor()
                                                            .changestatustoday(
                                                                snapshot
                                                                    .data.id,
                                                                snapshotschedule
                                                                    .data.id,
                                                                true);
                                                      else
                                                        _showToast(
                                                            'No class today');
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 0),
                                                      width: 5 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      height: 5 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      padding:
                                                          EdgeInsets.all(3.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                            color:
                                                                lightGreenColor,
                                                          )),
                                                      child: Icon(Icons.done),
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      if (currentlesson)
                                                        ClassInfor()
                                                            .changestatustoday(
                                                                snapshot
                                                                    .data.id,
                                                                snapshotschedule
                                                                    .data.id,
                                                                true);
                                                      else
                                                        _showToast(
                                                            'No class today');
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 0),
                                                      width: 5 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      height: 5 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      padding:
                                                          EdgeInsets.all(3.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                            color: redColor,
                                                          )),
                                                      child: Icon(Icons.clear),
                                                    ),
                                                  ),
                                          ],
                                        );
                                      else
                                        return Center(
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                    }),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3f000000),
                                      offset: Offset(0.25, 1.75),
                                      blurRadius: 1,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 5 * SizeConfig.heightMultiplier,
                ),
                height: 4.1 * SizeConfig.heightMultiplier,
                width: 35 * SizeConfig.widthMultiplier,
                child: InkWell(
                  child: Container(
                    height: 4.1 * SizeConfig.heightMultiplier,
                    width: 35 * SizeConfig.widthMultiplier,
                    alignment: Alignment.center,
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                decoration: BoxDecoration(
                  color: redColor,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
