import 'package:flutter/material.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/views/classes_screen/attendance_screen_teacher.dart';

import 'package:tesma/views/classes_screen/qr_class.dart';
import 'package:tesma/views/main_screens/home_screen/class_info.dart';
import 'package:tesma/views/classes_screen/attendance_screen_forStudent.dart';
import 'package:tesma/views/classes_screen/uploadFile_screen.dart';
import 'package:tesma/models/classinf.dart';
import 'package:tesma/models/userinf.dart';

class TabControllerScreen extends StatefulWidget {
  final ClassInf classinf;
  final UserInf currentUser;
  const TabControllerScreen({Key key, this.classinf, this.currentUser})
      : super(key: key);
  @override
  _TabControllerScreenState createState() => _TabControllerScreenState();
}

class _TabControllerScreenState extends State<TabControllerScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget _getTabBar() {
    return TabBar(
      tabs: <Widget>[
        Container(
            height: 7 * SizeConfig.heightMultiplier,
            child: Tab(
                icon: Icon(Icons.sticky_note_2_outlined,
                    color: Colors.redAccent))),
        Container(
            height: 7 * SizeConfig.heightMultiplier,
            child: Tab(
                icon:
                    Icon(Icons.fit_screen_outlined, color: Colors.redAccent))),
        Container(
            height: 7 * SizeConfig.heightMultiplier,
            child: Tab(
                icon: Icon(Icons.library_add_check_outlined,
                    color: Colors.redAccent))),
        Container(
            height: 7 * SizeConfig.heightMultiplier,
            child: Tab(
                icon: Icon(Icons.library_books_outlined,
                    color: Colors.redAccent))),
      ],
      controller: tabController,
    );
  }

  Widget _getTabBarView(tabs) {
    return Container(
      height: 100 * SizeConfig.heightMultiplier,
      child: TabBarView(
        children: tabs,
        controller: tabController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          _getTabBar(),
          SingleChildScrollView(
            child: Container(
              child: _getTabBarView(
                <Widget>[
                  ClassInfoScreen(classinf: widget.classinf),
                  QrClass(
                    classinf: widget.classinf,
                    userType: widget.currentUser.userType,
                  ),
                  if (widget.currentUser.userType == 'student')
                    AttendanceScreenForStudent(
                      classinf: widget.classinf,
                      currentUserID: widget.currentUser.uid,
                    )
                  else
                    AttendanceScreenTeacher(classinf: widget.classinf),
                  UploadFileScreen(
                    classinf: widget.classinf,
                    userType: widget.currentUser.userType,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
