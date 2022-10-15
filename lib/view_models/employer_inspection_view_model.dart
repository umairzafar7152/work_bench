import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:work_bench/models/inspection.dart';
import 'package:work_bench/services/employer_inspection_service.dart';
import 'package:work_bench/services/service_locator.dart';

class EmployerInspectionViewModel extends ChangeNotifier {
  final EmployerInspectionService _inspectionService =
      serviceLocator<EmployerInspectionService>();

  List<Inspection> _inspection = [];

  List<Inspection> get inspection => _inspection;
  List<String> _inspectionIds = [];

  List<String> get inspectionIds => _inspectionIds;

  Future<void> getInspectionRecord() async {
    List<QueryDocumentSnapshot> inspectionDocuments = await _inspectionService
        .getInspectionRecord(FirebaseAuth.instance.currentUser.uid);
    List<Inspection> myFlha = [];
    // await _flhaService.getFlhaRecord(FirebaseAuth.instance.currentUser.uid);
    if (inspectionDocuments.length > 0) {
      try {
        for (int i = 0; i < inspectionDocuments.length; i++) {
          _inspectionIds.add(inspectionDocuments[i].id);
          Inspection inspection =
              Inspection.fromMap(inspectionDocuments[i].data());
          myFlha.add(inspection);
        }
      } catch (e) {
        print("Exception: $e");
      }
    }
    _inspection.addAll(myFlha);

    List<String> employeeIds = await _inspectionService.getEmployeesIds();
    if (employeeIds.length > 0) {
      for (int i = 0; i < employeeIds.length; i++) {
        List<QueryDocumentSnapshot> inspectionDocs =
            await _inspectionService.getInspectionRecord(employeeIds[i]);
        List<Inspection> employeeInspection = [];
        if (inspectionDocs.length > 0) {
          try {
            for (int i = 0; i < inspectionDocs.length; i++) {
              _inspectionIds.add(inspectionDocs[i].id);
              Inspection inspection =
                  Inspection.fromMap(inspectionDocs[i].data());
              employeeInspection.add(inspection);
            }
          } catch (e) {
            print("Exception: $e");
          }
        }
        _inspection.addAll(employeeInspection);
      }
    }
    notifyListeners();
  }
}
