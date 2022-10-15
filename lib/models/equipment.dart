import 'package:cloud_firestore/cloud_firestore.dart';

class Equipment {
  Equipment({this.imageUrl, this.name, this.location, this.insuranceUrl, this.uid, this.address});

  String imageUrl;
  String name;
  GeoPoint location;
  String insuranceUrl;
  String uid;
  String address;

  CollectionReference get firestoreRef =>
      FirebaseFirestore.instance.collection('equipment/');

  Future<void> saveInfo() async {
    await firestoreRef.add(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'location': location,
      'insuranceUrl': insuranceUrl,
      'uid': uid,
      'address': address
    };
  }

  Equipment.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    location = map['location'];
    imageUrl = map['imageUrl'];
    insuranceUrl = map['insuranceUrl'];
    uid = map['uid'];
    address = map['address'];
  }
}