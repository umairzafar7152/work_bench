import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CalculatorViewModel extends ChangeNotifier {
  List<QueryDocumentSnapshot> _employeeList;
  List<QueryDocumentSnapshot> get employeeList => _employeeList;
  List<QueryDocumentSnapshot> _equipmentList;
  List<QueryDocumentSnapshot> get equipmentList => _equipmentList;

  Future<void> getEmployees() async {
    CollectionReference reference = FirebaseFirestore.instance.collection('employees');
    QuerySnapshot snapshot = await reference.where('employerId', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    List<QueryDocumentSnapshot> list = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      QueryDocumentSnapshot a = snapshot.docs[i];
      if(a!=null) {
        list.add(a);
      }
      print(a.toString());
    }
    _employeeList = list;
    notifyListeners();
  }

  Future<void> getEquipments() async {
    CollectionReference reference = FirebaseFirestore.instance.collection('equipment');
    QuerySnapshot snapshot = await reference.where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    List<QueryDocumentSnapshot> list = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      QueryDocumentSnapshot a = snapshot.docs[i];
      if(a!=null) {
        list.add(a);
      }
      print(a.toString());
    }
    reference = FirebaseFirestore.instance.collection('vehicle');
    snapshot = await reference.where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      QueryDocumentSnapshot a = snapshot.docs[i];
      if(a!=null) {
        list.add(a);
      }
      print(a.toString());
    }
    _equipmentList = list;
    notifyListeners();
  }
}