import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:work_bench/models/inspection.dart';
import 'package:work_bench/models/vehicle.dart';
import 'package:work_bench/services/inspection_service.dart';
import 'package:work_bench/services/service_locator.dart';

class InspectionViewModel extends ChangeNotifier {
  List<Vehicle> _list = [];
  List<Vehicle> get list => _list;
  final InspectionService _inspectionService = serviceLocator<InspectionService>();

  Future<void> addInspection(Inspection inspection) async {
    await _inspectionService.addInspectionToFirebase(inspection);
    notifyListeners();
  }

  Future<void> getEquipmentsList() async {
    List<Vehicle> myEquipments = await _inspectionService.fetchList(FirebaseAuth.instance.currentUser.uid, 'equipment');
    _list.addAll(myEquipments);
    var isEmployer = await _inspectionService.isEmployer();
    if(isEmployer) {
      List<String> employeeIds = await _inspectionService.getEmployeesIds();
      if(employeeIds.length>0) {
        for (int i = 0; i < employeeIds.length; i++) {
          List<Vehicle> employeeMaintenanceRecordEquipments = await _inspectionService.fetchList(employeeIds[i], 'equipment');
          _list.addAll(employeeMaintenanceRecordEquipments);
        }
      }
    } else {
      String employerId = await _inspectionService.getEmployerId();
      List<Vehicle> employerEquipments = await _inspectionService.fetchList(employerId, 'equipment');
      _list.addAll(employerEquipments);
    }
    notifyListeners();
  }
}
