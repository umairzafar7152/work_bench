import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:work_bench/models/employee.dart';
import 'file:///D:/Flutter_Apps_Fiverr/work_bench/lib/view_models/user_authentication_details.dart';
import 'package:work_bench/models/user_data.dart';
import 'package:work_bench/reusable_widgets//custom_text_field.dart';

class EditEmployeeProfileScreen extends StatefulWidget {
  EditEmployeeProfileScreen({Key key, this.employee}) : super(key: key);
  final Employee employee;

  @override
  _EditEmployeeProfileScreenState createState() =>
      _EditEmployeeProfileScreenState();
}

class _EditEmployeeProfileScreenState extends State<EditEmployeeProfileScreen> {
  String _avatarUrl =
      'https://firebasestorage.googleapis.com/v0/b/work-bench-2bf1d.appspot.com/o/avatar_1.jpg?alt=media&token=c3084db6-0605-4525-ae78-5b83c28e9e5d';
  bool _isLoading = false;
  File _resumeFile;
  File _certificateFile;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  Map<String, dynamic> _mapToUpdate = {};
  final UserData user = UserData();
  final ImagePicker _picker = ImagePicker();
  PickedFile _pickedFile;
  Employee _employee;

  @override
  void initState() {
    _employee = widget.employee;
    _mapToUpdate = widget.employee.toMap();
    print(_mapToUpdate.toString());
    _nameController.text = widget.employee.name;
    _emailController.text = widget.employee.email;
    _mobileController.text = widget.employee.mobile;
    _birthdayController.text = widget.employee.birthday;
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
          key: _scaffoldKey,
          backgroundColor: Color(0xFFFFFFFF).withOpacity(.4),
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Color(0xFFFFFFFF).withOpacity(.2),
            centerTitle: true,
            title: Text(
              "Edit Profile",
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
                  child: SingleChildScrollView(child: Consumer<UserAuth>(
                    builder: (_, userAuth, __) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          imageProfile(_pickedFile),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: CustomTextField(
                              controller: _nameController,
                              prefixIcon: Icon(Icons.text_fields_outlined),
                              hintText: 'Name',
                              inputType: TextInputType.name,
                              autoCorrect: false,
                              enableSuggestions: true,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: CustomTextField(
                              isEnabled: false,
                              controller: _emailController,
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: 'Email',
                              inputType: TextInputType.emailAddress,
                              autoFocus: false,
                              autoCorrect: false,
                              enableSuggestions: true,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: CustomTextField(
                              controller: _mobileController,
                              prefixIcon: Icon(Icons.phone),
                              hintText: 'Mobile Number',
                              inputType: TextInputType.number,
                              autoFocus: false,
                              autoCorrect: false,
                              enableSuggestions: false,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            //  birthday picker
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: DateTimePicker(
                              controller: _birthdayController,
                              use24HourFormat: false,
                              // type: DateTimePickerType.dateTimeSeparate,
                              // dateMask: 'MMM dd, yyyy',
                              // icon: Icon(Icons.event_available_rounded),
                              firstDate: DateTime(1800),
                              lastDate: DateTime.now(),
                              dateLabelText: 'Birthday',
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.event_available_rounded),
                                hintText: 'Birthday',
                                filled: true,
                                fillColor: Colors.white70.withOpacity(.5),
                                border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    borderSide:
                                        BorderSide(color: Colors.white24)
                                    //borderSide: const BorderSide(),
                                    ),
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: GestureDetector(
                              onTap: () async {
                                FilePickerResult result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  setState(() {
                                    _resumeFile =
                                        File(result.files.single.path);
                                  });
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.attach_file_outlined,
                                            color:
                                                Colors.black87.withOpacity(.6)),
                                        SizedBox(width: 10),
                                        Text(
                                          null != _resumeFile
                                              ? _resumeFile.path.split('/').last
                                              : 'Select Resume',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87
                                                  .withOpacity(.6)),
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
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: GestureDetector(
                              onTap: () async {
                                FilePickerResult result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  setState(() {
                                    _certificateFile =
                                        File(result.files.single.path);
                                  });
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.attach_file_outlined,
                                            color:
                                                Colors.black87.withOpacity(.6)),
                                        SizedBox(width: 10),
                                        Text(
                                          null != _certificateFile
                                              ? _certificateFile.path
                                                  .split('/')
                                                  .last
                                              : 'Select Certificate',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87
                                                  .withOpacity(.6)),
                                        ),
                                      ],
                                    )),
                                decoration: BoxDecoration(
                                    color: Colors.white70.withOpacity(.5),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                    border: Border.all(
                                        color: Colors.black87.withOpacity(.6))),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _uploadAllFiles();
                                },
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900),
                                ),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF4A4F54).withOpacity(0.7)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )),
                ),
        ));
  }

  Future<void> _profileAsync() async {
    await uploadFile(File(_pickedFile.path), 'profile').then((value) async {
      print("TESTING>>>>>>>>>$value");
      if (widget.employee.profileImage != null &&
          widget.employee.profileImage != '') {
        FirebaseStorage.instance
            .refFromURL(widget.employee.profileImage)
            .delete();
      }
      _employee.profileImage = value;
      _mapToUpdate['profileImageLink'] = _employee.profileImage;
    });
  }

  Future<void> _certificateAsync() async {
    await uploadFile(_certificateFile, 'certificate').then((value) async {
      print("TESTING1>>>>>>>>>$value");
      if (widget.employee.certificate != null &&
          widget.employee.certificate != '') {
        FirebaseStorage.instance
            .refFromURL(widget.employee.certificate)
            .delete();
      }
      _employee.certificate = value;
      _mapToUpdate['certificate'] = _employee.certificate;
    });
  }

  Future<void> _resumeAsync() async {
    await uploadFile(_resumeFile, 'resume').then((value) async {
      print("TESTING2>>>>>>>>>$value");
      if (widget.employee.resume != null && widget.employee.resume != '') {
        FirebaseStorage.instance.refFromURL(widget.employee.resume).delete();
      }
      _employee.resume = value;
      _mapToUpdate['resume'] = _employee.resume;
    });
  }

  Future<void> _uploadAllFiles() async {
    if (_pickedFile != null &&
        _certificateFile != null &&
        _resumeFile != null) {
      print("FIRST>>>>>>>>>");
      Future.wait([_profileAsync(), _certificateAsync(), _resumeAsync()])
          .then((value) {
        _mapToUpdate['name'] = _nameController.text;
        _mapToUpdate['email'] = _emailController.text;
        _mapToUpdate['mobile'] = _mobileController.text;
        _mapToUpdate['birthday'] = _birthdayController.text;
        print(_mapToUpdate.toString());
        updateUserData(_mapToUpdate, FirebaseAuth.instance.currentUser.uid).then(
            (value) => Navigator.pop(context, _mapToUpdate)
            // Navigator.pushReplacement(
                // context,
                // new MaterialPageRoute(
                //     builder: (context) => MainPageEmployee()))
        );
      });
    } else if (_pickedFile != null && _certificateFile != null) {
      print("SECOND>>>>>>>>>");
      Future.wait([_profileAsync(), _certificateAsync()]).then((value) {
        _mapToUpdate['name'] = _nameController.text;
        _mapToUpdate['email'] = _emailController.text;
        _mapToUpdate['mobile'] = _mobileController.text;
        _mapToUpdate['birthday'] = _birthdayController.text;
        print(_mapToUpdate.toString());
        updateUserData(_mapToUpdate, FirebaseAuth.instance.currentUser.uid).then(
            (value) => Navigator.pop(context, _mapToUpdate)
            // Navigator.pushReplacement(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => MainPageEmployee()))
        );
      });
    } else if (_pickedFile != null && _resumeFile != null) {
      print("THIRD>>>>>>>>>");
      Future.wait([_profileAsync(), _resumeAsync()]).then((value) {
        _mapToUpdate['name'] = _nameController.text;
        _mapToUpdate['email'] = _emailController.text;
        _mapToUpdate['mobile'] = _mobileController.text;
        _mapToUpdate['birthday'] = _birthdayController.text;
        print(_mapToUpdate.toString());
        updateUserData(_mapToUpdate, FirebaseAuth.instance.currentUser.uid).then(
            (value) => Navigator.pop(context, _mapToUpdate)
            // Navigator.pushReplacement(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => MainPageEmployee()))
        );
      });
    } else if (_certificateFile != null && _resumeFile != null) {
      print("FOURTH>>>>>>>>>");
      Future.wait([_certificateAsync(), _resumeAsync()]).then((value) {
        _mapToUpdate['name'] = _nameController.text;
        _mapToUpdate['email'] = _emailController.text;
        _mapToUpdate['mobile'] = _mobileController.text;
        _mapToUpdate['birthday'] = _birthdayController.text;
        print(_mapToUpdate.toString());
        updateUserData(_mapToUpdate, FirebaseAuth.instance.currentUser.uid).then(
            (value) => Navigator.pop(context, _mapToUpdate)
            // Navigator.pushReplacement(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => MainPageEmployee()))
        );
      });
    } else if (_pickedFile != null) {
      print("FIFTH>>>>>>>>>");
      _profileAsync().then((value) {
        _mapToUpdate['name'] = _nameController.text;
        _mapToUpdate['email'] = _emailController.text;
        _mapToUpdate['mobile'] = _mobileController.text;
        _mapToUpdate['birthday'] = _birthdayController.text;
        print(_mapToUpdate.toString());
        updateUserData(_mapToUpdate, FirebaseAuth.instance.currentUser.uid).then(
            (value) => Navigator.pop(context, _mapToUpdate)
            // Navigator.pushReplacement(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => MainPageEmployee()))
        );
      });
    } else if (_certificateFile != null) {
      print("SIXTH>>>>>>>>>");
      _certificateAsync().then((value) {
        _mapToUpdate['name'] = _nameController.text;
        _mapToUpdate['email'] = _emailController.text;
        _mapToUpdate['mobile'] = _mobileController.text;
        _mapToUpdate['birthday'] = _birthdayController.text;
        print(_mapToUpdate.toString());
        updateUserData(_mapToUpdate, FirebaseAuth.instance.currentUser.uid).then(
            (value) => Navigator.pop(context, _mapToUpdate)
            // Navigator.pushReplacement(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => MainPageEmployee()))
        );
      });
    } else if (_resumeFile != null) {
      print("SEVENTH>>>>>>>>>");
      _resumeAsync().then((value) {
        _mapToUpdate['name'] = _nameController.text;
        _mapToUpdate['email'] = _emailController.text;
        _mapToUpdate['mobile'] = _mobileController.text;
        _mapToUpdate['birthday'] = _birthdayController.text;
        print(_mapToUpdate.toString());
        updateUserData(_mapToUpdate, FirebaseAuth.instance.currentUser.uid).then(
            (value) => Navigator.pop(context, _mapToUpdate)
            // Navigator.pushReplacement(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => MainPageEmployee()))
        );
      });
    }
  }

  Widget customAlertDialog(String typeOfError) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      backgroundColor: Color(0xFF4A4F54).withOpacity(.8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: Row(
        children: <Widget>[
          Icon(
            Icons.warning_amber_outlined,
            color: Colors.red,
          ),
          Text(
            "Warning",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      content: typeOfError == 'email'
          ? Text(
              "Enter valid Email Address!",
              style: TextStyle(
                color: Colors.black,
              ),
            )
          : Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Your password should contain at least:',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    '\u2022 one upper case',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    '\u2022 one lower case',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    '\u2022 one digit',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    '\u2022 one special character',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          child: Text(
            'Retry',
            style: TextStyle(
                color: Colors.white, backgroundColor: Color(0xFF4A4F54)),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF4A4F54)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isValidPassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.isEmpty) {
      return false;
    } else {
      if (!regex.hasMatch(value))
        return false;
      else
        return true;
    }
  }

  bool isValidEmail(String value) {
    return RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(_emailController.text);
  }

  Widget imageProfile(PickedFile imageFile) {
    return TextButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: ((builder) => bottomSheet()));
        },
        child: CircleAvatar(
          radius: 60,
          // backgroundImage: AssetImage('assets/images/avatar_1.jpg')
          backgroundImage: imageFile?.path != null
              ? FileImage(File(imageFile.path))
              : NetworkImage(widget.employee.profileImage == null ||
                      widget.employee.profileImage == ''
                  ? _avatarUrl
                  : widget.employee.profileImage),
          // imageFile?.path != null
          // ? FileImage(File(imageFile.path))
          // : widget.employee.profileImageLink != null
          //     ? NetworkImage(widget.employee.profileImageLink)
          //     : AssetImage('assets/images/avatar_1.jpg'
        ));
  }

  Widget bottomSheet() {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: <Widget>[
          Text(
            'Choose your profile picture',
            style: TextStyle(fontSize: 14, color: Color(0xFF4A4F54)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    size: 30,
                    color: Color(0xFF4A4F54),
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    size: 30,
                    color: Color(0xFF4A4F54),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    takePhoto(ImageSource.gallery);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _pickedFile = pickedFile;
    });
  }

  Future<dynamic> updateUserData(dataToUpload, userId) async {
    // CollectionReference collectionReference =
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(userId)
        .update(dataToUpload);
    // QuerySnapshot querySnapshot = await collectionReference.get();
    // querySnapshot.docs[0].reference.update(data);
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

  Future<bool> isConnected() async {
    var connected;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      connected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      connected = true;
    } else {
      connected = false;
    }
    return connected;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }
}
