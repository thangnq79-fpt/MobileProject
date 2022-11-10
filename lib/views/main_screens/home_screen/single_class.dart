import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tesma/constants/color.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/models/classinf.dart';

Widget singleClass(BuildContext context, DocumentSnapshot document) {
  final classinf = ClassInf.fromSnapshot(document);
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
  String scheduleText = "";
  String lesson = "";

  String scheduleTextt() {
    for (int i = 0; i < 7; i++) {
      if (classinf.schedule[i] == true)
        scheduleText += (scheduleText == "" ? "" : ".") + listSubject[i];
    }
    scheduleText += " - " + classinf.time;
    return scheduleText;
  }

  String nextlesson() {
    final now = new DateTime.now();
    int count = 0;
    int nextday = now.weekday - 1;
    if ((now.hour.toString() + ":" + now.minute.toString())
            .compareTo(classinf.time) ==
        1) {
      nextday = (nextday + 1) % 7;
      count++;
    }
    while (classinf.schedule[nextday % 7] == false) {
      nextday = (nextday + 1) % 7;
      count++;
    }

    var dayoption = DateTime.now().add(new Duration(days: count));
    lesson = listSubject[nextday] +
        ", " +
        dayoption.day.toString() +
        " " +
        listOfMonths[dayoption.month - 1] +
        ", " +
        dayoption.year.toString();

    return lesson;
  }

  return Container(
    child: Column(
      children: [
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
          height: 12.5 * SizeConfig.heightMultiplier,
          //width: 77.2 * SizeConfig.widthMultiplier,
        ),
        Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: 8.5 * SizeConfig.widthMultiplier,
                    top: 1.3 * SizeConfig.heightMultiplier),
                alignment: Alignment.centerLeft,
                child: Text(
                  scheduleTextt(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'SegoeUI',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  left: 8.5 * SizeConfig.widthMultiplier,
                  right: 8.5 * SizeConfig.widthMultiplier,
                  //top: 2.5 * SizeConfig.widthMultiplier
                ),
                child: Text(
                  // (classinf.classname.length > 22)
                  //     ? classinf.classname.substring(0, 19) + "..."
                  //     : classinf.classname,
                  classinf.classname,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: royalBlueColor,
                    fontSize: 24,
                    fontFamily: 'SegoeUIB',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: 8.5 * SizeConfig.widthMultiplier,
                    ),
                    child: Text(
                      'Next lesson:',
                      style: TextStyle(
                        color: Color(0xffef4874),
                        fontSize: 8,
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 1.84 * SizeConfig.widthMultiplier),
                    child: Text(
                      nextlesson(),
                      style: TextStyle(
                        color: Color(0xffef4874),
                        fontSize: 8,
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    padding: EdgeInsets.only(
      bottom: 1.5 * SizeConfig.heightMultiplier,
    ),
    //height: 25 * SizeConfig.heightMultiplier,
    width: 77.2 * SizeConfig.widthMultiplier,
    margin: EdgeInsets.only(
      bottom: 1.5 * SizeConfig.heightMultiplier,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Color(0x3f000000),
          offset: Offset(0, 4),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ],
    ),
  );
}
