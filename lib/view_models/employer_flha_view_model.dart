import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:work_bench/models/flha.dart';
import 'package:work_bench/services/employer_flha_service.dart';
import 'package:work_bench/services/service_locator.dart';

class EmployerFlhaViewModel extends ChangeNotifier {
  final EmployerFlhaService _flhaService = serviceLocator<EmployerFlhaService>();

  List<Flha> _flha = [];
  List<Flha> get flha => _flha;
  List<String> _flhaIds = [];
  List<String> get flhaIds => _flhaIds;
  Map<String, List<Map<String, dynamic>>> _taskList = {};
  Map<String, List<Map<String, dynamic>>> get taskList => _taskList;
  Map<String, List<Map<String, dynamic>>> _signatureList = {};
  Map<String, List<Map<String, dynamic>>> get signatureList => _signatureList;

  // Future<void> addRecord(Flha flha, List<Map<String, String>> taskList) async {
  //   await _flhaService.addFlhaToFirebase(flha, taskList);
  //   notifyListeners();
  // }

  Future<void> getFlhaRecord() async {
    bool isEmployer = await _isEmployer(FirebaseAuth.instance.currentUser.uid);
    if(isEmployer) {
      List<QueryDocumentSnapshot> flhaDocuments = await _flhaService.getFlhaRecord(FirebaseAuth.instance.currentUser.uid);
      List<Flha> myFlha = [];
      // await _flhaService.getFlhaRecord(FirebaseAuth.instance.currentUser.uid);
      if (flhaDocuments.length > 0) {
        try {
          for (int i = 0; i < flhaDocuments.length; i++) {
            _flhaIds.add(flhaDocuments[i].id);
            Flha flha = Flha.fromMap(flhaDocuments[i].data());
            myFlha.add(flha);
          }
        } catch (e) {
          print("Exception: $e");
        }
      }
      _flha.addAll(myFlha);

      List<String> employeeIds = await _flhaService.getEmployeesIds(FirebaseAuth.instance.currentUser.uid);
      if(employeeIds.length>0) {
        for (int i = 0; i < employeeIds.length; i++) {
          List<QueryDocumentSnapshot> flhaDocs = await _flhaService.getFlhaRecord(employeeIds[i]);
          List<Flha> employeeFlha = [];
          if (flhaDocs.length > 0) {
            try {
              for (int i = 0; i < flhaDocs.length; i++) {
                _flhaIds.add(flhaDocs[i].id);
                Flha flha = Flha.fromMap(flhaDocs[i].data());
                employeeFlha.add(flha);
              }
            } catch (e) {
              print("Exception: $e");
            }
          }
          _flha.addAll(employeeFlha);
        }
      }
    }
    bool isEmployee = await _isEmployee(FirebaseAuth.instance.currentUser.uid);
    if(isEmployee) {
      String employerId = await _flhaService.getEmployerId();
      List<QueryDocumentSnapshot> flhaDocuments = await _flhaService.getFlhaRecord(employerId);
      List<Flha> employerFlha = [];
      // await _flhaService.getFlhaRecord(FirebaseAuth.instance.currentUser.uid);
      if (flhaDocuments.length > 0) {
        try {
          for (int i = 0; i < flhaDocuments.length; i++) {
            _flhaIds.add(flhaDocuments[i].id);
            Flha flha = Flha.fromMap(flhaDocuments[i].data());
            employerFlha.add(flha);
          }
        } catch (e) {
          print("Exception: $e");
        }
      }
      _flha.addAll(employerFlha);

      List<String> employeeIds = await _flhaService.getEmployeesIds(employerId);
      if(employeeIds.length>0) {
        for (int i = 0; i < employeeIds.length; i++) {
          List<QueryDocumentSnapshot> flhaDocs = await _flhaService.getFlhaRecord(employeeIds[i]);
          List<Flha> employeeFlha = [];
          if (flhaDocs.length > 0) {
            try {
              for (int i = 0; i < flhaDocs.length; i++) {
                _flhaIds.add(flhaDocs[i].id);
                Flha flha = Flha.fromMap(flhaDocs[i].data());
                employeeFlha.add(flha);
              }
            } catch (e) {
              print("Exception: $e");
            }
          }
          _flha.addAll(employeeFlha);
        }
      }
    }
    notifyListeners();
  }

  Future<bool> _isEmployer(String uid) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.doc("users/$uid").get().then((doc) {
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

  Future<bool> _isEmployee(String uid) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.doc("employees/$uid").get().then((doc) {
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

  Future<void> getTaskListRecord() async {
    for(int i=0; i<_flhaIds.length;i++) {
      List<Map<String, dynamic>> myTaskList = await _flhaService.getTaskListRecord(_flhaIds[i]);
      _taskList[flhaIds[i]] = myTaskList;
    }
    notifyListeners();
  }

  Future<void> getSignatureRecord() async {
    for(int i=0; i<_flhaIds.length;i++) {
      print("FLHA ID:${_flhaIds[i]}");
      List<Map<String, dynamic>> mySignatureList = await _flhaService.getSignatureRecord(_flhaIds[i]);
      _signatureList[flhaIds[i]] = mySignatureList;
    }
    notifyListeners();
  }
}
