import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'file:///D:/Flutter_Apps_Fiverr/work_bench/lib/view_models/user_authentication_details.dart';
import 'package:work_bench/models/user_data.dart';
import 'package:work_bench/reusable_widgets//custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("assets/images/background_img.jpg"),
        //       fit: BoxFit.cover),
        // ),
        child: SignUpPage(title: 'Sign Up'));
  }
}

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  File _resumeFile;
  File _certificateFile;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();

  // Map<String, dynamic> _dataToUpload;
  final UserData user = UserData();
  final ImagePicker _picker = ImagePicker();
  PickedFile _pickedFile;

  // String _imageUrl;

  // String _userId;

  // String _avatarUrl =
  //     'https://firebasestorage.googleapis.com/v0/b/rent-all-deb4b.appspot.com/o/avatar_1.jpg?alt=media&token=0e21d82b-9c1a-4ae9-ad6e-33bde461b245';

  // @override
  // void initState() {
  // _getCurrentUser();
  // _isLoading = true;
  // getDataOfUser(_userId).then((value) {
  //   _imageUrl = value.data()['image_url'];
  //   _emailText = value.data()['email'];
  //   _firstNameText = value.data()['first'];
  //   _lastNameText = value.data()['last'];
  //   _mobileNumberText = value.data()['mobile'];
  //
  //   _emailController.text = _emailText;
  //   _firstController.text = _firstNameText;
  //   _lastController.text = _lastNameText;
  //   _mobileController.text = _mobileNumberText;
  //   setState(() {
  //     _isLoading = false;
  //   });
  // });
  // super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              child: SingleChildScrollView(child: Consumer<UserAuth>(
                builder: (_, userAuth, __) {
                  return Column(
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
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                                borderSide: BorderSide(color: Colors.white24)
                                //borderSide: const BorderSide(),
                                ),
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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
                                    Icon(Icons.attach_file_outlined,
                                        color: Colors.black87.withOpacity(.6)),
                                    SizedBox(width: 10),
                                    Text(
                                      null != _resumeFile
                                          ? _resumeFile.path.split('/').last
                                          : 'Select Resume',
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
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                                    left: 15, bottom: 11, top: 11, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.attach_file_outlined,
                                        color: Colors.black87.withOpacity(.6)),
                                    SizedBox(width: 10),
                                    Text(
                                      null != _certificateFile
                                          ? _certificateFile.path
                                              .split('/')
                                              .last
                                          : 'Select Certificate',
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
                                  const Radius.circular(30.0),
                                ),
                                border: Border.all(
                                    color: Colors.black87.withOpacity(.6))),
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
                            onPressed: () async {
                              if (_nameController.text == '' ||
                                  _emailController.text == '' ||
                                  _passwordController.text == '' ||
                                  _mobileController.text == '' ||
                                  _birthdayController.text == null ||
                                  _resumeFile == null ||
                                  _certificateFile == null ||
                                  _pickedFile == null) {
                                Fluttertoast.showToast(
                                    msg: "Fill all the fields",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                if (isValidEmail(_emailController.text) ==
                                    false) {
                                  showDialog(
                                    barrierColor: Colors.white.withOpacity(.4),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return customAlertDialog('email');
                                    },
                                  );
                                } else if (isValidPassword(
                                        _passwordController.text) ==
                                    false) {
                                  showDialog(
                                      context: context,
                                      barrierColor:
                                          Colors.white.withOpacity(.4),
                                      builder: (BuildContext context) {
                                        return customAlertDialog('password');
                                      });
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await userAuth
                                      .signUp(
                                          userData: UserData(
                                              name: _nameController.text,
                                              password:
                                                  _passwordController.text,
                                              email: _emailController.text,
                                              birthday:
                                                  _birthdayController.text,
                                              mobile: _mobileController.text,
                                              certificate: '',
                                              profileImage: '',
                                              resume: ''),
                                          onFail: (e) {
                                            print('An error occurred--: $e');
                                            ScaffoldMessenger.of(_scaffoldKey.currentContext)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                Text('Incorrect email or password'),
                                              ),
                                            );
                                          },
                                          onSuccess: (e) {
                                            print('success');
                                          },
                                          profile: File(_pickedFile.path),
                                          resume: _resumeFile,
                                          certificate: _certificateFile)
                                      .then((value) {
                                    Fluttertoast.showToast(
                                        msg: "Sign up successful",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    // if(FirebaseAuth.instance.currentUser!=null)
                                    //   UserAuth().logOut();
                                    // Navigator.pop(_scaffoldKey.currentContext);
                                    // Navigator.pushReplacement(
                                    //     _scaffoldKey.currentContext,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             LogInScreen()));
                                  });
                                }
                              }
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  letterSpacing: 2,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
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
                    ],
                  );
                },
              )),
            ),
    );
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
              : AssetImage('assets/images/avatar_1.jpg')),
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
    _passwordController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }
}
