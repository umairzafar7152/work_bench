import 'package:cloud_firestore/cloud_firestore.dart';

class Flha {
  Flha(
      {this.uid,
      this.email,
      this.date,
      this.taskAddress,
      this.taskLocation,
      this.areaCleanedUp,
      this.companyName,
      this.hazardsRemaining,
      this.incidentInjuries,
      this.musterPoint,
      this.permitClosedOut,
      this.permitNo,
      this.ppeInspected,
      this.preUseInspectionCompleted,
      this.warningRibbon,
      this.workingAlone,
      this.workToBeDone});

  String uid;
  String date;
  String email;
  GeoPoint taskLocation;
  String taskAddress;
  String companyName;
  String workToBeDone;
  String musterPoint;
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
      FirebaseFirestore.instance.collection('flha/');

  Future<void> saveInfo() async {
    await firestoreRef.add(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'date': date,
      'email': email,
      'taskLocation': taskLocation,
      'taskAddress': taskAddress,
      'companyName': companyName,
      'workToBeDone': workToBeDone,
      'musterPoint': musterPoint,
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

  Flha.fromMap(Map<String, dynamic> map) {
    uid = map['name'];
    date = map['date'];
    email = map['email'];
    taskLocation = map['taskLocation'];
    taskAddress = map['taskAddress'];
    companyName = map['companyName'];
    workToBeDone = map['workToBeDone'];
    musterPoint = map['musterPoint'];
    permitNo = map['permitNo'];
    ppeInspected = map['ppeInspected'];
    warningRibbon = map['warningRibbon'];
    workingAlone = map['workingAlone'];
    permitClosedOut = map['permitClosedOut'];
    areaCleanedUp = map['areaCleanedUp'];
    hazardsRemaining = map['hazardsRemaining'];
    incidentInjuries = map['incidentInjuries'];
  }
}
