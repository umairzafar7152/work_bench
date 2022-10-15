import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:work_bench/models/equipment.dart';

class EquipmentService {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('equipment');
  final Reference _storageReference =
      FirebaseStorage.instance.ref().child("equipment");

  Future<List<Equipment>> getEquipments(String uid) async {
    List<Equipment> list = [];
    QuerySnapshot ref =
        await _collectionReference.where("uid", isEqualTo: uid).get();
    var documents = ref.docs;
    if (documents.length > 0) {
      try {
        for (int i = 0; i < documents.length; i++) {
          Equipment eq1 = Equipment.fromMap(documents[i].data());
          list.add(eq1);
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

  Future<void> addEquipmentToFirebase(Equipment equipment) async {
    _collectionReference.add(equipment.toMap()).catchError((error, stackTrace) {
      print("FAILED TO ADD DATA: $error");
      print("STACKTRACE IS:  $stackTrace");
    });
  }

  Future<String> addFileToFirestore(File fileToUpload) async {
    Reference reference =
        _storageReference.child(fileToUpload.path.split('/').last);
    UploadTask uploadTask = reference.putFile(fileToUpload);
    try {
      return await (await uploadTask).ref.getDownloadURL();
    } catch (onError) {
      print("ERROR GETTING URL(signup): ${onError.toString()}");
      return null;
    }
  }
}
