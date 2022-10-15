import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  Employee({this.email, this.name, this.password, this.mobile, this.birthday,
    this.resume, this.certificate, this.hourlyRate, this.profileImage, this.employerId
  });

  Employee.fromDocument(DocumentSnapshot document) {
    name = document.data()['name'];
    email = document.data()['email'];
    mobile = document.data()['mobile'];
    birthday = document.data()['birthday'];
    resume = document.data()['resume'];
    certificate = document.data()['certificate'];
    password = document.data()['password'];
    hourlyRate = document.data()['hourlyRate'];
    profileImage = document.data()['profileImage'];
    employerId = document.data()['employerId'];
  }

  // String id;
  String name;
  String email;
  String password;
  String mobile;
  String birthday;
  String resume;
  String certificate;
  String hourlyRate;
  String profileImage;
  String employerId;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'birthday': birthday,
      'resume': resume,
      'certificate': certificate,
      'password': password,
      'hourlyRate': hourlyRate,
      'profileImage': profileImage,
      'employerId': employerId
    };
  }

  Employee.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    email = map['email'];
    mobile = map['mobile'];
    birthday = map['birthday'];
    resume = map['resume'];
    certificate = map['certificate'];
    password = map['password'];
    hourlyRate = map['hourlyRate'];
    profileImage = map['profileImage'];
    employerId = map['employerId'];
  }
}