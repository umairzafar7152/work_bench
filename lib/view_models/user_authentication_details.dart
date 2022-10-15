import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_bench/models/user_data.dart';

class UserAuth extends ChangeNotifier {
  // UserAuth() {
  //   loadLoggedUser();
  // }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserData user;

  Future<void> signIn(
      {UserData userData, Function onFail, Function onSuccess}) async {
    try {
      // final result =
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: userData.email, password: userData.password);
      if (result.user.uid != null) {
        onSuccess();
      }
      // await loadLoggedUser(firebaseUser: result.user).then((value) {
      //   onSuccess();
      // });
    } catch (error) {
      onFail("An error has occurred: $error: ${error.code}");
    }
  }

  Future<void> signUp(
      {UserData userData,
      Function onFail,
      Function onSuccess,
      File profile,
      File resume,
      File certificate}) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: userData.email, password: userData.password);
      if (FirebaseAuth.instance.currentUser != null) logOut();
      userData.id = result.user.uid;
      if (profile != null && resume != null && certificate != null) {
        try {
          await Future.wait([
            uploadFile(profile, 'profile').then((value) async {
              userData.profileImage = value;
            }),
            uploadFile(resume, 'resume').then((value) async {
              userData.resume = value;
            }),
            uploadFile(certificate, 'certificate').then((value) async {
              userData.certificate = value;
            })
          ]).then((value) async {
            await userData.saveInfo();
            onSuccess();
          });
        } catch (e) {
          print('error occurred while uploading: $e');
        }
      }
    } catch (e) {
      onFail('error with following: $e');
    }
  }

  Future<void> logOut() async {
    await auth.signOut();
  }

  Future<String> uploadFile(File fileToUpload, String type) async {
    Reference reference;
    if (type == 'resume') {
      reference = FirebaseStorage.instance
          .ref()
          .child("resume")
          .child(fileToUpload.path.split('/').last);
    } else if (type == 'certificate') {
      reference = FirebaseStorage.instance
          .ref()
          .child("certificate")
          .child(fileToUpload.path.split('/').last);
    } else {
      reference = FirebaseStorage.instance
          .ref()
          .child("profile_images")
          .child(fileToUpload.path.split('/').last);
    }
    UploadTask uploadTask = reference.putFile(fileToUpload);
    try {
      return await (await uploadTask).ref.getDownloadURL();
    } catch (onError) {
      print("ERROR GETTING URL(signup): ${onError.toString()}");
      return null;
    }
  }

  // Future<dynamic> loadLoggedUser({User firebaseUser}) async {
  //   final User currentUser = firebaseUser ?? auth.currentUser;
  //   if (currentUser != null) {
  //     final DocumentSnapshot documentUser = await firestore.collection('users')
  //         .doc(currentUser.uid).get();
  //     user = UserData.fromDocument(documentUser);
  //     notifyListeners();
  //   }
  // }

  Future<void> resetPassword(String emailAddress) async {
    await auth.sendPasswordResetEmail(email: emailAddress);
  }
}
