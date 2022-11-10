import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tesma/views/main_screens/notification_screen/notification_screen.dart';
import 'package:tesma/views/main_screens/user_profile_screen/user_profile_screen.dart';
import 'package:tesma/views/main_screens/qr_scan_screen/qr_scan_screen.dart';
import 'package:tesma/views/main_screens/search_screen/search_screen.dart';
import './home_screen/home_screen.dart';

class MyHomePage extends StatefulWidget {
  final DocumentSnapshot userdata;
  const MyHomePage({Key key, @required this.userdata}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
    //print(data.data());
    _children = [
      HomeScreen(
        userdata: widget.userdata,
      ),
      Search(
        userdata: widget.userdata,
      ),
      QrScan(
        userdata: widget.userdata,
      ),
      NotificationScreens(
        userdata: widget.userdata,
      ),
      UserProfile(
        userdata: widget.userdata,
      ),
    ];
  }

  int _currentIndex = 0;
  List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
            child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: _children[_currentIndex],
            ),
          ],
        )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.black87,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.house_rounded),
            label: 'Home',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.manage_search_rounded),
            label: 'Search',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_rounded),
            label: 'QR',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.doorbell_rounded),
            label: ('Notification'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
