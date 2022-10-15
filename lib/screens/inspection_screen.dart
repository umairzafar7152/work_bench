import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:work_bench/models/inspection.dart';
import 'package:work_bench/reusable_widgets/custom_text_field.dart';
import 'package:work_bench/view_models/inspection_view_model.dart';

class InspectionScreen extends StatefulWidget {
  InspectionScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InspectionScreenState createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  TextEditingController _noteController = TextEditingController();
  List<String> _list = [];
  String dropDownValue;
  InspectionViewModel _viewModel = InspectionViewModel();
  Inspection _inspection;
  bool _isLoading = false;
  var format = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _inspection = Inspection();
    _inspection.uid = FirebaseAuth.instance.currentUser.uid;
    _inspection.email = FirebaseAuth.instance.currentUser.email;
    _inspection.date = format.format(DateTime.now());
    _viewModel.getEquipmentsList().then((value) {
      for (int i = 0; i < _viewModel.list.length; i++) {
        _list.add(_viewModel.list[i].name);
      }
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
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              brightness: Brightness.dark,
              backgroundColor: Color(0xFFFFFFFF).withOpacity(.2),
              centerTitle: true,
              title: Text(
                'Inspection',
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
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          DecoratedBox(
                              decoration: ShapeDecoration(
                                color: Colors.white70.withOpacity(.5),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                      color: Colors.black87),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                child: Center(
                                  child: DropdownButton<String>(
                                    value: dropDownValue,
                                    hint: Text('Select Equipment'),
                                    items: _list.map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (x) {
                                      setState(() {
                                        dropDownValue = x;
                                        _inspection.equipmentName = x;
                                      });
                                    },
                                  ),
                                ),
                              )),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Visual Inspection',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 20)),
                          ),
                          Table(
                            // defaultColumnWidth: FixedColumnWidth(120.0),
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              TableRow(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFC4C4C4).withOpacity(.7)),
                                  children: [
                                    Column(children: [
                                      Text('Item',
                                          style: TextStyle(fontSize: 20.0))
                                    ]),
                                    Column(children: [
                                      Text('Condition',
                                          style: TextStyle(fontSize: 20.0))
                                    ]),
                                  ]),
                              customTableRow('Engine', 'engine'),
                              customTableRow('Frame', 'frame'),
                              customTableRow('Boom', 'boom'),
                              customTableRow('Stick', 'stick'),
                              customTableRow('ROPS/FOPS', 'rops'),
                              customTableRow('Hyd. Cylinders', 'hydCylinders'),
                              customTableRow('Latches/locks', 'latches'),
                              customTableRow('Bucket/blade', 'bucket'),
                              customTableRow('Tires', 'tires'),
                              customTableRow('Rubber track', 'rubberTrack'),
                              customTableRow('Linkages', 'linkages'),
                              customTableRow('Undercarriage', 'underCarriage'),
                              customTableRow('work tool', 'workTool'),
                              customTableRow('Final drives', 'finalDrives')
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Operational Inspection',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 20)),
                          ),
                          Table(
                            // defaultColumnWidth: FixedColumnWidth(120.0),
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              TableRow(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFC4C4C4).withOpacity(.7)),
                                  children: [
                                    Column(children: [
                                      Text('Item',
                                          style: TextStyle(fontSize: 20.0))
                                    ]),
                                    Column(children: [
                                      Text('Condition',
                                          style: TextStyle(fontSize: 20.0))
                                    ]),
                                  ]),
                              customTableRow('Engine', 'opEngine'),
                              customTableRow(
                                  'Hyd. Cylinders', 'opHydCylinders'),
                              customTableRow('Track speed', 'opTrackSpeed'),
                              customTableRow('Boom drift', 'opBoomDrift'),
                              customTableRow(
                                  'Bushing movement', 'opBushingMovement'),
                              customTableRow('Leaks, drips', 'opLeaksDrips')
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Machine Specific',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 20)),
                          ),
                          Table(
                            // defaultColumnWidth: FixedColumnWidth(120.0),
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              TableRow(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFC4C4C4).withOpacity(.7)),
                                  children: [
                                    Column(children: [
                                      Text('Item',
                                          style: TextStyle(fontSize: 20.0))
                                    ]),
                                    Column(children: [
                                      Text('Condition',
                                          style: TextStyle(fontSize: 20.0))
                                    ]),
                                  ]),
                              customTableRow('Skid steer chain case',
                                  'skidSteerChainCase'),
                              customTableRow(
                                  'Skid steer driveline', 'skidSteerDriveline'),
                              customTableRow('Wheel loader articulation joint',
                                  'wheelLoaderArticulationJoint'),
                              customTableRow('Excavator swing bearing',
                                  'excavatorSwingBearing'),
                              customTableRow('Dozer PAT blade', 'dozerPatBlade')
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Add a note',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 20)),
                          ),
                          SizedBox(height: 10.0),
                          CustomTextField(
                              prefixIcon: Icon(Icons.text_fields_outlined),
                              hintText: 'Add Note',
                              inputType: TextInputType.multiline,
                              controller: _noteController,
                              maxLines: 5),
                          SizedBox(height: 10.0),
                          Center(
                            child: ElevatedButton(
                              child: Text("Submit",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                              onPressed: () {
                                if (dropDownValue == null) {
                                  Fluttertoast.showToast(
                                      msg: "Select an Equipment",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                                // else if (_inspection.equipmentName == null ||
                                //     _inspection.date == null ||
                                //     _inspection.hydCylinders == null ||
                                //     _inspection.stick == null ||
                                //     _inspection.rops == null ||
                                //     _inspection.frame == null ||
                                //     _inspection.engine == null ||
                                //     _inspection.boom == null ||
                                //     _inspection.latches == null ||
                                //     _inspection.bucket == null ||
                                //     _inspection.rubberTrack == null ||
                                //     _inspection.tires == null ||
                                //     _inspection.linkages == null ||
                                //     _inspection.underCarriage == null ||
                                //     _inspection.workTool == null ||
                                //     _inspection.finalDrives == null ||
                                //     _inspection.opEngine == null ||
                                //     _inspection.opHydCylinders == null ||
                                //     _inspection.opTrackSpeed == null ||
                                //     _inspection.opBoomDrift == null ||
                                //     _inspection.opBushingMovement == null ||
                                //     _inspection.opLeaksDrips == null ||
                                //     _inspection.skidSteerChainCase == null ||
                                //     _inspection.skidSteerDriveline == null ||
                                //     _inspection.wheelLoaderArticulationJoint ==
                                //         null ||
                                //     _inspection.excavatorSwingBearing == null ||
                                //     _inspection.dozerPatBlade == null ||
                                //     _inspection.uid == null) {
                                //   Fluttertoast.showToast(
                                //       msg: "Fill all fields",
                                //       toastLength: Toast.LENGTH_LONG,
                                //       gravity: ToastGravity.BOTTOM,
                                //       timeInSecForIosWeb: 1,
                                //       backgroundColor: Colors.red,
                                //       textColor: Colors.white,
                                //       fontSize: 16.0);
                                // }
                                else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _inspection.note = _noteController.text;
                                  _viewModel
                                      .addInspection(_inspection)
                                      .then((value) {
                                    Fluttertoast.showToast(
                                        msg: "Inspection Record added",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white70.withOpacity(.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )));
  }

  TableRow customTableRow(String itemName, String nameInspection) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(itemName,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      CheckboxGroup(
        padding: EdgeInsets.only(left: 5),
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        orientation: GroupedButtonsOrientation.HORIZONTAL,
        labels: <String>[
          "Excellent",
          "Good",
          "Poor",
        ],
        activeColor: Color(0xFF4A4F54),
        onSelected: (List selected) => setState(() {
          if (selected.length > 1) {
            selected.removeAt(0);
          } else {
            addRecord(nameInspection, selected[0]);
            print("only one: ${selected[0]}");
          }
          // _checked = selected;
        }),
      )
    ]);
  }

  void addRecord(String itemName, String value) {
    if (itemName == 'dozerPatBlade') {
      _inspection.dozerPatBlade = value;
    } else if (itemName == 'excavatorSwingBearing') {
      _inspection.excavatorSwingBearing = value;
    } else if (itemName == 'wheelLoaderArticulationJoint') {
      _inspection.wheelLoaderArticulationJoint = value;
    } else if (itemName == 'skidSteerDriveline') {
      _inspection.skidSteerDriveline = value;
    } else if (itemName == 'skidSteerChainCase') {
      _inspection.skidSteerChainCase = value;
    } else if (itemName == 'opLeaksDrips') {
      _inspection.opLeaksDrips = value;
    } else if (itemName == 'opBushingMovement') {
      _inspection.opBushingMovement = value;
    } else if (itemName == 'opBoomDrift') {
      _inspection.opBoomDrift = value;
    } else if (itemName == 'opTrackSpeed') {
      _inspection.opTrackSpeed = value;
    } else if (itemName == 'opHydCylinders') {
      _inspection.opHydCylinders = value;
    } else if (itemName == 'opEngine') {
      _inspection.opEngine = value;
    } else if (itemName == 'finalDrives') {
      _inspection.finalDrives = value;
    } else if (itemName == 'workTool') {
      _inspection.workTool = value;
    } else if (itemName == 'underCarriage') {
      _inspection.underCarriage = value;
    } else if (itemName == 'linkages') {
      _inspection.linkages = value;
    } else if (itemName == 'rubberTrack') {
      _inspection.rubberTrack = value;
    } else if (itemName == 'tires') {
      _inspection.tires = value;
    } else if (itemName == 'bucket') {
      _inspection.bucket = value;
    } else if (itemName == 'latches') {
      _inspection.latches = value;
    } else if (itemName == 'boom') {
      _inspection.boom = value;
    } else if (itemName == 'engine') {
      _inspection.engine = value;
    } else if (itemName == 'frame') {
      _inspection.frame = value;
    } else if (itemName == 'rops') {
      _inspection.rops = value;
    } else if (itemName == 'stick') {
      _inspection.stick = value;
    } else if (itemName == 'hydCylinders') {
      _inspection.hydCylinders = value;
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
    _noteController.dispose();
    super.dispose();
  }
}
