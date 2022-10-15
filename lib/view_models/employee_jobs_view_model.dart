import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:work_bench/models/job.dart';
import 'package:work_bench/services/employee_job_service.dart';
import 'package:work_bench/services/service_locator.dart';

class EmployeeJobsViewModel extends ChangeNotifier {
  final EmployeeJobService _jobService = serviceLocator<EmployeeJobService>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;
  List<String> _jobIds = [];
  List<String> get jobIds => _jobIds;

  String _imageUrl;

  String get imageUrl => _imageUrl;
  String _insuranceUrl;

  String get insuranceUrl => _insuranceUrl;

  Future<void> getDataOJobs() async {
    _jobs = await _jobService.getMyJobs(FirebaseAuth.instance.currentUser.uid);
    _jobIds = await _jobService.getMyJobIds(FirebaseAuth.instance.currentUser.uid);
    notifyListeners();
  }
}
