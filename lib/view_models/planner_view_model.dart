import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:work_bench/models/planner.dart';
import 'package:work_bench/services/planner_service.dart';
import 'package:work_bench/services/service_locator.dart';

class PlannerViewModel extends ChangeNotifier {
  String _uid = FirebaseAuth.instance.currentUser.uid;
  final PlannerService _plannerService = serviceLocator<PlannerService>();
  List<Planner> _plannerList = [];
  List<Planner> get plannerRecords => _plannerList;

  Future<void> getDataOfPlanner() async {
    _plannerList = await _plannerService.fetchPlannerRecord(_uid);
    notifyListeners();
  }

  Future<void> addPlanner(Planner p1) async {
    await _plannerService.addPlannerToFirebase(p1);
    _plannerList.add(p1);
    notifyListeners();
  }
}
