import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_bench/models/employee.dart';
import 'package:work_bench/services/employee_list_service.dart';
import 'package:work_bench/services/service_locator.dart';

class EmployeeListViewModel extends ChangeNotifier {
  final EmployeeListService _service = serviceLocator<EmployeeListService>();

  List<Employee> _employees = [];
  List<Employee> get employees => _employees;
  List<String> _empIds;
  List<String> get empIds => _empIds;

  Future<void> getDataOfEmployees() async {
    _employees = await _service.fetchEmployees();
    _empIds = await _service.fetchEmployeeIds();
    notifyListeners();
  }

  Future<void> addEmployee(Employee userData) async {
    await _service.register(userData).then((value) async {
      // _employees.add(userData);
      _employees = await _service.fetchEmployees();
      _empIds = await _service.fetchEmployeeIds();
    });
    notifyListeners();
  }

  Future<void> setEmployeeRate(String empId, String rate) async {
    _service.setEmployeeRate(empId, rate);
    _employees[_empIds.indexOf(empId)].hourlyRate = rate;
    notifyListeners();
  }
}
