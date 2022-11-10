import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tesma/models/classinf.dart';
import 'package:tesma/models/userinf.dart';
import 'package:tesma/views/classes_screen/InputClass_screen.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/views/main_screens/home_screen/main_class_info.dart';
import '../home_screen/single_class.dart';

class HomeScreen extends StatefulWidget {
  final DocumentSnapshot userdata;
  const HomeScreen({Key key, @required this.userdata}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
    userinf = UserInf.fromSnapshot(widget.userdata);
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (hasNext) {
        getClassInfor();
      }
    }
  }

  int documentLimit = 3;
  UserInf userinf;
  Future resultsLoaded;
  bool hasNext = true;
  List _allresultList = [];
  List listClass = [];
  List<dynamic> listClasses = [];
  void reRender(Map<String, dynamic> classItem) {
    List<Widget> temp = listClass;

    setState(() {
      listClass = temp;
    });
    print(listClass);
  }

  Positioned createClass() {
    return Positioned(
      height: 4.2 * SizeConfig.heightMultiplier,
      top: 13.9 * SizeConfig.heightMultiplier,
      right: 11.4 * SizeConfig.widthMultiplier,
      child: Container(
        alignment: Alignment.center,
        width: 36 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
          color: Color(0xffef4874),
          borderRadius: BorderRadius.circular(35),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return InputClassScreen(reRender);
                },
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New Class',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'SegoeUI',
                  fontWeight: FontWeight.w900,
                ),
              ),
              Icon(
                Icons.add,
                color: Colors.white,
                size: 4 * SizeConfig.heightMultiplier,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getClassInfor();
  }

  getClassInfor() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userinf.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        listClasses = documentSnapshot.data()['listClass'];
      });
    });
    if (listClasses != null) {
      var data = await FirebaseFirestore.instance
          .collection('classes')
          .where(FieldPath.documentId, whereIn: listClasses)
          .get();
      setState(() {
        _allresultList.addAll(data.docs);
        for (var Snapshot in data.docs) {
          _allresultList.add(ClassInf.fromSnapshot(Snapshot));
        }
      });
      if (data.docs.length < documentLimit)
        setState(() {
          hasNext = false;
        });
    }
  }

  Color getbackgroudcolor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Color(0xff7243cf);
    }
    return (Colors.orangeAccent);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return Scaffold(
              body: Container(
                color: Color(0xff45228b),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 4.5 * SizeConfig.heightMultiplier),
                      decoration: BoxDecoration(
                        color: Color(0xff181a54),
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(35)),
                      ),
                      height: 83 * SizeConfig.heightMultiplier,
                      margin: EdgeInsets.only(
                          top: 16 * SizeConfig.heightMultiplier),
                      child: ListView.builder(
                          padding: EdgeInsets.only(
                            left: 11.4 * SizeConfig.widthMultiplier,
                            right: 11.4 * SizeConfig.widthMultiplier,
                          ),
                          itemCount: _allresultList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index >= _allresultList.length) {
                              if (hasNext && _allresultList.length > 3) {
                                return Center(
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else {
                                return Center(
                                    child: Text(
                                  'No more Result',
                                  style: TextStyle(color: Colors.white),
                                ));
                              }
                            } else {
                              return GestureDetector(
                                child:
                                    singleClass(context, _allresultList[index]),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyClassPage(
                                              resultList: _allresultList[index],
                                              currentUser: userinf,
                                            )),
                                  );
                                },
                              );
                            }
                            //children: listClass,
                            // children: [
                            //   singleClass(),
                            //   singleClass(),
                            //   singleClass(),
                            //   singleClass(),
                            // ],
                          }),
                    ),
                    Positioned(
                      height: 4.2 * SizeConfig.heightMultiplier,
                      top: 13.9 * SizeConfig.heightMultiplier,
                      left: 11.4 * SizeConfig.widthMultiplier,
                      child: Container(
                        width: 36 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          color: Color(0xff181a54),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Center(
                          child: Text(
                            'My Class',
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
                    if (userinf.userType == 'teacher') createClass(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
