import 'package:flutter/material.dart';
import 'package:tesma/constants/color.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/models/classinf.dart';

Widget classCard(BuildContext context, ClassInf classinf) {
  //final classinf = ClassInf.fromSnapshot(document);
  String studentsText = " " +
      classinf.numberofstudents.toString() +
      "/" +
      classinf.maxstudents.toString();

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
          height: 10.5 * SizeConfig.heightMultiplier,
        ),
        Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    left: 5.5 * SizeConfig.widthMultiplier,
                    right: 5.5 * SizeConfig.widthMultiplier,
                    top: 2.5 * SizeConfig.widthMultiplier),
                child: Text(
                  classinf.classname,
                  style: TextStyle(
                    color: royalBlueColor,
                    fontSize: 24,
                    fontFamily: 'SegoeUIB',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 5.5 * SizeConfig.widthMultiplier,
                  right: 5.5 * SizeConfig.widthMultiplier,
                  bottom: 1 * SizeConfig.widthMultiplier,
                  top: 1 * SizeConfig.widthMultiplier,
                ),
                child: Row(
                  children: [
                    Text(
                      "Created by ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'SegoeUI',
                      ),
                    ),
                    Text(
                      classinf.teachername,
                      style: TextStyle(
                        color: mediumPink,
                        fontSize: 12,
                        fontFamily: 'SegoeUI',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 1.5 * SizeConfig.widthMultiplier,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 5.5 * SizeConfig.widthMultiplier,
                        right: 5.5 * SizeConfig.widthMultiplier,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Start " + classinf.startdate,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'SegoeUI',
                        ),
                      ),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Icons.supervised_user_circle),
                        Text(
                          studentsText,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'SegoeUI',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    //height: 25 * SizeConfig.heightMultiplier,
    //width: 77.2 * SizeConfig.widthMultiplier,
  );
}
