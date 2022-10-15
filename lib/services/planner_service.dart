import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:work_bench/models/planner.dart';

class PlannerService {
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('planner');
  final Reference storageReference = FirebaseStorage.instance
      .ref()
      .child("planner");

  Future<List<Planner>> fetchPlannerRecord(String uid) async {
    List<Planner> list = [];
    var val = await collectionReference
        .where("uid", isEqualTo: uid)
        .get();
    var documents = val.docs;
    if (documents.length > 0) {
      try {
        documents.map((document) {
          Planner planner = Planner.fromMap(Map<String, dynamic>.from(document.data()));
          list.add(planner);
        }).toList();
      } catch (e) {
        print("Exception $e");
      }
    }
    return list;
  }

  Future<void> addPlannerToFirebase(Planner planner) async {
    collectionReference.add(planner.toMap()).catchError((error, stackTrace) {
      print("FAILED TO ADD DATA: $error");
      print("STACKTRACE IS:  $stackTrace");
    });
  }
}