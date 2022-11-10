import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesma/constants/color.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/models/CheckBoxState.dart';
import 'package:tesma/models/classinf.dart';
import 'package:tesma/models/firebase_database.dart';
import 'package:tesma/models/userinf.dart';
import 'package:tesma/views/main_screens/home_screen/main_class_info.dart';
import 'package:tesma/views/main_screens/search_screen/classcard_info.dart';
import 'package:tesma/views/main_screens/search_screen/filter.dart';
import 'package:tesma/views/main_screens/search_screen/main_class_info.dart';

class Search extends StatefulWidget {
  final DocumentSnapshot userdata;
  const Search({Key key, @required this.userdata}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Color backgroudcolorenable(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return canary;
    }
    return canary;
  }

  Color backgroudcolordisabled(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return greyColor;
    }
    return greyColor;
  }

  String uid = FirebaseAuth.instance.currentUser.uid;
  Future resultsLoaded;
  TextEditingController searchController = TextEditingController();

  void reReder(int index) async {
    setState(() {
      // _resultsListClassInf[index].numberofstudents++;
      // _resultsListClassInf[index]
      //     .liststudent
      //     .add(FirebaseAuth.instance.currentUser.uid);
      _allresultListClassInf[_indexClassInf[index]].numberofstudents++;
      _allresultListClassInf[_indexClassInf[index]]
          .liststudent
          .add(FirebaseAuth.instance.currentUser.uid);
    });
  }

  final List<CheckBoxState> grade = [
    CheckBoxState(title: '10', value: true),
    CheckBoxState(title: '11', value: true),
    CheckBoxState(title: '12', value: true),
  ];

  final List<CheckBoxState> subject = [
    CheckBoxState(title: 'Math', value: true),
    CheckBoxState(title: 'English', value: true),
    CheckBoxState(title: 'Physics', value: true),
    CheckBoxState(title: 'Chemistry', value: true),
    CheckBoxState(title: 'Literature', value: true),
  ];

  final List<CheckBoxState> status = [
    CheckBoxState(title: 'Not start yet', value: true),
    CheckBoxState(title: 'Already started', value: true),
  ];
  final scrollController = ScrollController();
  final controller = ScrollController();

  String errorMessage = '';
  int documentLimit = 3;
  bool hasNext = true;
  bool isFetching = false;
  List _resultsList = [];
  List _resultsListClassInf = [];
  List _allresultListClassInf = [];
  List<int> _indexClassInf = [];
  List _allresultList = [];
  UserInf userinf;

  @override
  void initState() {
    super.initState();
    userinf = UserInf.fromSnapshot(widget.userdata);
    searchController.addListener(_onSearchChanged);
    scrollController.addListener(scrollListener);
  }

  _onSearchChanged() {
    searchResultsList();
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        searchController.text == '') {
      if (hasNext) {
        getClassInfor();
      }
    }
  }

  searchResultsListGrade() {
    var showResults = [];
    var showResultsClassInf = [];
    List<int> showResultsindex = [];
    int dem = 0;
    for (var Snapshot in _resultsList) {
      var gradeItem = ClassInf.fromSnapshot(Snapshot).grade.toLowerCase();
      for (var i = 0; i < 3; i++) {
        if (grade[i].value && gradeItem == grade[i].title.toLowerCase()) {
          showResults.add(Snapshot);
          showResultsClassInf.add(_resultsListClassInf[dem]);
          showResultsindex.add(_indexClassInf[dem]);
          break;
        }
      }
      ++dem;
    }
    setState(() {
      _resultsList = showResults;
      _resultsListClassInf = showResultsClassInf;
      _indexClassInf = showResultsindex;
    });
  }

  searchResultsListSubject() {
    var showResults = [];
    var showResultsClassInf = [];
    List<int> showResultsindex = [];
    int dem = 0;
    for (var Snapshot in _resultsList) {
      var subjectItem = ClassInf.fromSnapshot(Snapshot).subject.toLowerCase();
      for (var i = 0; i < 5; i++) {
        if (subject[i].value && subjectItem == subject[i].title.toLowerCase()) {
          showResults.add(Snapshot);
          showResultsClassInf.add(_resultsListClassInf[dem]);
          showResultsindex.add(_indexClassInf[dem]);
          break;
        }
      }
      ++dem;
    }
    setState(() {
      _resultsList = showResults;
      _resultsListClassInf = showResultsClassInf;
      _indexClassInf = showResultsindex;
    });
  }

  searchResultsListStatus() {
    var showResults = [];
    var showResultsClassInf = [];
    List<int> showResultsindex = [];
    int dem = 0;
    if (status[0].value == status[1].value) {
      showResults = List.from(_resultsList);
      showResultsClassInf = List.from(_resultsListClassInf);
      showResultsindex = List.from(_indexClassInf);
    } else {
      if (status[1].value) {
        for (var Snapshot in _resultsList) {
          var startDate = DateTime.parse(
              ClassInf.fromSnapshot(Snapshot).startdate.toLowerCase());
          if (DateTime.now().compareTo(startDate) >= 0) {
            showResults.add(Snapshot);
            showResultsClassInf.add(_resultsListClassInf[dem]);
            showResultsindex.add(_indexClassInf[dem]);
          }
          ++dem;
        }
      } else {
        for (var Snapshot in _resultsList) {
          var startDate = DateTime.parse(
              ClassInf.fromSnapshot(Snapshot).startdate.toLowerCase());
          if (DateTime.now().compareTo(startDate) < 0) {
            showResults.add(Snapshot);
            showResultsClassInf.add(_resultsListClassInf[dem]);
            showResultsindex.add(_indexClassInf[dem]);
          }
          ++dem;
        }
      }
    }
    setState(() {
      _resultsList = showResults;
      _resultsListClassInf = showResultsClassInf;
      _indexClassInf = showResultsindex;
    });
  }

  searchResultsListwithFilter() {
    searchResultsListGrade();
    searchResultsListSubject();
    searchResultsListStatus();
  }

  searchResultsList() {
    var showResults = [];
    var showResultsClassInf = [];
    List<int> showResultsindex = [];
    int dem = 0;
    if (searchController.text != "") {
      for (var Snapshot in _allresultList) {
        //print("Snapshot");
        //print(searchController.text.toLowerCase());
        var classname = ClassInf.fromSnapshot(Snapshot).classname.toLowerCase();
        //print(classname);
        if (classname.contains(searchController.text.toLowerCase())) {
          //print(classname);
          showResults.add(Snapshot);
          showResultsClassInf.add(_allresultListClassInf[dem]);
          showResultsindex.add(dem);
        }
        ++dem;
        print(dem);
      }
    } else {
      showResults = List.from(_allresultList);
      showResultsClassInf = List.from(_allresultListClassInf);
      showResultsindex =
          List<int>.generate(_allresultListClassInf.length, (i) => i++);
    }
    setState(() {
      _resultsList = showResults;
      _resultsListClassInf = showResultsClassInf;
      _indexClassInf = showResultsindex;
      //print(showResultsClassInf);

      //print(showResultsindex);
    });
    searchResultsListwithFilter();
    print(_indexClassInf);
    if (_resultsList.length < 3 && hasNext) getClassInfor();
    //print(hasNext);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getClassInfor();
  }

  getClassInfor() async {
    //if (isFetching) return;
    errorMessage = '';
    isFetching = true;
    try {
      var classes =
          FirebaseFirestore.instance.collection('classes').limit(documentLimit);
      final startAfter = _allresultList.isNotEmpty ? _allresultList.last : null;
      var data;
      if (startAfter == null) {
        data = await classes.get();
      } else {
        data = await classes.startAfterDocument(startAfter).get();
      }
      setState(() {
        _allresultList.addAll(data.docs);
        for (var Snapshot in data.docs) {
          _allresultListClassInf.add(ClassInf.fromSnapshot(Snapshot));
        }
      });
      if (data.docs.length < documentLimit)
        setState(() {
          hasNext = false;
        });
      searchResultsList();
      print('get class successful');
    } catch (error) {
      errorMessage = error.toString();
    }
    isFetching = false;
  }

  Widget enrollbtnenable(ClassInf classinf, int index) {
    return Container(
      alignment: Alignment.topLeft,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.fromLTRB(5.5 * SizeConfig.widthMultiplier, 0, 0, 10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith(backgroudcolorenable),
        ),
        onPressed: () {
          _enrollfucn(classinf, index);
        },
        child: Text(
          "Enroll",
          style: TextStyle(
            color: royalBlueColor,
            fontSize: 12,
            fontFamily: 'SegoeUI',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget enrollbtndisabled() {
    return Container(
      alignment: Alignment.topLeft,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.fromLTRB(5.5 * SizeConfig.widthMultiplier, 0, 0, 10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith(backgroudcolordisabled),
        ),
        onPressed: () {},
        child: Text(
          "Enroll",
          style: TextStyle(
            color: royalBlueColor,
            fontSize: 12,
            fontFamily: 'SegoeUI',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  void _enrollfucn(ClassInf classinf, int index) {
    //print(_isButtonDisabled);
    try {
      ClassInfor().enroll(classinf.classid, uid);
      Notif().createNotif(
          'You have successfully enrolled in class: ' + classinf.classname,
          'You have successfully enrolled in class: ' + classinf.classname,
          'class',
          uid,
          DateTime.now());
      setState(() {
        reReder(index);
      });
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          color: darkPurpleColor,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 18 * SizeConfig.heightMultiplier,
                padding: EdgeInsets.fromLTRB(
                    3 * SizeConfig.heightMultiplier,
                    1 * SizeConfig.heightMultiplier,
                    3 * SizeConfig.heightMultiplier,
                    0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Search",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SegoeUI',
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Filter(
                                  grade: grade,
                                  subject: subject,
                                  status: status,
                                );
                              }).then((value) => {
                                setState(() {
                                  //print(value);
                                  searchResultsList();
                                })
                              });
                        },
                        child: Icon(Icons.filter_alt),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 82 * SizeConfig.heightMultiplier,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: lightPurpleColor,
                ),
                child: Column(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                      child: Container(
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
                    ),
                    Expanded(
                      child: ListView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.only(
                            bottom: 3.5 * SizeConfig.widthMultiplier,
                          ),
                          itemCount: _resultsList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index >= _resultsList.length) {
                              if (hasNext && _resultsList.length > 3) {
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
                              //print(_resultsList.length);
                              //print(_resultsList[index].data()['numberofstudents']);
                              return GestureDetector(
                                child: Container(
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
                                  child: Column(
                                    children: [
                                      classCard(
                                          context, _resultsListClassInf[index]
                                          // documentclass: _resultsList[index],
                                          // documentuser: widget.userdata,
                                          ),
                                      if (userinf.userType == "student")
                                        (_resultsListClassInf[index]
                                                    .liststudent
                                                    .contains(uid) ||
                                                _resultsListClassInf[index]
                                                        .numberofstudents ==
                                                    _resultsListClassInf[index]
                                                        .maxstudents)
                                            ? enrollbtndisabled()
                                            : enrollbtnenable(
                                                _resultsListClassInf[index],
                                                index),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  (_resultsListClassInf[index]
                                              .liststudent
                                              .contains(uid) ||
                                          _resultsListClassInf[index].hostID ==
                                              uid)
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyClassPage(
                                                    currentUser:
                                                        UserInf.fromSnapshot(
                                                            widget.userdata),
                                                    resultList:
                                                        _resultsList[index],
                                                  )),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyClassPageOnlyClassInfo(
                                                    currentUser:
                                                        UserInf.fromSnapshot(
                                                            widget.userdata),
                                                    resultList:
                                                        _resultsList[index],
                                                  )),
                                        );
                                },
                              );
                            }
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
