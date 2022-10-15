import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:work_bench/models/employee.dart';
import 'package:work_bench/reusable_widgets/custom_text_field.dart';

class EmployeeInfoScreen extends StatefulWidget {
  EmployeeInfoScreen({Key key, this.employee}) : super(key: key);
  final Employee employee;

  @override
  _EmployeeInfoScreenState createState() => _EmployeeInfoScreenState();
}

class _EmployeeInfoScreenState extends State<EmployeeInfoScreen> {
  String _birthdayText;
  String _profileUrl;
  String _resumeUrl;
  String _certificateUrl;
  Directory _storageDir;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    getExternalStorageDirectory().then((value) {
      _storageDir = value;
    });
    _profileUrl = widget.employee.profileImage;
    _nameController.text = widget.employee.name;
    _emailController.text = widget.employee.email;
    _mobileController.text = widget.employee.mobile;
    _birthdayText = widget.employee.birthday;
    _rateController.text = widget.employee.hourlyRate;
    _resumeUrl = widget.employee.resume;
    _certificateUrl = widget.employee.certificate;

    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("assets/images/background_img.jpg"),
        //       fit: BoxFit.cover),
        // ),
        child: Scaffold(
          backgroundColor: Color(0xFFFFFFFF).withOpacity(.4),
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Color(0xFFFFFFFF).withOpacity(.2),
            centerTitle: true,
            title: Text(
              "Employee Info",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4A4F54)),
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        // Image.network(_profileUrl),
                        CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                _profileUrl != null && _profileUrl != ''
                                    ? NetworkImage(_profileUrl)
                                    : AssetImage('assets/images/avatar_1.jpg')),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                              isEnabled: false,
                              controller: _nameController,
                              prefixIcon: Icon(Icons.text_fields_outlined),
                              hintText: 'Name',
                              inputType: TextInputType.name),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                              isEnabled: false,
                              controller: _emailController,
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: 'Email',
                              inputType: TextInputType.emailAddress),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                              isEnabled: false,
                              controller: _mobileController,
                              prefixIcon: Icon(Icons.phone),
                              hintText: 'Mobile Number',
                              inputType: TextInputType.number),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          //  birthday picker
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: DateTimePicker(
                            enabled: false,
                            use24HourFormat: false,
                            // type: DateTimePickerType.dateTimeSeparate,
                            // dateMask: 'MMM dd, yyyy',
                            initialValue: _birthdayText,
                            // icon: Icon(Icons.event_available_rounded),
                            firstDate: DateTime(1800),
                            lastDate: DateTime.now(),
                            dateLabelText: 'Birthday',
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.event_available_rounded),
                              hintText: 'Birthday',
                              hintStyle: TextStyle(
                                  color: Colors.black87.withOpacity(0.4)),
                              filled: true,
                              fillColor: Colors.white70.withOpacity(.5),
                              border: OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.white24)
                                  //borderSide: const BorderSide(),
                                  ),
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                            isEnabled: false,
                            controller: _rateController,
                            prefixIcon: Icon(Icons.attach_money_outlined),
                            hintText: 'Hourly Rate',
                            inputType: TextInputType.number,
                            autoFocus: false,
                            autoCorrect: false,
                            enableSuggestions: false,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: GestureDetector(
                            onTap: () async {
                              if(_resumeUrl!=null&&_resumeUrl!='') {
                                final status = await Permission.storage.request();
                                if(status.isGranted) {
                                  await FlutterDownloader.enqueue(
                                    url: _resumeUrl,
                                    savedDir: _storageDir.path,
                                    fileName: 'download',
                                    showNotification: true,
                                    openFileFromNotification: true,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Permission Denied",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "No resume found!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.download_outlined,
                                          color:
                                              Colors.black87.withOpacity(.6)),
                                      SizedBox(width: 10),
                                      Text(
                                        'Resume',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Colors.black87.withOpacity(.6)),
                                      ),
                                    ],
                                  )),
                              decoration: BoxDecoration(
                                  color: Colors.white70.withOpacity(.5),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0)),
                                  border: Border.all(
                                      color: Colors.black87.withOpacity(.6))),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: GestureDetector(
                            onTap: () async {
                              if(_certificateUrl!=null&&_certificateUrl!='') {
                                final status = await Permission.storage.request();
                                if(status.isGranted) {
                                  await FlutterDownloader.enqueue(
                                    url: _certificateUrl,
                                    savedDir: _storageDir.path,
                                    fileName: 'download',
                                    showNotification: true,
                                    openFileFromNotification: true,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Permission Denied",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "No certificate found!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.download_outlined,
                                          color:
                                              Colors.black87.withOpacity(.6)),
                                      SizedBox(width: 10),
                                      Text(
                                        'Certificate',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Colors.black87.withOpacity(.6)),
                                      ),
                                    ],
                                  )),
                              decoration: BoxDecoration(
                                  color: Colors.white70.withOpacity(.5),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0)),
                                  border: Border.all(
                                      color: Colors.black87.withOpacity(.6))),
                            ),
                          ),
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),
        ));
  }

  // Future<bool> isConnected() async {
  //   var connected;
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     connected = true;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     connected = true;
  //   } else {
  //     connected = false;
  //   }
  //   return connected;
  // }

  // void _getCurrentUser() {
  //   User mCurrentUser = FirebaseAuth.instance.currentUser;
  //   if (mCurrentUser != null) {
  //     _userId = mCurrentUser.uid;
  //     // _userEmail = mCurrentUser.email;
  //   } else {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => LogIn()));
  //   }
  // }

  // Future<DocumentSnapshot> getDataOfUser(String userIdRequired) async {
  //   var localSnapshot;
  //   var docRef =
  //   FirebaseFirestore.instance.collection("users").doc(userIdRequired);
  //   localSnapshot = await docRef.get();
  //   // setState(() {
  //   //   _snapshot = localSnapshot;
  //   // });
  //   return localSnapshot;
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _rateController.dispose();
    super.dispose();
  }
}
