import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:work_bench/models/job.dart';

class JobService {
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('job');
  final Reference storageReference = FirebaseStorage.instance
      .ref()
      .child("job");

  Future<List<Job>> fetchJobs() async {
    List<Job> list = [];
    var val = await collectionReference
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    var documents = val.docs;
    if (documents.length > 0) {
      try {
        documents.map((document) {
          Job job = Job.fromMap(Map<String, dynamic>.from(document.data()));
          list.add(job);
        }).toList();
      } catch (e) {
        print("Exception $e");
      }
    }
    return list;
  }

  Future<List<String>> fetchJobIds() async {
    List<String> list = [];
    var val = await collectionReference
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    var documents = val.docs;
    if (documents.length > 0) {
      try {
        documents.map((document) {
          String id = document.id;
          list.add(id);
        }).toList();
      } catch (e) {
        print("Exception $e");
      }
    }
    return list;
  }

  Future<void> addJobToFirebase(Job job) async {
    collectionReference.add(job.toMap()).catchError((error, stackTrace) {
      print("FAILED TO ADD DATA: $error");
      print("STACKTRACE IS:  $stackTrace");
    });
  }

  Future<void> updateJobToFirebase(Job job, String id) async {
    collectionReference.doc(id).update(job.toMap()).catchError((error, stackTrace) {
      print("FAILED TO ADD DATA: $error");
      print("STACKTRACE IS:  $stackTrace");
    });
  }
}