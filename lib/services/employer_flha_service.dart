import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployerFlhaService {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('flha');
  final CollectionReference _taskReference =
      FirebaseFirestore.instance.collection('flhaTask');
  final CollectionReference _signatureReference =
      FirebaseFirestore.instance.collection('signature');

  Future<List<Map<String, dynamic>>> getTaskListRecord(String flhaId) async {
    List<Map<String, dynamic>> list = [];
    Map<String, dynamic> map = {};
    QuerySnapshot ref =
        await _taskReference.where("flhaId", isEqualTo: flhaId).get();
    var documents = ref.docs;
    if (documents.length > 0) {
      try {
        for (int i = 0; i < documents.length; i++) {
          map = {};
          map['task'] = documents[i].data()['task'];
          map['hazard'] = documents[i].data()['hazard'];
          map['priority'] = documents[i].data()['priority'];
          map['plan'] = documents[i].data()['plan'];
          list.add(map);
        }
      } catch (e) {
        print("Exception: $e");
        return list;
      }
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> getSignatureRecord(String flhaId) async {
    List<Map<String, dynamic>> list = [];
    Map<String, dynamic> map = {};
    QuerySnapshot ref =
        await _signatureReference.where("flhaId", isEqualTo: flhaId).get();
    var documents = ref.docs;
    if (documents.length > 0) {
      try {
        for (int i = 0; i < documents.length; i++) {
          map = {};
          map['email'] = documents[i].data()['email'];
          map['flhaId'] = documents[i].data()['flhaId'];
          map['signatureLink'] = documents[i].data()['signatureLink'];
          list.add(map);
        }
      } catch (e) {
        print("Exception: $e");
        return list;
      }
    }
    return list;
  }

  Future<List<QueryDocumentSnapshot>> getFlhaRecord(String uid) async {
    // List<Flha> list = [];
    QuerySnapshot ref =
        await _collectionReference.where("uid", isEqualTo: uid).get();
    var documents = ref.docs;
    return documents;
    // if (documents.length > 0) {
    //   try {
    //     for (int i = 0; i < documents.length; i++) {
    //       Flha flha = Flha.fromMap(documents[i].data());
    //       list.add(flha);
    //     }
    //   } catch (e) {
    //     print("Exception: $e");
    //     return list;
    //   }
    // }
    // return list;
  }

  Future<List<String>> getEmployeesIds(String uid) async {
    List<String> ids = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('employees')
        .where('employerId', isEqualTo: uid)
        .get();
    List<QueryDocumentSnapshot> snaps = snapshot.docs;
    for (int i = 0; i < snaps.length; i++) {
      ids.add(snaps[i].id);
    }
    return ids;
  }

  Future<String> getEmployerId() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('employees')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    return snapshot.data()['employerId'];
  }

// Future<void> addFlhaToFirebase(Flha flha, List<Map<String, String>> taskList) async {
//   _collectionReference.add(flha.toMap()).then((value) {
//     for(int i=0; i<taskList.length;i++) {
//       Map<String, String> singleRecord = taskList[i];
//       singleRecord['flhaId'] = value.id;
//       _taskReference.add(singleRecord).catchError((error, stackTrace) {
//         print("FAILED TO ADD DATA: $error");
//         print("STACKTRACE IS:  $stackTrace");
//       });
//     }
//   }).catchError((error, stackTrace) {
//     print("FAILED TO ADD DATA: $error");
//     print("STACKTRACE IS:  $stackTrace");
//   });
// }
}
