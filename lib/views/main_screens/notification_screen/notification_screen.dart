import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tesma/constants/color.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/models/firebase_database.dart';
//import 'package:tesma/models/userinf.dart';
//import 'package:tesma/views/main_screens/home_screen/main_class_info.dart';
import 'package:tesma/views/main_screens/notification_screen/notificationcard.dart';

class NotificationScreens extends StatefulWidget {
  final DocumentSnapshot userdata;
  const NotificationScreens({Key key, @required this.userdata})
      : super(key: key);
  @override
  _NotificationScreensState createState() => _NotificationScreensState();
}

class _NotificationScreensState extends State<NotificationScreens> {
  final scrollController = ScrollController();
  final controller = ScrollController();

  Future resultsLoaded;
  String errorMessage = '';
  int documentLimit = 6;
  bool hasNext = true;
  bool isFetching = false;
  List _allresultList = [];
  List _status = [];

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

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (hasNext) {
        getNotif();
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getNotif();
  }

  getNotif() async {
    if (isFetching) return;
    errorMessage = '';
    isFetching = true;
    try {
      var notif = FirebaseFirestore.instance
          .collection('notifications')
          .limit(documentLimit)
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .orderBy("datecreate", descending: true);
      final startAfter = _allresultList.isNotEmpty ? _allresultList.last : null;
      var data;
      if (startAfter == null) {
        data = await notif.get();
      } else {
        data = await notif.startAfterDocument(startAfter).get();
      }
      setState(() {
        _allresultList.addAll(data.docs);
        _status.addAll(List.filled(_allresultList.length, true));
      });
      if (data.docs.length < documentLimit) hasNext = false;
      print('get notification successful');
    } catch (error) {
      errorMessage = error.toString();
    }
    isFetching = false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 18 * SizeConfig.heightMultiplier,
                    padding: EdgeInsets.fromLTRB(
                        0, 6 * SizeConfig.heightMultiplier, 0, 0),
                    child: Text(
                      'Notifications',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SegoeUI',
                        color: Colors.black,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 82 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: darkPurpleColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Notif().deleteUser(
                                        FirebaseAuth.instance.currentUser.uid);
                                    setState(() {
                                      _allresultList = [];
                                      _status = [];
                                      //getNotif();
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              getbackgroudcolor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ))),
                                  child: Container(
                                      child: Center(
                                    child: Icon(
                                      Icons.backspace_outlined,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                  ))),
                              SizedBox(
                                width: 10.0,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Notif().markallread(
                                        FirebaseAuth.instance.currentUser.uid);
                                    setState(() {
                                      _status = List.filled(
                                          _allresultList.length, false);
                                      //getNotif();
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              getbackgroudcolor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ))),
                                  child: Container(
                                      child: Center(
                                          child: Icon(
                                    Icons.mark_as_unread,
                                    color: Colors.white,
                                    size: 25.0,
                                  )))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              controller: scrollController,
                              padding: EdgeInsets.only(
                                left: 5.5 * SizeConfig.widthMultiplier,
                                right: 5.5 * SizeConfig.widthMultiplier,
                                bottom: 3.5 * SizeConfig.widthMultiplier,
                              ),
                              itemCount: _allresultList.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index >= _allresultList.length) {
                                  if (hasNext && _allresultList.length > 0) {
                                    return Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else {
                                    if (index == 0) {
                                      return NotificationsEmpty();
                                    } else {
                                      return Text("");
                                    }
                                  }
                                } else {
                                  return GestureDetector(
                                    child: notifcard(context,
                                        _allresultList[index], _status[index]),
                                    onTap: () {
                                      setState(() {
                                        _status[index] = false;
                                      });
                                      Notif()
                                          .markread(_allresultList[index].id);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => MyClassPage(
                                      //           currentUser:
                                      //               UserInf.fromSnapshot(
                                      //                   widget.userdata),
                                      //           resultList:
                                      //               _allresultList[index])),
                                      // );
                                    },
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
      });
    });
  }
}

class NotificationsEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 235.0,
            width: 235.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: darkPurpleColor,
            ),
            child: Image.asset(
              'assets/image/paperplane.png',
            ),
          ),
          Container(
            height: 50,
            child: Text(
              'No notification found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SegoeUI',
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            child: Text(
              'You’re all caught up!\nCheck back later for new notifications',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SegoeUI',
                color: greyColor,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
