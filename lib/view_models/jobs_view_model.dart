import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:work_bench/models/job.dart';
import 'package:work_bench/services/job_service.dart';
import 'package:work_bench/services/service_locator.dart';

class JobsViewModel extends ChangeNotifier {
  final JobService _jobService = serviceLocator<JobService>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> _equipmentList;
  List<QueryDocumentSnapshot> get equipmentList => _equipmentList;
  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;
  List<String> _jobIds = [];
  List<String> get jobIds => _jobIds;

  // String _imageUrl;
  // String get imageUrl => _imageUrl;
  // String _insuranceUrl;
  // String get insuranceUrl => _insuranceUrl;

  Future<void> addJob(Job job) async {
    await _jobService.addJobToFirebase(job);
    _jobs.add(job);
    notifyListeners();
  }

  Future<void> updateJob(Job job, String id) async {
    await _jobService.updateJobToFirebase(job, id);
    _jobs.add(job);
    notifyListeners();
  }

  Future<void> getDataOJobs() async {
    _jobs = await _jobService.fetchJobs();
    _jobIds = await _jobService.fetchJobIds();
    notifyListeners();
  }

  Future<List<String>> getEmployeesList() async {
    final QuerySnapshot snapshot =
        await firestore.collection('employees').where("employerId", isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    List<String> list = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      var a = snapshot.docs[i].data()['email'];
      if(a!=null) {
        list.add(a);
      }
      print(a);
    }
    return list;
  }

  Future<List<String>> getEmployeesId() async {
    final QuerySnapshot snapshot =
    await firestore.collection('employees').where("employerId", isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    List<String> list = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      var a = snapshot.docs[i].id;
      if(a!=null) {
        list.add(a);
      }
      print(a);
    }
    return list;
  }

  Future<void> getEquipments() async {
    CollectionReference reference = FirebaseFirestore.instance.collection('equipment');
    QuerySnapshot snapshot = await reference.where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    List<QueryDocumentSnapshot> list = [];
    print(snapshot.docs.length);
    for (int i = 0; i < snapshot.docs.length; i++) {
      QueryDocumentSnapshot a = snapshot.docs[i];
      if(a!=null) {
        list.add(a);
      }
    }
    // reference = FirebaseFirestore.instance.collection('vehicle');
    // snapshot = await reference.where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    // for (int i = 0; i < snapshot.docs.length; i++) {
    //   QueryDocumentSnapshot a = snapshot.docs[i];
    //   if(a!=null) {
    //     list.add(a);
    //   }
    //   print(a.toString());
    // }
    _equipmentList = list;
    notifyListeners();
  }
}
