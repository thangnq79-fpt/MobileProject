import 'package:flutter/material.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/models/classinf.dart';

class ClassInfoScreenOnly extends StatefulWidget {
  final ClassInf classinf;
  const ClassInfoScreenOnly({Key key, @required this.classinf})
      : super(key: key);
  @override
  _ClassInfoScreenOnlyState createState() => _ClassInfoScreenOnlyState();
}

class _ClassInfoScreenOnlyState extends State<ClassInfoScreenOnly> {
  String scheduleText = "";
  List listSubject = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  List<String> listOfMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  String startDate1 = "";
  String startDate2 = "";
  String startDate = "";
  String startDatee() {
    final now = new DateTime.now();
    var dateint = int.parse(widget.classinf.startdate.substring(8, 10));
    String year = widget.classinf.startdate.substring(0, 4);
    var month = int.parse(widget.classinf.startdate.substring(5, 7));
    var date = widget.classinf.startdate.substring(8, 10);
    startDate1 = 'Will start  ' +
        listOfMonths[month - 1] +
        ' ' +
        date +
        ' ' +
        ", " +
        year;
    startDate2 = 'Already starts  ' +
        listOfMonths[month - 1] +
        ' ' +
        date +
        ' ' +
        ", " +
        year;

    now.month <= month
        ? (now.day < dateint ? startDate = startDate1 : startDate = startDate2)
        : startDate = startDate2;
    return startDate;
  }

