import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:work_bench/models/employee.dart';

class EmployeeListService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference collectionReference =
  FirebaseFirestore.instance.collection('employees');
  final Reference storageReference = FirebaseStorage.instance
      .ref()
      .child("employees");
  List<QueryDocumentSnapshot> employees = [];

  Future<void> register(Employee userData) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: userData.email, password: userData.password).then((value) async {
        await _addEmployeeToFirebase(userData, value.user.uid);
      });
    }
    on FirebaseAuthException catch (_) {
      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
    }

    await app.delete();
    // return Future.sync(() => userCredential);
  }

  Future<void> signUp({Employee userData, Function onFail, Function onSuccess}) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(email: userData.email, password: userData.password);
      // userData.id = result.user.uid;
      await _addEmployeeToFirebase(userData, result.user.uid);
      onSuccess();
    } catch (e) {
      onFail('error with following: $e');
    }
  }

  // Future<void> logInEmployee({Employee userData, Function onFail, Function onSuccess}) async {
  //   try {
  //     // final result =
  //     await auth.signInWithEmailAndPassword(email: userData.email, password: userData.password);
  //     // await loadLoggedUser(firebaseUser: result.user).then((value) {
  //       onSuccess();
  //     // });
  //   } catch(e) {
  //     onFail('An error has occurred: $e');
  //   }
  // }

  // Future<void> logOutEmployee() async {
  //   await auth.signOut();
  // }

  Future<List<Employee>> fetchEmployees() async {
    List<Employee> list = [];
    var val = await collectionReference
        .where("employerId", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    var documents = val.docs;
    if (documents.length > 0) {
      try {
        documents.map((document) {
          employees.add(document);
          // Employee emp = Employee.fromMap(Map<String, dynamic>.from(document.data()));
          Employee emp = Employee.fromDocument(document);
          list.add(emp);
        }).toList();
      } catch (e) {
        print("Exception $e");
      }
    }
    return list;
  }

  Future<List<String>> fetchEmployeeIds() async {
    List<String> empIds = [];
    for(int i=0; i<employees.length; i++) {
      empIds.add(employees[i].id);
    }
    return empIds;
  }


  Future<void> _addEmployeeToFirebase(Employee employee, String id) async {
    collectionReference.doc(id).set(employee.toMap()).catchError((error, stackTrace) {
      print("FAILED TO ADD DATA: $error");
      print("STACKTRACE IS:  $stackTrace");
    });
    // collectionReference.add(employee.toMap());
  }
  
  Future<void> setEmployeeRate(String empId, String rate) async {
    await collectionReference.doc(empId).update({'hourlyRate': rate});
  }
}