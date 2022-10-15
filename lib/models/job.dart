import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  Job(
      {this.title,
      this.location,
      this.date,
      this.uid,
      this.employeeId,
      this.address,
      this.employeeEmail,
      this.tasks,
      this.hours,
      this.image1,
      this.image2,
      this.image3,
      this.image4,
      this.image5,
      this.invoice1,
      this.invoice2,
      this.invoice3,
      this.invoice4,
      this.invoice5,
      this.equipment,
      this.equipmentId,
      this.notes});

  String title;
  GeoPoint location;
  String address;
  String date;
  String uid;
  String employeeId;
  String employeeEmail;
  String tasks;
  String hours;
  String image1;
  String image2;
  String image3;
  String image4;
  String image5;
  String invoice1;
  String invoice2;
  String invoice3;
  String invoice4;
  String invoice5;
  String equipment;
  String equipmentId;
  String notes;

  CollectionReference get firestoreRef =>
      FirebaseFirestore.instance.collection('job/');

  Future<void> saveInfo() async {
    await firestoreRef.add(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'date': date,
      'uid': uid,
      'employeeId': employeeId,
      'address': address,
      'employeeEmail': employeeEmail,
      'tasks': tasks,
      'hours': hours,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'image4': image4,
      'image5': image5,
      'invoice1': invoice1,
      'invoice2': invoice2,
      'invoice3': invoice3,
      'invoice4': invoice4,
      'invoice5': invoice5,
      'equipment': equipment,
      'equipmentId': equipmentId,
      'notes': notes
    };
  }

  Job.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    location = map['location'];
    date = map['date'];
    uid = map['uid'];
    employeeId = map['employeeId'];
    address = map['address'];
    employeeEmail = map['employeeEmail'];
    tasks = map['tasks'];
    hours = map['hours'];
    image1 = map['image1'];
    image2 = map['image2'];
    image3 = map['image3'];
    image4 = map['image4'];
    image5 = map['image5'];
    invoice1 = map['invoice1'];
    invoice2 = map['invoice2'];
    invoice3 = map['invoice3'];
    invoice4 = map['invoice4'];
    invoice5 = map['invoice5'];
    equipment = map['equipment'];
    equipmentId = map['equipmentId'];
    notes = map['notes'];
  }
}
