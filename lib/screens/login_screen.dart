import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'file:///D:/Flutter_Apps_Fiverr/work_bench/lib/view_models/user_authentication_details.dart';
import 'package:work_bench/models/user_data.dart';
import 'package:work_bench/reusable_widgets/custom_text_field.dart';
import 'package:work_bench/Screens/signup_screen.dart';

class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("assets/images/background_img.jpg"),
        //       fit: BoxFit.cover),
        // ),
        child: LogInPage());
  }
}

class LogInPage extends StatefulWidget {
  LogInPage({Key key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFFFFFFF).withOpacity(.4),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4A4F54))),
              )
            : SafeArea(
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                      child: Consumer<UserAuth>(builder: (_, userAuth, __) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            // Image.asset('assets/images/img_back.jpg', height: 100, width: 100),
                            SizedBox(height: 10.0),
                            Text(
                              'Work Bench',
                              style: TextStyle(
                                  fontSize: 52,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: CustomTextField(
                                controller: emailController,
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: 'Email',
                                inputType: TextInputType.emailAddress,
                                autoCorrect: false,
                                enableSuggestions: false,
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: CustomTextField(
                                controller: passwordController,
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
                              height: 15.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () {
                                    isConnected().then((value) async {
                                      if (value == false) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('No internet connection!'),
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        userAuth.signIn(
                                            userData: UserData(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text),
                                            onFail: (e) {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              ScaffoldMessenger.of(_scaffoldKey
                                                      .currentContext)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Incorrect email or password'),
                                                ),
                                              );
                                              print("Unable to sign in! $e");
                                            },
                                            onSuccess: () {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              // isEmployer().then((value) {
                                              //   if(value==true) {
                                              //     print('logged in using employer');
                                              //     Navigator.pushReplacement(_scaffoldKey.currentContext, MaterialPageRoute(builder: (context) => MainPageEmployer()));
                                              //     // return MainPageEmployer();
                                              //   } else {
                                              //     print('logged in using employee');
                                              //     Navigator.pushReplacement(_scaffoldKey.currentContext, MaterialPageRoute(builder: (context) => MainPageEmployee()));
                                              //     // return MainPageEmployee();
                                              //   }
                                              // });
                                              // if(userAuth.user.isEmployer) {
                                              //   Navigator.pushReplacement(_scaffoldKey.currentContext,
                                              //       MaterialPageRoute(builder: (context) => MainPageEmployer()));
                                              // } else {
                                              //   Navigator.pushReplacement(_scaffoldKey.currentContext,
                                              //       MaterialPageRoute(builder: (context) => MainPageEmployee()));
                                              // }
                                            });
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Login',
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
                                              Color(0xFF4A4F54)
                                                  .withOpacity(0.7)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(20.0),
                                        ),
                                      ))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 30.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      isConnected().then((value) {
                                        if (value == false) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'No internet connection!'),
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            barrierColor:
                                                Colors.white.withOpacity(.4),
                                            builder: (BuildContext context) {
                                              return forgotPasswordAlert(
                                                  userAuth);
                                            },
                                          );
                                        }
                                      });
                                    },
                                    child: Text(
                                      'forgot password?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 60),
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Want to create employer account?",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()),
                                      );
                                    },
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }));
                }),
              ));
  }

  Future<bool> isEmployer() async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance
          .doc("users/${FirebaseAuth.instance.currentUser.uid}")
          .get()
          .then((doc) {
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
        .hasMatch(emailController.text);
  }

  Widget forgotPasswordAlert(UserAuth userAuth) {
    String emailAddress;
    return AlertDialog(
      backgroundColor: Color(0xFF4A4F54).withOpacity(.7),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Row(
        children: <Widget>[
          Icon(
            Icons.reset_tv,
            color: Colors.red,
          ),
          Text(
            "Password Reset",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      insetPadding: EdgeInsets.all(10),
      content: Container(
        width: 300,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            setState(() {
              emailAddress = value;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white70,
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.white24)
                //borderSide: const BorderSide(),
                ),
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: 'Enter Your Email',
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'Reset Password',
            style: TextStyle(
                color: Colors.white, backgroundColor: Color(0xFF4A4F54)),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
            if (emailAddress != null) {
              userAuth.resetPassword(emailAddress);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Mail is sent! Reset your password...'),
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Email is not registered yet.'),
              ));
            }
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
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }
}
