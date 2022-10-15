import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:work_bench/models/maintenance.dart';
import 'package:work_bench/services/maintenance_service.dart';
import 'package:work_bench/services/service_locator.dart';

class MaintenanceViewModel extends ChangeNotifier {
  String _uid = FirebaseAuth.instance.currentUser.uid;
  final MaintenanceService _maintenanceService = serviceLocator<MaintenanceService>();
  List<Maintenance> _maintenance = [];
  List<Maintenance> get maintenanceRecords => _maintenance;
  List<QueryDocumentSnapshot> _list = [];
  List<QueryDocumentSnapshot> get list => _list;
  // List<String> _listIds = [];
  // List<String> get listIds => _listIds;

  Future<void> getDataOfMaintenance() async {
    _maintenance = await _maintenanceService.fetchMaintenanceRecord(_uid);
    var isEmployer = await _maintenanceService.isEmployer();
    if(isEmployer) {
      List<String> employeeIds = await _maintenanceService.getEmployeesIds();
      if(employeeIds.length>0) {
        for (int i = 0; i < employeeIds.length; i++) {
          List<Maintenance> employeeMaintenance = await _maintenanceService.fetchMaintenanceRecord(employeeIds[i]);
          _maintenance.addAll(employeeMaintenance);
        }
      }
    }
    notifyListeners();
  }

  Future<void> addMaintenance(Maintenance m1) async {
    await _maintenanceService.addMaintenanceToFirebase(m1);
    _maintenance.add(m1);
    notifyListeners();
  }

  Future<void> getList() async {
    List<QueryDocumentSnapshot> myMaintenanceRecEquipments = await _maintenanceService.fetchList(FirebaseAuth.instance.currentUser.uid, 'equipment');
    _list.addAll(myMaintenanceRecEquipments);
    List<QueryDocumentSnapshot> myMaintenanceRecVehicles = await _maintenanceService.fetchList(FirebaseAuth.instance.currentUser.uid, 'vehicle');
    _list.addAll(myMaintenanceRecVehicles);
    var isEmployer = await _maintenanceService.isEmployer();
    if(isEmployer) {
      List<String> employeeIds = await _maintenanceService.getEmployeesIds();
      if(employeeIds.length>0) {
        for (int i = 0; i < employeeIds.length; i++) {
          List<QueryDocumentSnapshot> employeeMaintenanceRecordEquipments = await _maintenanceService.fetchList(employeeIds[i], 'equipment');
          _list.addAll(employeeMaintenanceRecordEquipments);
          List<QueryDocumentSnapshot> employeeMaintenanceRecordVehicles = await _maintenanceService.fetchList(employeeIds[i], 'vehicle');
          _list.addAll(employeeMaintenanceRecordVehicles);
        }
      }
    }
    notifyListeners();
  }

  // Future<void> getListIds() async {
  //   _listIds = await _maintenanceService.fetchListIds();
  //   notifyListeners();
  // }
}
