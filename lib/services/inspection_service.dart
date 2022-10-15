import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_bench/models/inspection.dart';
import 'package:work_bench/models/vehicle.dart';

class InspectionService {
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('inspection');

  Future<void> addInspectionToFirebase(Inspection inspection) async {
    collectionReference.add(inspection.toMap()).catchError((error, stackTrace) {
      print("FAILED TO ADD DATA: $error");
      print("STACKTRACE IS:  $stackTrace");
    });
  }

  Future<List<Vehicle>> fetchList(String uid, String type) async {
    List<Vehicle> list = [];
    QuerySnapshot ref =
    await FirebaseFirestore.instance.collection('equipment').where("uid", isEqualTo: uid).get();
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
}