  String scheduleTextt() {
    for (int i = 0; i < 7; i++) {
      if (widget.classinf.schedule[i] == true)
        scheduleText += (scheduleText == "" ? "" : ".") + listSubject[i];
    }
    scheduleText += " - " + widget.classinf.time;
    return scheduleText;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          body: SingleChildScrollView(
              child: Container(
                  //height: 120 * SizeConfig.heightMultiplier,
                  child: Column(children: [
            Container(
              height: 7 * SizeConfig.heightMultiplier,
              // width: 55.6 * SizeConfig.widthMultiplier,

              padding: EdgeInsets.only(
                  top: 2 * SizeConfig.heightMultiplier,
                  right: 28 * SizeConfig.widthMultiplier),
              child: Text(
                startDatee(),
                style: TextStyle(
                  color: Color(0xff181a54),
                  fontSize: 16,
                  fontFamily: 'SegoeUI',
                ),
              ),
            ),
            Container(
              width: 100 * SizeConfig.widthMultiplier,
              height: 4.6 * SizeConfig.heightMultiplier,
              child: Row(
                children: [
                  Container(
                    height: 2.4 * SizeConfig.heightMultiplier,
                    width: 8.3 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 5.6 * SizeConfig.widthMultiplier,
                    //margin: EdgeInsets.only(left: 8.3 * SizeConfig.widthMultiplier),
                    child: Icon(
                      Icons.school_outlined,
                      color: Colors.red,
                      size: 4 * SizeConfig.heightMultiplier,
                    ),
                  ),
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 3.9 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    width: 73.3 * SizeConfig.widthMultiplier,
                    height: 2.8 * SizeConfig.heightMultiplier,
                    // margin:
                    //     EdgeInsets.only(left: 17.8 * SizeConfig.widthMultiplier),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Created by',
                            style: TextStyle(
                              color: Color(0xff181a54),
                              fontSize: 16,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '  ',
                            style: TextStyle(
                              color: Color(0xff181a54),
                              fontSize: 16,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: widget.classinf.teachername,
                            style: TextStyle(
                              color: Color(0xff181a54),
                              fontSize: 16,
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        color: Color(0xff181a54),
                        fontSize: 16,
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 100 * SizeConfig.widthMultiplier,
              height: 4.6 * SizeConfig.heightMultiplier,
              child: Row(
                children: [
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 8.3 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 5.6 * SizeConfig.widthMultiplier,
                    //margin: EdgeInsets.only(left: 8.3 * SizeConfig.widthMultiplier),
                    child: Icon(
                      Icons.date_range_outlined,
                      color: Colors.red,
                      size: 4 * SizeConfig.heightMultiplier,
                    ),
                  ),
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 3.9 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    width: 73.3 * SizeConfig.widthMultiplier,
                    height: 2.8 * SizeConfig.heightMultiplier,
                    // margin:
                    //     EdgeInsets.only(left: 17.8 * SizeConfig.widthMultiplier),

                    child: Text(
                      //widget.classinf.schedule,
                      scheduleTextt(),
                      style: TextStyle(
                        color: Color(0xff181a54),
                        fontSize: 16,
                        fontFamily: 'SegoeUI',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 100 * SizeConfig.widthMultiplier,
              height: 4.6 * SizeConfig.heightMultiplier,
              child: Row(
                children: [
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 8.3 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 5.6 * SizeConfig.widthMultiplier,
                    //margin: EdgeInsets.only(left: 8.3 * SizeConfig.widthMultiplier),
                    child: Icon(
                      Icons.sell_outlined,
                      color: Colors.red,
                      size: 4 * SizeConfig.heightMultiplier,
                    ),
                  ),
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 3.9 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    width: 73.3 * SizeConfig.widthMultiplier,
                    height: 2.8 * SizeConfig.heightMultiplier,
                    // margin:
                    //     EdgeInsets.only(left: 17.8 * SizeConfig.widthMultiplier),
                    child: Text(
                      widget.classinf.fee + ' VND/month',
                      style: TextStyle(
                        color: Color(0xffef4874),
                        fontSize: 16,
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 100 * SizeConfig.widthMultiplier,
              height: 4.6 * SizeConfig.heightMultiplier,
              child: Row(
                children: [
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 8.3 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 5.6 * SizeConfig.widthMultiplier,
                    //margin: EdgeInsets.only(left: 8.3 * SizeConfig.widthMultiplier),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: Colors.red,
                      size: 4 * SizeConfig.heightMultiplier,
                    ),
                  ),
                  Container(
                    height: 2.6 * SizeConfig.heightMultiplier,
                    width: 3.9 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    width: 73.3 * SizeConfig.widthMultiplier,
                    height: 2.8 * SizeConfig.heightMultiplier,
                    // margin:
                    //     EdgeInsets.only(left: 17.8 * SizeConfig.widthMultiplier),
                    child: Text(
                      //'235 Tran Cao Van street, An Son ward',
                      widget.classinf.location,
                      style: TextStyle(
                        color: Color(0xff181a54),
                        fontSize: 16,
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 3.8 * SizeConfig.heightMultiplier,
            ),
            Row(
              children: [
                Container(
                  width: 8.3 * SizeConfig.widthMultiplier,
                ),
                Container(
                  // margin: EdgeInsets.only(left: 4.47 * SizeConfig.widthMultiplier),
                  child: Text(
                    'Feedback Rating',
                    style: TextStyle(
                      color: Color(0xff181a54),
                      fontSize: 16,
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1.98 * SizeConfig.heightMultiplier,
            ),
            Container(
              height: 4.6 * SizeConfig.heightMultiplier,
              child: Row(
                children: [
                  Container(
                    width: 8.3 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    child: Icon(
                      Icons.person,
                      color: Colors.red,
                      size: 4 * SizeConfig.heightMultiplier,
                    ),
                    height: 4.6 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xffe5e8fb),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(3.5),
                    ),
                  ),
                  Container(
                    width: 3.6 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    child: Center(
                      child: Icon(
                        Icons.star,
                        color: Colors.red,
                        size: 3.5 * SizeConfig.heightMultiplier,
                      ),
                    ),
                    height: 3.4 * SizeConfig.heightMultiplier,
                    width: 7 * SizeConfig.widthMultiplier,
                    // margin: EdgeInsets.only(
                    //   left: 48,
                    //   right: 48,
                    // ),
                    decoration: BoxDecoration(
                      color: Color(0xffc4c4c4),
                    ),
                  ),
                  Container(
                    width: 0.83 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    child: Center(
                      child: Icon(
                        Icons.star,
                        color: Colors.red,
                        size: 3.5 * SizeConfig.heightMultiplier,
                      ),
                    ),
                    height: 3.4 * SizeConfig.heightMultiplier,
                    width: 7 * SizeConfig.widthMultiplier,
                    // margin: EdgeInsets.only(
                    //   left: 48,
                    //   right: 48,
                    // ),
                    decoration: BoxDecoration(
                      color: Color(0xffc4c4c4),
                    ),
                  ),
                  Container(
                    width: 0.83 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    child: Center(
                      child: Icon(
                        Icons.star,
                        color: Colors.red,
                        size: 3.5 * SizeConfig.heightMultiplier,
                      ),
                    ),
                    height: 3.4 * SizeConfig.heightMultiplier,
                    width: 7 * SizeConfig.widthMultiplier,
                    // margin: EdgeInsets.only(
                    //   left: 48,
                    //   right: 48,
                    // ),
                    decoration: BoxDecoration(
                      color: Color(0xffc4c4c4),
                    ),
                  ),
                  Container(
                    width: 0.83 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    child: Center(
                      child: Icon(
                        Icons.star,
                        color: Colors.red,
                        size: 3.5 * SizeConfig.heightMultiplier,
                      ),
                    ),
                    height: 3.4 * SizeConfig.heightMultiplier,
                    width: 7 * SizeConfig.widthMultiplier,
                    // margin: EdgeInsets.only(
                    //   left: 48,
                    //   right: 48,
                    // ),
                    decoration: BoxDecoration(
                      color: Color(0xffc4c4c4),
                    ),
                  ),
                  Container(
                    width: 0.83 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    child: Center(
                      child: Icon(
                        Icons.star,
                        color: Colors.red,
                        size: 3.5 * SizeConfig.heightMultiplier,
                      ),
                    ),
                    height: 3.4 * SizeConfig.heightMultiplier,
                    width: 7 * SizeConfig.widthMultiplier,
                    // margin: EdgeInsets.only(
                    //   left: 48,
                    //   right: 48,
                    // ),
                    decoration: BoxDecoration(
                      color: Color(0xffc4c4c4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 2.6 * SizeConfig.heightMultiplier,
            ),
            Row(
              children: [
                Container(width: 8.3 * SizeConfig.widthMultiplier),
                Container(
                  height: (21 / 7.6) * SizeConfig.heightMultiplier,
                  //margin: EdgeInsets.only(left: 3.94 * SizeConfig.widthMultiplier),
                  child: Text(
                    'Comment',
                    style: TextStyle(
                      color: Color(0xff181a54),
                      fontSize: 16,
                      fontFamily: 'SegoeUI',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 3.4 * SizeConfig.heightMultiplier,
            ),
            Container(
              height: (35 / 7.6) * SizeConfig.heightMultiplier,
              child: Row(
                children: [
                  Container(
                    width: 8.3 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    height: (35 / 7.6) * SizeConfig.heightMultiplier,
                    width: (35 / 3.6) * SizeConfig.widthMultiplier,
                    child: Icon(Icons.person),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xffe5e8fb),
                        //width: 1 * SizeConfig.widthMultiplier,
                      ),
                      borderRadius: BorderRadius.circular(3.5),
                    ),
                  ),
                  Container(
                    width: 13 / 3.6 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    height: (30 / 7.6) * SizeConfig.heightMultiplier,
                    width: 250 / 3.6 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Color(0xffc4c4c4),
                        //width: 1 * SizeConfig.widthMultiplier,
                      ),
                      borderRadius: BorderRadius.circular(3.5),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 30 / 7.6 * SizeConfig.heightMultiplier,
            ),
            Container(
              child: Stack(
                children: [
                  Center(
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
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ),
                ],
              ),
              height: 32 / 7.6 * SizeConfig.heightMultiplier,
              width: 126 / 3.6 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                color: Color(0xfff74b46),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ]))),
        );
      });
    });
  }
}
