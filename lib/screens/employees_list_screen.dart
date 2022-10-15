import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:work_bench/models/employee.dart';
import 'package:work_bench/reusable_widgets//custom_text_field.dart';
import 'package:work_bench/screens/employee_info_screen.dart';
import 'package:work_bench/view_models/employee_list_view_model.dart';

class EmployeesListScreen extends StatefulWidget {
  EmployeesListScreen({Key key}) : super(key: key);

  @override
  _EmployeesListScreenState createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreen> {
  List<String> attachments = [];
  bool isHTML = false;
  String _recipientPassword = '';
  final _recipientController = TextEditingController();
  final _subjectController =
      TextEditingController(text: 'WorkBench Employment notification');

  bool _isLoading = false;
  EmployeeListViewModel _viewModel = EmployeeListViewModel();

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _viewModel.getDataOfEmployees().then((value) {
      setState(() {
        _isLoading = false;
      });
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
                "Employees",
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            barrierColor: Colors.white.withOpacity(.4),
                            builder: (BuildContext context) {
                              return customAlertDialog(dialogType: 'add');
                            });
                      },
                      child: Icon(
                        Icons.add,
                        size: 28.0,
                        color: Colors.black,
                      ),
                    )),
              ],
            ),
            body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF4A4F54)),
                    ),
                  )
                : buildListView(_viewModel)
            // _viewModel.employees.length == 0
            //         ? Center(
            //           child: Text(
            //             'No Employees...',
            //             style: TextStyle(
            //               fontSize: 20,
            //               color: Colors.black,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         )
            //         : buildListView(_viewModel)
            ));
  }

  Widget buildListView(EmployeeListViewModel viewModel) {
    return Container(
        padding: EdgeInsets.all(10),
        child: ChangeNotifierProvider<EmployeeListViewModel>(
          create: (context) => viewModel,
          child:
              Consumer<EmployeeListViewModel>(builder: (context, model, child) {
            if (model.employees.length == 0)
              return Center(
                  child: Text(
                'No Employees...',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ));
            else
              return ListView.builder(
                itemBuilder: _buildRequestList,
                itemCount: model.employees.length,
              );
          }),
        ));
  }

  // Future<void> _pullRefresh() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   _viewModel.getDataOfEmployees().then((value) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  Widget _buildRequestList(BuildContext context, int index) {
    // return itemCard(index, _newSnapshot[index]);
    return itemCard(index, _viewModel.employees[index]);
  }

  // void getSnapshotsToDisplay() {
  //   for (QueryDocumentSnapshot s in _snapshot) {
  //     final Timestamp t1 = s.data()['end'];
  //     // show only those posts that have past end date so that owner gets paid after he gets his product back...
  //     final endDate = t1.toDate();
  //     if (endDate.isBefore(DateTime.now())) {
  //       _newSnapshot.add(s);
  //     }
  //   }
  // }

  // Widget itemCard(int index, QueryDocumentSnapshot x1) {
  Widget itemCard(int index, Employee x1) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmployeeInfoScreen(employee: x1)));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        clipBehavior: Clip.antiAlias,
        color: Color(0xFF4A4F54).withOpacity(.7),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                        radius: 40,
                        backgroundImage: x1.profileImage != null &&
                                x1.profileImage != ''
                            ? NetworkImage(x1.profileImage)
                            : AssetImage('assets/images/avatar_1.jpg')),
                    SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            x1.name != null ? x1.name : 'No Name',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            x1.email,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          Text(
                            x1.mobile != null ? x1.mobile : 'No mobile Number',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierColor: Colors.white.withOpacity(.4),
                      builder: (BuildContext context) {
                        return customAlertDialog(
                            dialogType: 'rate', index: index);
                      });
                },
                child: Container(
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Text(
                    x1.hourlyRate != null ? "\$${x1.hourlyRate}" : "\$?",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customAlertDialog({String dialogType, int index}) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      backgroundColor: Color(0xFF4A4F54).withOpacity(.7),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: dialogType == 'add'
          ? Text(
              "Add Employee",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            )
          : Text(
              "Set Hourly Rate",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
      content: StatefulBuilder(builder: (context, setState) {
        return Container(
          width: 280,
          child: CustomTextField(
              prefixIcon: dialogType == 'add'
                  ? Icon(Icons.email_outlined)
                  : Icon(Icons.attach_money_outlined),
              hintText: dialogType == 'add' ? 'Email' : 'Rate',
              inputType: dialogType == 'add'
                  ? TextInputType.emailAddress
                  : TextInputType.number,
              controller: _recipientController),
        );
      }),
      actions: [
        TextButton(
          child: Text(
            dialogType == 'add' ? 'Invite' : 'Set Rate',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
          ),
          onPressed: () {
            _recipientPassword = "Emp_${getRandomString(4)}@";
            if (dialogType == 'add') {
              _viewModel.addEmployee(Employee(
                  email: _recipientController.text,
                  password: _recipientPassword,
                  employerId: FirebaseAuth.instance.currentUser.uid));
              send();
              // _viewModel.addEmployee(userData: Employee(email: controller.text, password: 'Test_123@', employerId: FirebaseAuth.instance.currentUser.uid), onSuccess: () {}, onFail: (_) {});
            } else {
              print(_viewModel.empIds[index]);
              _viewModel.setEmployeeRate(
                  _viewModel.empIds[index], _recipientController.text);
            }
            _recipientController.text = '';
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF4A4F54)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<void> send() async {
    final Email email = Email(
      body:
          "You are added as employee at 'Work Bench'.\nYour password to login to 'Work Bench' app is: \n $_recipientPassword",
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
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
    _isLoading = false;
    super.dispose();
  }
}
