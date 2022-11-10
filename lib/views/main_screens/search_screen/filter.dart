import 'package:flutter/material.dart';
import 'package:tesma/constants/color.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/models/CheckBoxState.dart';

// ignore: must_be_immutable
class Filter extends StatefulWidget {
  Filter({
    Key key,
    @required this.grade,
    @required this.subject,
    @required this.status,
  }) : super(key: key);

  List<CheckBoxState> grade;
  List<CheckBoxState> subject;
  List<CheckBoxState> status;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  Color getbackgroudcolor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return mediumPink;
    }
    return mediumPink;
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
            color: royalBlueColor,
            fontSize: 16,
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
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                children: [
                  Text(
                    "GRADE",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'SegoeUI',
                      color: royalBlueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ...widget.grade.map(buildSingleCheckbox).toList(),
                  Text(
                    "SUBJECT",
                    style: TextStyle(
                      fontFamily: 'SegoeUI',
                      color: royalBlueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ...widget.subject.map(buildSingleCheckbox).toList(),
                  Text(
                    "STATUS",
                    style: TextStyle(
                      fontFamily: 'SegoeUI',
                      color: royalBlueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ...widget.status.map(buildSingleCheckbox).toList(),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            getbackgroudcolor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))),
                    onPressed: () {
                      //ClassInfor().searchClass();
                      Navigator.pop(context, "Filter Successful");
                    },
                    child: Container(
                      width: 115,
                      height: 25,
                      child: Center(
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
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
