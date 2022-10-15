import 'package:cloud_firestore/cloud_firestore.dart';

class TaskHazardPlan {
  TaskHazardPlan(
      {this.uid,
        this.date,
        this.taskAddress,
        this.taskLocation,
        this.areaCleanedUp,
        this.companyName,
        this.hazardsRemaining,
        this.incidentInjuries,
        this.musterAddress,
        this.musterLocation,
        this.permitClosedOut,
        this.permitNo,
        this.ppeInspected,
        this.preUseInspectionCompleted,
        this.warningRibbon,
        this.workingAlone,
        this.workToBeDone});

  String uid;
  String date;
  GeoPoint taskLocation;
  String taskAddress;
  String companyName;
  String workToBeDone;
  String musterAddress;
  GeoPoint musterLocation;
  String permitNo;
  String ppeInspected;
  String preUseInspectionCompleted;
  String warningRibbon;
  String workingAlone;
  String permitClosedOut;
  String areaCleanedUp;
  String hazardsRemaining;
  String incidentInjuries;

  CollectionReference get firestoreRef =>
      FirebaseFirestore.instance.collection('inspection/');

  Future<void> saveInfo() async {
    await firestoreRef.add(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'date': date,
      'taskLocation': taskLocation,
      'taskAddress': taskAddress,
      'companyName': companyName,
      'workToBeDone': workToBeDone,
      'musterAddress': musterAddress,
      'musterLocation': musterLocation,
      'permitNo': permitNo,
      'ppeInspected': ppeInspected,
      'preUseInspectionCompleted': preUseInspectionCompleted,
      'warningRibbon': warningRibbon,
      'workingAlone': workingAlone,
      'permitClosedOut': permitClosedOut,
      'areaCleanedUp': areaCleanedUp,
      'hazardsRemaining': hazardsRemaining,
      'incidentInjuries': incidentInjuries
    };
  }
}
