import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployerInspectionService {
  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('inspection');

  Future<List<QueryDocumentSnapshot>> getInspectionRecord(String uid) async {
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

  Future<List<String>> getEmployeesIds() async {
    List<String> ids = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('employees')
        .where('employerId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    List<QueryDocumentSnapshot> snaps = snapshot.docs;
    for (int i = 0; i < snaps.length; i++) {
      ids.add(snaps[i].id);
    }
    return ids;
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