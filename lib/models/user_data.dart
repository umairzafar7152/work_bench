import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  UserData({this.id, this.email, this.name, this.password, this.mobile, this.birthday,
    this.profileImage, this.resume, this.certificate
  });

  UserData.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'];
    email = document.data()['email'];
    mobile = document.data()['mobile'];
    birthday = document.data()['birthday'];
    resume = document.data()['resume'];
    certificate = document.data()['certificate'];
    profileImage = document.data()['profileImage'];
  }

  String id;
  String email;
  String name;
  String password;
  String mobile;
  String birthday;
  String profileImage;
  String resume;
  String certificate;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  Future<void> saveInfo() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'birthday': birthday,
      'profileImage': profileImage,
      'resume': resume,
      'certificate': certificate,
    };
  }

  UserData.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    email = map['email'];
    mobile = map['mobile'];
    birthday = map['birthday'];
    resume = map['resume'];
    certificate = map['certificate'];
    profileImage = map['profileImage'];
  }
}