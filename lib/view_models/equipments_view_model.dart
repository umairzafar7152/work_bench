import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:work_bench/models/equipment.dart';
import 'package:work_bench/services/equipment_service.dart';
import 'package:work_bench/services/service_locator.dart';

class EquipmentsViewModel extends ChangeNotifier {
  final EquipmentService _equipmentService = serviceLocator<EquipmentService>();

  List<Equipment> _equipments = [];
  List<Equipment> get equipments => _equipments;

  String _imageUrl;
  String get imageUrl => _imageUrl;
  String _insuranceUrl;
  String get insuranceUrl => _insuranceUrl;

  Future<void> getDataOfEquipments() async {
    List<Equipment> myEquipments = await _equipmentService.getEquipments(FirebaseAuth.instance.currentUser.uid);
    _equipments.addAll(myEquipments);
    var isEmployer = await _equipmentService.isEmployer();
    if(isEmployer) {
      List<String> employeeIds = await _equipmentService.getEmployeesIds();
      if(employeeIds.length>0) {
        for (int i = 0; i < employeeIds.length; i++) {
          List<Equipment> employeeEqs = await _equipmentService.getEquipments(employeeIds[i]);
          _equipments.addAll(employeeEqs);
        }
      }
    } else {
      String employerId = await _equipmentService.getEmployerId();
      List<Equipment> employerEqs = await _equipmentService.getEquipments(employerId);
      _equipments.addAll(employerEqs);
    }
    notifyListeners();
  }

  Future<void> uploadEquipmentImage(File file) async {
    String fileUrl = await _equipmentService.addFileToFirestore(file);
    _imageUrl = fileUrl;
    notifyListeners();
  }

  Future<void> uploadInsurance(File file) async {
    String fileUrl = await _equipmentService.addFileToFirestore(file);
    _insuranceUrl = fileUrl;
    notifyListeners();
  }

  Future<void> addEquipment(Equipment e1) async {
    await _equipmentService.addEquipmentToFirebase(e1).then((value) {
      _equipments.add(e1);
    });
    notifyListeners();
  }
}