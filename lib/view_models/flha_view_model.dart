import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:work_bench/models/flha.dart';
import 'package:work_bench/services/flha_service.dart';
import 'package:work_bench/services/service_locator.dart';

class FlhaViewModel extends ChangeNotifier {
  final FlhaService _flhaService = serviceLocator<FlhaService>();
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> get tasks => _tasks;

  Future<void> addRecord(Flha flha, List<Map<String, String>> taskList, Uint8List signatureToUpload, String email) async {
    await _flhaService.addFlhaToFirebase(flha, taskList, signatureToUpload, email);
    notifyListeners();
  }

  Future<void> fetchTaskRecord(String id) async {
    List<Map<String, dynamic>> myTasks = await _flhaService.fetchTaskList(id);
    _tasks.addAll(myTasks);
    notifyListeners();
  }

  Future<void> addSignatureRecord(Uint8List signatureToUpload, String flhaId, String email) async{
    await _flhaService.uploadSignature(signatureToUpload).then((valueSignature) {
      _flhaService.addSignatureToFirebase({
        'flhaId': flhaId,
        'email': email,
        'signatureLink': valueSignature
      });
    });
    notifyListeners();
  }

  Future<void> uploadTaskList(List<Map<String, dynamic>> taskList, String flhaId) async {
    await _flhaService.addTaskListToFirebase(taskList, flhaId);
    notifyListeners();
  }
}
