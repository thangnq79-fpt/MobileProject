import 'package:cloud_firestore/cloud_firestore.dart';

class UserInf {
  String email;
  String numberPhone;
  String uid;
  String userName;
  String userType;
  List<dynamic> listClass;

  UserInf(this.email, this.numberPhone, this.uid, this.userName, this.userType,
      this.listClass);

  UserInf.fromSnapshot(DocumentSnapshot snapshot)
      : email = snapshot.data()['email'],
        numberPhone = snapshot.data()['numberPhone'] != null
            ? snapshot.data()['numberPhone']
            : "",
        uid = snapshot.data()['uid'],
        userName = snapshot.data()['userName'],
        userType = snapshot.data()['userType'],
        listClass = snapshot.data()['listClass'];
}
