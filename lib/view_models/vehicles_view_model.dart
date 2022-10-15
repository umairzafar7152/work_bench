import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:work_bench/models/vehicle.dart';
import 'package:work_bench/services/service_locator.dart';
import 'package:work_bench/services/vehicle_service.dart';

class VehiclesViewModel extends ChangeNotifier {
  final VehicleService _vehicleService = serviceLocator<VehicleService>();
  String _imageUrl;
  String get imageUrl => _imageUrl;
  String _insuranceUrl;
  String get insuranceUrl => _insuranceUrl;

  List<Vehicle> _vehicles = [];
  List<Vehicle> get vehicles => _vehicles;

  Future<void> getDataOfVehicles() async {
    List<Vehicle> myEquipments = await _vehicleService.getVehicles(FirebaseAuth.instance.currentUser.uid);
    _vehicles.addAll(myEquipments);
    var isEmployer = await _vehicleService.isEmployer();
    if(isEmployer) {
      List<String> employeeIds = await _vehicleService.getEmployeesIds();
      if(employeeIds.length>0) {
        for (int i = 0; i < employeeIds.length; i++) {
          List<Vehicle> employeeEqs = await _vehicleService.getVehicles(employeeIds[i]);
          _vehicles.addAll(employeeEqs);
        }
      }
    } else {
      String employerId = await _vehicleService.getEmployerId();
      List<Vehicle> employerEqs = await _vehicleService.getVehicles(employerId);
      _vehicles.addAll(employerEqs);
    }
    notifyListeners();
  }

  Future<void> uploadVehicleImage(File file) async {
    String fileUrl = await _vehicleService.addFileToFirestore(file);
    _imageUrl = fileUrl;
    notifyListeners();
  }

  Future<void> uploadInsurance(File file) async {
    String fileUrl = await _vehicleService.addFileToFirestore(file);
    _insuranceUrl = fileUrl;
    notifyListeners();
  }

  Future<void> addVehicle(Vehicle v1) async {
    await _vehicleService.addVehicleToFirebase(v1).then((value) {
      _vehicles.add(v1);
    });
    notifyListeners();
  }
}