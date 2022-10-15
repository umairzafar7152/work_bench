import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:work_bench/models/job.dart';

class EmployeeJobService {
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('job');
  final Reference storageReference = FirebaseStorage.instance
      .ref()
      .child("job");

  Future<List<Job>> getMyJobs(String uid) async {
    List<Job> list = [];
    QuerySnapshot ref =
    await collectionReference.where("employeeId", isEqualTo: uid).get();
    var documents = ref.docs;
    if (documents.length > 0) {
      try {
        for (int i = 0; i < documents.length; i++) {
          Job job = Job.fromMap(documents[i].data());
          list.add(job);
        }
      } catch (e) {
        print("Exception: $e");
        return list;
      }
    }
    return list;
  }

  Future<List<String>> getMyJobIds(String uid) async {
    List<String> list = [];
    QuerySnapshot ref =
    await collectionReference.where("employeeId", isEqualTo: uid).get();
    var documents = ref.docs;
    if (documents.length > 0) {
      try {
        for (int i = 0; i < documents.length; i++) {
          String id = documents[i].id;
          list.add(id);
        }
      } catch (e) {
        print("Exception: $e");
        return list;
      }
    }
    return list;
  }
}