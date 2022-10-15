import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:work_bench/reusable_widgets/custom_text_field.dart';
import 'package:work_bench/view_models/calculator_view_model.dart';

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("assets/images/background_img.jpg"),
        //       fit: BoxFit.cover),
        // ),
        child: JobsPage(title: 'Calculator'));
  }
}

class JobsPage extends StatefulWidget {
  JobsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  TextEditingController hoursController = TextEditingController();
  String dropDownValue;

  CalculatorViewModel _viewModel = CalculatorViewModel();
  List<String> _employeeList = [];
  List<String> _equipmentList = [];
  final List<Map<String, dynamic>> requests = [];
  bool _isLoading = false;
  List<String> _employeeName = [];
  List<String> _employeeHours = [];
  List<String> _equipmentName = [];

  // List<String> _equipmentHours = [];
  List<String> _equipmentCost = [];
  List<String> _rateEmployee = [];
  List<int> _totalCostEmployee = [];

  // List<int> _rateEquipment = [];
  double _total = 0.0;
  TextEditingController _materialController = TextEditingController();
  TextEditingController _extrasController = TextEditingController();
  String _materialCost = '';
  String _extrasCost = '';

  @override
  void initState() {
    Future.wait({
      _viewModel.getEmployees().then((value) {
        for (int i = 0; i < _viewModel.employeeList.length; i++) {
          String a = _viewModel.employeeList[i].data()['email'];
          String b = _viewModel.employeeList[i].data()['hourlyRate'];
          if (a != null && b != null) {
            _employeeList.add(a);
            _rateEmployee.add(b);
          }
          print(a.toString());
        }
      }),
      _viewModel.getEquipments().then((value) {
        for (int i = 0; i < _viewModel.equipmentList.length; i++) {
          String a = _viewModel.equipmentList[i].data()['name'];
          if (a != null) {
            _equipmentList.add(a);
          }
          print(a.toString());
        }
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF).withOpacity(.4),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          brightness: Brightness.dark,
          backgroundColor: Color(0xFFFFFFFF).withOpacity(.2),
          centerTitle: true,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A4F54)),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Employees',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Name'),
                            Text('Hours'),
                            Text('Total Cost')
                          ],
                        ),
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: _buildEmployeeList,
                        itemCount: _employeeName.length,
                      ),
                      customSeparator(0),
                      Text('Equipments',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Name'),
                            // Text('Hours'),
                            Text('Total Cost')
                          ],
                        ),
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: _buildEquipmentsList,
                        itemCount: _equipmentName.length,
                      ),
                      customSeparator(1),
                      Text('Material',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20)),
                      SizedBox(height: 5),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          decoration: new BoxDecoration(
                              color: Colors.white70.withOpacity(.5),
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(30.0))),
                          child: Text(
                            _materialCost,
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF727070),
                                fontWeight: FontWeight.w900),
                          )),
                      SizedBox(height: 5),
                      Container(
                        width: 80,
                        height: 40,
                        child: CustomTextField(
                          hintText: 'price',
                          inputType: TextInputType.number,
                          textAlignCenter: true,
                          controller: _materialController,
                        ),
                      ),
                      customSeparator(2),
                      Text('Extras',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20)),
                      SizedBox(height: 5),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8.0),
                          decoration: new BoxDecoration(
                              color: Colors.white70.withOpacity(.5),
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(30.0))),
                          child: Text(
                            _extrasCost,
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF727070),
                                fontWeight: FontWeight.w900),
                          )),
                      SizedBox(height: 5),
                      Container(
                        width: 80,
                        height: 40,
                        child: CustomTextField(
                          hintText: 'price',
                          inputType: TextInputType.number,
                          textAlignCenter: true,
                          controller: _extrasController,
                        ),
                      ),
                      customSeparator(3),
                      SizedBox(height: 10.0),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: new BoxDecoration(
                              color: Colors.white70.withOpacity(.5),
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(30.0))),
                          child: Text(
                            'Grand Total: $_total',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF727070),
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ));
  }

  Widget _buildEmployeeList(BuildContext context, int index) {
    // return itemCard(index, _newSnapshot[index]);
    return itemCard(
        index: index,
        x1: _employeeName[index],
        x2: _employeeHours[index],
        x3: _totalCostEmployee[index]);
  }

  Widget _buildEquipmentsList(BuildContext context, int index) {
    // return itemCard(index, _newSnapshot[index]);
    return itemCard(
        index: index, x1: _equipmentName[index], x2: _equipmentCost[index]);
  }

  // Widget itemCard(int index, QueryDocumentSnapshot x1) {
  Widget itemCard({int index, String x1, String x2, int x3}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: Colors.white70.withOpacity(.5),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(30.0))),
                  child: Text(
                    x1,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF727070),
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              SizedBox(width: 3),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                      color: Colors.white70.withOpacity(.5),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(30.0))),
                  child: Text(
                    x2,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF727070),
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              x3 != null ? SizedBox(width: 3) : SizedBox(width: 0),
              x3 != null
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8.0),
                        decoration: new BoxDecoration(
                            color: Colors.white70.withOpacity(.5),
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(30.0))),
                        child: Text(
                          "$x3",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF727070),
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    )
                  : SizedBox(width: 0),
            ]),
      ),
    );
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

  Widget customSeparator(int number) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: Divider(color: Colors.black, height: 36, thickness: 1.5)),
      ),
      GestureDetector(
          onTap: () {
            if (number == 0) {
              //  add employee
              showDialog(
                  context: context,
                  barrierColor: Colors.white.withOpacity(.4),
                  builder: (BuildContext context) {
                    return customAlertDialog(true, _employeeList);
                  });
            } else if (number == 1) {
              //  add equipment
              showDialog(
                  context: context,
                  barrierColor: Colors.white.withOpacity(.4),
                  builder: (BuildContext context) {
                    return customAlertDialog(false, _equipmentList);
                  });
            } else if (number == 2 && _materialController.text != '') {
              setState(() {
                _total += double.parse(_materialController.text);
                if (_materialCost == '') {
                  _materialCost += _materialController.text;
                } else {
                  _materialCost += " + ${_materialController.text} ";
                }
                _materialController.text = '';
              });
            } else if (number == 3 && _extrasController.text != '') {
              setState(() {
                _total += double.parse(_extrasController.text);
                if (_extrasCost == '') {
                  _extrasCost += _extrasController.text;
                } else {
                  _extrasCost += " + ${_extrasController.text} ";
                }
                _extrasController.text = '';
              });
            }
          },
          child: Text("+", style: TextStyle(fontSize: 50))),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Divider(color: Colors.black, height: 36, thickness: 1.5)),
      ),
    ]);
  }

  Widget customAlertDialog(bool isEmployee, List<String> list) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      backgroundColor: Color(0xFF4A4F54).withOpacity(.7),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: Text(
        isEmployee ? "Add Employee" : "Add Equipment",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
      ),
      content: StatefulBuilder(builder: (context, setState) {
        return Container(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // CustomTextField(
                //     autoFocus: true,
                //     prefixIcon: Icon(Icons.person_outline_rounded),
                //     hintText: isEmployee?'Employee Name':'Equipment Name',
                //     inputType: TextInputType.name,
                //     controller: nameController),
                DecoratedBox(
                    decoration: ShapeDecoration(
                      color: Colors.white70.withOpacity(.5),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: Colors.black87),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: DropdownButton<String>(
                        value: dropDownValue,
                        hint: Text('Select Employee/Equipment'),
                        items: list.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dropDownValue = value;
                          });
                        },
                      ),
                    )),
                SizedBox(height: 5),
                CustomTextField(
                    prefixIcon: Icon(Icons.timer),
                    hintText: isEmployee ? 'Employee Hours' : 'Equipment Cost',
                    inputType: TextInputType.number,
                    controller: hoursController),
                SizedBox(height: 5),
              ],
            ));
      }),
      actions: [
        TextButton(
          child: Text(
            'Add',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
          ),
          onPressed: () {
            if (hoursController.text != '') {
              setState(() {
                if (isEmployee) {
                  _employeeName.add(dropDownValue);
                  _employeeHours.add(hoursController.text);
                  _totalCostEmployee.add(int.parse(hoursController.text) *
                      int.parse(_rateEmployee[list.indexOf(dropDownValue)]));
                  _total += int.parse(hoursController.text) *
                      int.parse(_rateEmployee[list.indexOf(dropDownValue)]);
                } else {
                  _equipmentName.add(dropDownValue);
                  _equipmentCost.add(hoursController.text);
                  // _equipmentHours.add(hoursController.text);
                  // _rateEquipment.add(int.parse(hoursController.text)*5);
                  _total += int.parse(hoursController.text);
                }
              });
              hoursController.text = '';
              dropDownValue = null;
            } else {
              print('Fill in the details');
              Fluttertoast.showToast(
                  msg: "Fill in the details!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xFF4A4F54),
                  textColor: Colors.white,
                  fontSize: 16.0);
              hoursController.text = '';
              dropDownValue = null;
            }
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

  // Future<void> addDataToCloud(
  //     Map<String, dynamic> dataToUpload, QueryDocumentSnapshot x2) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('approved_items');
  //   collectionReference.add(dataToUpload).then((value) {
  //     // _approvedItemId = value.id;
  //   }).catchError((error, stackTrace) {
  //     print("FAILED TO ADD DATA: $error");
  //     print("STACKTRACE IS:  $stackTrace");
  //   });
  //   // deleting data from pending approvals
  //   FirebaseFirestore.instance.collection('acquired_items').doc(x2.id).delete();
  // }
  //
  // Future<dynamic> getDataOfItems(String emailRequired) async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("acquired_items")
  //       .where("lessor_email", isEqualTo: emailRequired)
  //       .get();
  //   _snapshot = querySnapshot.docs;
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
  //
  // String getUserEmail() {
  //   final User user = _auth.currentUser;
  //   _uId = user.uid;
  //   return user.email;
  // }

  // Future<DocumentSnapshot> getDataOfUser(String userIdRequired) async {
  //   var docRef =
  //       FirebaseFirestore.instance.collection("users").doc(userIdRequired);
  //   await docRef.get().then((value) {
  //     setState(() {
  //       _userSnapshot = value;
  //     });
  //   });
  //   return _userSnapshot;
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

  @override
  void dispose() {
    hoursController.dispose();
    super.dispose();
  }
}
