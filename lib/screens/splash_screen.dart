import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:work_bench/screens/login_screen.dart';
import 'package:work_bench/screens/main_page_employee.dart';
import 'package:work_bench/screens/main_page_employer.dart';

class SplashScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Replace the 3 second delay with your initialization code:
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Splash();
        } else {
          // Loading is done, return the app:
          return StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.providerData.length == 1) {
                  isEmployer(snapshot.data.uid).then((value) {
                    if (value == true) {
                      print('logged in using employer');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainPageEmployer()));
                      // return MainPageEmployer();
                    } else {
                      isEmployee(snapshot.data.uid).then((value1) {
                        if(value1==true) {
                          print('logged in using employee');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPageEmployee()));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInScreen()));
                        }
                      });
                    }
                  });
                  return Container(
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //       image: AssetImage(
                          //           "assets/images/background_img.jpg"),
                          //       fit: BoxFit.cover),
                          // ),
                          child: Scaffold(
                            backgroundColor: Color(0xFFFFFFFF).withOpacity(.4),
                            body: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF4A4F54)),
                              ),
                            ),
                          ));
                } else {
                  // logged in using other providers
                  return LogInScreen();
                }
              } else {
                return LogInScreen();
              }
            },
          );
        }
      },
    );
  }

  Future<bool> isEmployer(String uid) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.doc("users/$uid").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isEmployee(String uid) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.doc("employees/$uid").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Work Bench',
          style: TextStyle(color: Color(0xFF4A4F54), fontSize: 72),
        ),
      ),
    );
  }
}
