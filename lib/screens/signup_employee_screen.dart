import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work_bench/reusable_widgets//custom_text_field.dart';

class SignUpEmployeeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("assets/images/background_img.jpg"),
        //       fit: BoxFit.cover),
        // ),
        child: SignUpEmployeePage(title: 'Sign Up'));
  }
}

class SignUpEmployeePage extends StatefulWidget {
  SignUpEmployeePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpEmployeePageState createState() => _SignUpEmployeePageState();
}

class _SignUpEmployeePageState extends State<SignUpEmployeePage> {
  String _emailText;
  String _nameText;
  String _mobileNumberText;
  String _passwordText;
  String _birthdayText;
  String _positionText;
  File _resumeFile;
  File _certificateFile;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _positionController = TextEditingController();

  // Map<String, dynamic> _dataToUpload;
  final ImagePicker _picker = ImagePicker();
  PickedFile _pickedFile;
  // String _imageUrl;
  bool _isLoading = false;

  // String _userId;

  // String _avatarUrl =
  //     'https://firebasestorage.googleapis.com/v0/b/rent-all-deb4b.appspot.com/o/avatar_1.jpg?alt=media&token=0e21d82b-9c1a-4ae9-ad6e-33bde461b245';

  @override
  // void initState() {
  // _getCurrentUser();
  // _isLoading = true;
  // getDataOfUser(_userId).then((value) {
  //   _imageUrl = value.data()['image_url'];
  //   _emailText = value.data()['email'];
  //   _firstNameText = value.data()['first'];
  //   _lastNameText = value.data()['last'];
  //   _mobileNumberText = value.data()['mobile'];
  //   _paypalText = value.data()['paypal_email'];
  //
  //   _emailController.text = _emailText;
  //   _firstController.text = _firstNameText;
  //   _lastController.text = _lastNameText;
  //   _mobileController.text = _mobileNumberText;
  //   _paypalController.text = _paypalText;
  //   setState(() {
  //     _isLoading = false;
  //   });
  // });
  // super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF).withOpacity(.4),
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent, // status bar color
      //   brightness: Brightness.dark,
      //   title: Text(
      //     widget.title,
      //   ),
      // ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A4F54)),
        ),
      )
          : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Create Profile',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              imageProfile(_pickedFile),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomTextField(
                  controller: _nameController,
                  prefixIcon: Icon(Icons.text_fields_outlined),
                  hintText: 'Name',
                  inputType: TextInputType.name,
                  autoFocus: true,
                  autoCorrect: false,
                  enableSuggestions: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomTextField(
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
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomTextField(
                  controller: _passwordController,
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  hintText: 'Password',
                  inputType: TextInputType.visiblePassword,
                  obscureText: true,
                  autoFocus: false,
                  autoCorrect: false,
                  enableSuggestions: false,
                  showSuffix: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomTextField(
                  controller: _nameController,
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
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: DateTimePicker(
                  use24HourFormat: false,
                  // type: DateTimePickerType.dateTimeSeparate,
                  // dateMask: 'MMM dd, yyyy',
                  initialValue: '',
                  // icon: Icon(Icons.event_available_rounded),
                  firstDate: DateTime(1800),
                  lastDate: DateTime.now(),
                  dateLabelText: 'Birthday',
                  onChanged: (val) {
                    setState(() {
                      _birthdayText = val;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.event_available_rounded),
                    hintText: 'Birthday',
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
                  controller: _positionController,
                  prefixIcon: Icon(Icons.assignment_ind_outlined),
                  hintText: 'Position',
                  inputType: TextInputType.text,
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
                    FilePickerResult result =
                    await FilePicker.platform.pickFiles();
                    if (result != null) {
                      setState(() {
                        _resumeFile = File(result.files.single.path);
                      });
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
                            Icon(Icons.attach_file_outlined, color: Colors.black87.withOpacity(.6),),
                            SizedBox(width: 10),
                            Text(
                              null != _resumeFile
                                  ? _resumeFile.path.split('/').last
                                  : 'Select Resume',
                              style: TextStyle(fontSize: 16, color: Colors.black87.withOpacity(.6)),
                            ),
                          ],
                        )),
                    decoration: BoxDecoration(
                      color: Colors.white70.withOpacity(.5),
                      borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0)),
                        border: Border.all(color: Colors.black87.withOpacity(.6))
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: GestureDetector(
                  onTap: () async {
                    FilePickerResult result =
                    await FilePicker.platform.pickFiles();
                    if (result != null) {
                      setState(() {
                        _certificateFile = File(result.files.single.path);
                      });
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
                            Icon(Icons.attach_file_outlined, color: Colors.black87.withOpacity(.6)),
                            SizedBox(width: 10),
                            Text(
                              null != _certificateFile
                                  ? _certificateFile.path.split('/').last
                                  : 'Select Certificate',
                              style: TextStyle(fontSize: 16, color: Colors.black87.withOpacity(.6)),
                            ),
                          ],
                        )),
                    decoration: BoxDecoration(
                      color: Colors.white70.withOpacity(.5),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                        border: Border.all(color: Colors.black87.withOpacity(.6))
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                    style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor: MaterialStateProperty.all<Color>(
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
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile(PickedFile imageFile) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
            context: context, builder: ((builder) => bottomSheet()));
      },
      child: CircleAvatar(
          radius: 60, backgroundImage: AssetImage('assets/images/avatar_1.jpg')
        // backgroundImage: imageFile?.path != null
        //     ? FileImage(File(imageFile.path))
        //     : _imageUrl != null && _imageUrl == ''
        //     ? AssetImage('assets/images/avatar_1.jpg')
        //     : NetworkImage(_imageUrl),
      ),
    );
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

  // Future<dynamic> uploadPhoto(File imageToUpload) async {
  //   Reference reference = FirebaseStorage.instance
  //       .ref()
  //       .child("profile_images")
  //       .child(imageToUpload.path.split('/').last);
  //
  //   if (_imageUrl != '' && _imageUrl != null) {
  //     FirebaseStorage.instance.refFromURL(_imageUrl).delete();
  //   }
  //   UploadTask uploadTask = reference.putFile(imageToUpload);
  //   try {
  //     _imageUrl = await (await uploadTask).ref.getDownloadURL();
  //     // imageUrl = await reference.getDownloadURL();
  //   } catch (onError) {
  //     print("ERROR GETTING URL: ${onError.toString()}");
  //   }
  //   print(_imageUrl.toString());
  // }

  // Future<dynamic> updateUserData(dataToUpload, userId) async {
  //   // CollectionReference collectionReference =
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .update(dataToUpload);
  //   // QuerySnapshot querySnapshot = await collectionReference.get();
  //   // querySnapshot.docs[0].reference.update(data);
  // }

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
    _passwordController.dispose();
    super.dispose();
  }
}
