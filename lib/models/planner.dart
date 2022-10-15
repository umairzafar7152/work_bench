import 'package:cloud_firestore/cloud_firestore.dart';

class Planner {
  Planner({this.uid, this.title, this.date, this.typeEvent, this.note});

  String uid;
  String title;
  String date;
  String typeEvent;
  String note;

  CollectionReference get firestoreRef =>
      FirebaseFirestore.instance.collection('planner/');

  Future<void> saveInfo() async {
    await firestoreRef.add(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'date': date,
      'typeEvent': typeEvent,
      'note': note
    };
  }

  Planner.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    title = map['title'];
    date = map['date'];
    typeEvent = map['typeEvent'];
    note = map['note'];
  }
}