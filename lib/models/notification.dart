import 'package:cloud_firestore/cloud_firestore.dart';

class Notif {
  String content;
  DateTime datecreate;
  String navigation;
  String status;
  String title;
  String uid;
  String notifid;

  Notif(this.content, this.navigation, this.status, this.title, this.uid);

  Notif.fromSnapshot(DocumentSnapshot snapshot)
      : notifid = snapshot.id,
        content = snapshot.data()['content'],
        datecreate = snapshot.data()['datecreate'].toDate(),
        navigation = snapshot.data()['navigation'],
        status = snapshot.data()['status'],
        title = snapshot.data()['title'],
        uid = snapshot.data()['uid'];
}
