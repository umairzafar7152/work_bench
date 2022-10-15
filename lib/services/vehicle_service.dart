import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:work_bench/models/vehicle.dart';

class VehicleService {
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('vehicle');
  final Reference storageReference = FirebaseStorage.instance
      .ref()
      .child("vehicle");

  Future<List<Vehicle>> getVehicles(String uid) async {
    List<Vehicle> list = [];
    QuerySnapshot ref =
    await collectionReference.where("uid", isEqualTo: uid).get();
    var documents = ref.docs;
    if (documents.length > 0) {
      try {
        for (int i = 0; i < documents.length; i++) {
          Vehicle vehicle = Vehicle.fromMap(documents[i].data());
          list.add(vehicle);
        }
      } catch (e) {
        print("Exception: $e");
        return list;
      }
    }
    return list;
  }

  Future<bool> isEmployer() async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance
          .doc("users/${FirebaseAuth.instance.currentUser.uid}")
          .get()
          .then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getEmployeesIds() async {
    List<String> ids = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('employees')
        .where('employerId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    List<QueryDocumentSnapshot> snaps = snapshot.docs;
    for (int i = 0; i < snaps.length; i++) {
      ids.add(snaps[i].id);
    }
    return ids;
  }

  Future<String> getEmployerId() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('employees')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    return snapshot.data()['employerId'];
  }


  Future<void> addVehicleToFirebase(Vehicle vehicle) async {
    collectionReference.add(vehicle.toMap()).catchError((error, stackTrace) {
      print("FAILED TO ADD DATA: $error");
      print("STACKTRACE IS:  $stackTrace");
    });
  }

  Future<String> addFileToFirestore(File fileToUpload) async {
    Reference reference = storageReference
        .child(fileToUpload.path.split('/').last);
    UploadTask uploadTask = reference.putFile(fileToUpload);
    try {
      return await (await uploadTask).ref.getDownloadURL();
    } catch (onError) {
      print("ERROR GETTING URL(signup): ${onError.toString()}");
      return null;
    }
  }
}