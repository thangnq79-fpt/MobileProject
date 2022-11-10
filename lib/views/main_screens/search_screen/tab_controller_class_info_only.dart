import 'package:flutter/material.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/models/classinf.dart';
import 'package:tesma/models/userinf.dart';
import 'package:tesma/views/main_screens/search_screen/class_info_only.dart';

class TabControllerOnlyClassInfo extends StatefulWidget {
  final ClassInf classinf;
  final UserInf currentUser;
  const TabControllerOnlyClassInfo({Key key, this.classinf, this.currentUser})
      : super(key: key);
  @override
  _TabControllerOnlyClassInfoState createState() =>
      _TabControllerOnlyClassInfoState();
}

class _TabControllerOnlyClassInfoState extends State<TabControllerOnlyClassInfo>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
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
                  ClassInfoScreenOnly(classinf: widget.classinf),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
