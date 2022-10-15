import 'package:cloud_firestore/cloud_firestore.dart';

class Maintenance {
  Maintenance({this.uid, this.name, this.email, this.service, this.date});

  String uid;
  String name;
  String service;
  String date;
  String email;

  CollectionReference get firestoreRef =>
      FirebaseFirestore.instance.collection('maintenance/');

  Future<void> saveInfo() async {
    await firestoreRef.add(toMap());
  }

  Maintenance.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    service = map['service'];
    uid = map['uid'];
    date = map['date'];
    email = map['email'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'service': service,
      'uid': uid,
      'date': date,
      'email': email
    };
  }
}