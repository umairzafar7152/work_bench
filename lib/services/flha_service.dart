import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:work_bench/models/flha.dart';

class FlhaService {
  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('flha');
  final CollectionReference _taskReference =
  FirebaseFirestore.instance.collection('flhaTask');
  final CollectionReference _signatureReference =
  FirebaseFirestore.instance.collection('signature');


  Future<void> addFlhaToFirebase(Flha flha, List<Map<String, String>> taskList, Uint8List signatureToUpload, String email) async {
    _collectionReference.add(flha.toMap()).then((value) async {
      await uploadSignature(signatureToUpload).then((valueSignature) {
        addSignatureToFirebase({
          'flhaId': value.id,
          'email': email,
          'signatureLink': valueSignature
        });
      });
      if(taskList.length!=0) {
        for(int i=0; i<taskList.length;i++) {
          Map<String, String> singleRecord = taskList[i];
          singleRecord['flhaId'] = value.id;
          _taskReference.add(singleRecord).catchError((error, stackTrace) {
            print("FAILED TO ADD DATA: $error");
            print("STACKTRACE IS:  $stackTrace");
          });
        }
      }
    }).catchError((error, stackTrace) {
      print("FAILED TO ADD DATA: $error");
      print("STACKTRACE IS:  $stackTrace");
    });
  }

  Future<void> addSignatureToFirebase(Map<String, String> signature) async {
    _signatureReference.add(signature);
  }

  Future<String> uploadSignature(Uint8List fileToUpload) async {
    final String picture = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
    Reference reference;
    reference = FirebaseStorage.instance
        .ref()
        .child("signature")
        .child(picture);
    UploadTask uploadTask = reference.putData(fileToUpload);
    // UploadTask uploadTask = reference.putFile(fileToUpload);
    try {
      return await (await uploadTask).ref.getDownloadURL();
    } catch (onError) {
      print("ERROR GETTING URL(signup): ${onError.toString()}");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchTaskList(String id) async {
    List<Map<String, dynamic>> list = [];
    Map<String, dynamic> map = {};
    QuerySnapshot ref = await _taskReference.get();
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

  Future<void> addTaskListToFirebase(List<Map<String, dynamic>> taskList, String flhaId) async {
      if(taskList.length!=0) {
        for(int i=0; i<taskList.length;i++) {
          Map<String, dynamic> singleRecord = taskList[i];
          singleRecord['flhaId'] = flhaId;
          _taskReference.add(singleRecord).catchError((error, stackTrace) {
            print("FAILED TO ADD DATA: $error");
            print("STACKTRACE IS:  $stackTrace");
          });
        }
      }
  }
}