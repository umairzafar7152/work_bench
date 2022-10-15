import 'package:cloud_firestore/cloud_firestore.dart';

class Inspection {
  Inspection(
      {this.uid,
        this.email,
      this.equipmentName,
        this.date,
      this.engine,
      this.frame,
      this.boom,
      this.stick,
      this.rops,
      this.hydCylinders,
      this.latches,
      this.bucket,
      this.tires,
      this.rubberTrack,
      this.linkages,
      this.underCarriage,
      this.workTool,
      this.finalDrives,
      this.opEngine,
      this.opHydCylinders,
      this.opTrackSpeed,
      this.opBoomDrift,
      this.opBushingMovement,
      this.opLeaksDrips,
      this.skidSteerChainCase,
      this.skidSteerDriveline,
      this.wheelLoaderArticulationJoint,
      this.excavatorSwingBearing,
      this.dozerPatBlade,
      this.note});

  String uid;
  String equipmentName;
  String date;
  String email;
  String engine;
  String frame;
  String boom;
  String stick;
  String rops;
  String hydCylinders;
  String latches;
  String bucket;
  String tires;
  String rubberTrack;
  String linkages;
  String underCarriage;
  String workTool;
  String finalDrives;
  String opEngine;
  String opHydCylinders;
  String opTrackSpeed;
  String opBoomDrift;
  String opBushingMovement;
  String opLeaksDrips;
  String skidSteerChainCase;
  String skidSteerDriveline;
  String wheelLoaderArticulationJoint;
  String excavatorSwingBearing;
  String dozerPatBlade;
  String note;

  CollectionReference get firestoreRef =>
      FirebaseFirestore.instance.collection('inspection/');

  Future<void> saveInfo() async {
    await firestoreRef.add(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'equipmentName': equipmentName,
      'date': date,
      'engine': engine,
      'frame': frame,
      'boom': boom,
      'stick': stick,
      'rops': rops,
      'hydCylinders': hydCylinders,
      'latches': latches,
      'bucket': bucket,
      'tires': tires,
      'rubberTrack': rubberTrack,
      'linkages': linkages,
      'underCarriage': underCarriage,
      'workTool': workTool,
      'finalDrives': finalDrives,
      'opEngine': opEngine,
      'opHydCylinders': opHydCylinders,
      'opTrackSpeed': opTrackSpeed,
      'opBoomDrift': opBoomDrift,
      'opBushingMovement': opBushingMovement,
      'opLeaksDrips': opLeaksDrips,
      'skidSteerChainCase': skidSteerChainCase,
      'skidSteerDriveline': skidSteerDriveline,
      'wheelLoaderArticulationJoint': wheelLoaderArticulationJoint,
      'excavatorSwingBearing': excavatorSwingBearing,
      'dozerPatBlade': dozerPatBlade,
      'note': note
    };
  }

  Inspection.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    email = map['email'];
    equipmentName = map['equipmentName'];
    date = map['date'];
    engine =  map['engine'];
    frame = map['frame'];
    boom = map['boom'];
    stick = map['stick'];
    rops = map['rops'];
    hydCylinders = map['hydCylinders'];
    latches = map['latches'];
    bucket = map['bucket'];
    tires = map['tires'];
    rubberTrack = map['rubberTrack'];
    linkages = map['linkages'];
    underCarriage = map['underCarriage'];
    workTool = map['workTool'];
    finalDrives = map['finalDrives'];
    opEngine = map['opEngine'];
    opHydCylinders = map['opHydCylinders'];
    opTrackSpeed = map['opTrackSpeed'];
    opBoomDrift = map['opBoomDrift'];
    opBushingMovement = map['opBushingMovement'];
    opLeaksDrips = map['opLeaksDrips'];
    skidSteerChainCase = map['skidSteerChainCase'];
    skidSteerDriveline = map['skidSteerDriveline'];
    wheelLoaderArticulationJoint = map['wheelLoaderArticulationJoint'];
    excavatorSwingBearing = map['excavatorSwingBearing'];
    dozerPatBlade = map['dozerPatBlade'];
    note = map['note'];
  }
}
