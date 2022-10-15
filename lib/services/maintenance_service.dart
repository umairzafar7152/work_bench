import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:work_bench/models/maintenance.dart';

class MaintenanceService {
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('maintenance');
  final Reference storageReference = FirebaseStorage.instance
      .ref()
      .child("maintenance");

  Future<List<Maintenance>> fetchMaintenanceRecord(String uid) async {
    List<Maintenance> list = [];
    var val = await collectionReference
        .where("uid", isEqualTo: uid)
        .get();
    var documents = val.docs;
    if (documents.length > 0) {
      try {
        documents.map((document) {
          Maintenance maintenance = Maintenance.fromMap(Map<String, dynamic>.from(document.data()));
          list.add(maintenance);
        }).toList();
      } catch (e) {
        print("Exception $e");
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

  Future<void> addMaintenanceToFirebase(Maintenance maintenance) async {
    collectionReference.add(maintenance.toMap()).catchError((error, stackTrace) {
      print("FAILED TO ADD DATA: $error");
      print("STACKTRACE IS:  $stackTrace");
    });
  }
  
  Future<List<QueryDocumentSnapshot>> fetchList(String uid, String type) async {
    CollectionReference reference = FirebaseFirestore.instance.collection(type);
    QuerySnapshot snapshot = await reference.where('uid', isEqualTo: uid).get();
    List<QueryDocumentSnapshot> list = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      QueryDocumentSnapshot a = snapshot.docs[i];
      if(a!=null) {
        list.add(a);
      }
    }
    return list;
  }

  // Future<List<String>> fetchListIds() async {
  //   CollectionReference reference = FirebaseFirestore.instance.collection('equipment');
  //   QuerySnapshot snapshot = await reference.where('uid', isEqualTo: _uid).get();
  //   List<String> list = [];
  //   for (int i = 0; i < snapshot.docs.length; i++) {
  //     var a = snapshot.docs[i].id;
  //     if(a!=null) {
  //       list.add(a);
  //     }
  //     print(a);
  //   }
  //
  //   snapshot = await reference.where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
  //
  //   return list;
  // }
}