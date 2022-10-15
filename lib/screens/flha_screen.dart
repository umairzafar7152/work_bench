import 'dart:collection';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:work_bench/models/flha.dart';
import 'package:work_bench/reusable_widgets//custom_text_field.dart';
import 'package:location/location.dart' as Location;
import 'package:work_bench/view_models/flha_view_model.dart';
import 'package:image/image.dart' as encoder;

class FLHAScreen extends StatefulWidget {
  FLHAScreen({Key key}) : super(key: key);

  @override
  _FLHAScreenState createState() => _FLHAScreenState();
}

class _FLHAScreenState extends State<FLHAScreen> {
  FlhaViewModel _viewModel = FlhaViewModel();
  Flha _flha;
  final List<Map<String, dynamic>> requests = [];
  bool _isLoading = false;
  TextEditingController _companyController = TextEditingController();
  TextEditingController _workController = TextEditingController();
  TextEditingController _permitController = TextEditingController();
  TextEditingController _taskAlertController = TextEditingController();
  TextEditingController _hazardAlertController = TextEditingController();
  TextEditingController _priorityAlertController = TextEditingController();
  TextEditingController _planAlertController = TextEditingController();
  TextEditingController _musterController = TextEditingController();
  List<Map<String, String>> _tasksList = [];
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  GoogleMapController _mapController;
  Set<Marker> _markers = HashSet<Marker>();
  var _lat;
  var _long;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  var format = DateFormat('yyyy-MM-dd');

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void initState() {
    _flha = Flha();
    _flha.uid = FirebaseAuth.instance.currentUser.uid;
    _flha.email = FirebaseAuth.instance.currentUser.email;
    _flha.date = format.format(DateTime.now());
    setState(() {
      _isLoading = true;
    });
    isConnected().then((value) {
      if (value) {
        getLocationPermissions().then((value1) {
          if (value1) {
            myCurrentLocation().then((_) async {
              // _musterAddress = await _getLocationAddress(_latMuster, _longMuster, _musterAddress);
              // _locationAddress =
              //     await _getLocationAddress(_lat, _long, _locationAddress);
              setState(() {
                _isLoading = false;
              });
            });
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
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
                'Field Level Hazard Assessment',
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
                          CustomTextField(
                            prefixIcon: Icon(Icons.account_balance),
                            hintText: 'Company Name',
                            inputType: TextInputType.name,
                            controller: _companyController,
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            prefixIcon: Icon(Icons.work_outline_outlined),
                            hintText: 'Work to be done',
                            inputType: TextInputType.name,
                            controller: _workController,
                          ),
                          SizedBox(height: 10),
                          Text('Task Location',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierColor: Colors.white.withOpacity(.4),
                                  builder: (BuildContext context) {
                                    return customAlertDialog('Task Location');
                                  });
                            },
                            child: Container(
                              width: double.infinity,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  child: Text(
                                    _flha.taskAddress != null
                                        ? _flha.taskAddress
                                        : 'Select Task Location',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87.withOpacity(.6)),
                                  )),
                              decoration: BoxDecoration(
                                  color: Colors.white70.withOpacity(.5),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0)),
                                  border: Border.all(
                                      color: Colors.black87.withOpacity(.6))),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Muster Point',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          CustomTextField(
                            prefixIcon: Icon(Icons.work_outline_outlined),
                            hintText: 'Select Muster Location',
                            inputType: TextInputType.name,
                            controller: _musterController,
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     showDialog(
                          //         context: context,
                          //         barrierColor: Colors.white.withOpacity(.4),
                          //         builder: (BuildContext context) {
                          //           return customAlertDialog('Muster Location');
                          //         });
                          //   },
                          //   child: Container(
                          //     width: double.infinity,
                          //     child: Padding(
                          //         padding: const EdgeInsets.only(
                          //             left: 15, bottom: 11, top: 11, right: 15),
                          //         child: Text(
                          //           _flha.musterAddress != null
                          //               ? _flha.musterAddress
                          //               : 'Select Muster Location',
                          //           style: TextStyle(
                          //               fontSize: 16,
                          //               color: Colors.black87.withOpacity(.6)),
                          //         )),
                          //     decoration: BoxDecoration(
                          //         color: Colors.white70.withOpacity(.5),
                          //         borderRadius: const BorderRadius.all(
                          //             const Radius.circular(30.0)),
                          //         border: Border.all(
                          //             color: Colors.black87.withOpacity(.6))),
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          CustomTextField(
                            prefixIcon: Icon(Icons.text_fields_outlined),
                            hintText: 'Permit No.',
                            inputType: TextInputType.number,
                            controller: _permitController,
                          ),
                          SizedBox(height: 10),
                          customCheckGroup('PPE Inspected', 'ppeInspected'),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                                'Identify and prioritize the tasks and hazards below, then identify the plans to eliminate/control the hazards',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900)),
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(
                                    label: Text('Tasks',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900))),
                                DataColumn(
                                    label: Text('Hazards',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900))),
                                DataColumn(
                                    label: Text('Priority',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900))),
                                DataColumn(
                                    label: Text('Plans to Eliminate/Control',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900))),
                              ],
                              rows:
                                  _tasksList // Loops through dataColumnText, each iteration assigning the value to element
                                      .map(
                                        ((element) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(element["task"],
                                                    style: TextStyle(
                                                        fontSize: 14))),
                                                //Extracting from Map element the value
                                                DataCell(Text(element["hazard"],
                                                    style: TextStyle(
                                                        fontSize: 14))),
                                                DataCell(Text(
                                                    element["priority"],
                                                    style: TextStyle(
                                                        fontSize: 14))),
                                                DataCell(Text(element["plan"],
                                                    style: TextStyle(
                                                        fontSize: 14))),
                                              ],
                                            )),
                                      )
                                      .toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: ElevatedButton(
                              child: Text("Add Record",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierColor: Colors.white.withOpacity(.4),
                                    builder: (BuildContext context) {
                                      return customRecordDialog();
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white70.withOpacity(.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          customCheckGroup(
                              'Has a pre-use inspection of tools/equipment been completed?',
                              'preUseInspectionCompleted'),
                          SizedBox(height: 10),
                          customCheckGroup(
                              'Warning ribbon needed?', 'warningRibbon'),
                          SizedBox(height: 10),
                          customCheckGroup(
                              'Is the worker working alone?', 'workingAlone'),
                          SizedBox(height: 10),
                          Text(
                            'Job Completion',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          customCheckGroup('Are all permit(s) closed out?',
                              'permitClosedOut'),
                          SizedBox(height: 10),
                          customCheckGroup(
                              'Was the area cleaned up at the end of job/shift?',
                              'areaCleanedUp'),
                          SizedBox(height: 10),
                          customCheckGroup('Are there hazards remaining?',
                              'hazardsRemaining'),
                          SizedBox(height: 10),
                          customCheckGroup('Were there any incidents/injuries?',
                              'incidentInjuries'),
                          SizedBox(height: 10),
                          Text(
                            'Signature',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            child: Text("Clear Signature",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white70.withOpacity(.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                            onPressed: () {
                              setState(() => _controller.clear());
                            },
                          ),
                          SizedBox(height: 5),
                          Signature(
                            controller: _controller,
                            width: 300,
                            height: 300,
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: ElevatedButton(
                              child: Text("Submit",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                              onPressed: () async {
                                // if (_companyController.text == '' ||
                                //     _workController.text == '' ||
                                //     _permitController.text == '' ||
                                //     _musterController.text == '' ||
                                //     _flha.taskLocation == null ||
                                //     _flha.ppeInspected == null ||
                                //     _flha.workingAlone == null ||
                                //     _flha.warningRibbon == null ||
                                //     _flha.preUseInspectionCompleted == null ||
                                //     _flha.permitClosedOut == null ||
                                //     _flha.incidentInjuries == null ||
                                //     _flha.hazardsRemaining == null ||
                                //     _flha.areaCleanedUp == null ||
                                //     _controller.isEmpty) {
                                //   Fluttertoast.showToast(
                                //       msg: "Fill all fields",
                                //       toastLength: Toast.LENGTH_LONG,
                                //       gravity: ToastGravity.BOTTOM,
                                //       timeInSecForIosWeb: 1,
                                //       backgroundColor: Colors.red,
                                //       textColor: Colors.white,
                                //       fontSize: 16.0);
                                // } else if (_tasksList.length == 0) {
                                //   Fluttertoast.showToast(
                                //       msg: "Add record of tasks!",
                                //       toastLength: Toast.LENGTH_LONG,
                                //       gravity: ToastGravity.BOTTOM,
                                //       timeInSecForIosWeb: 1,
                                //       backgroundColor: Colors.red,
                                //       textColor: Colors.white,
                                //       fontSize: 16.0);
                                // } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                var signatureImage =
                                    await _controller.toImage();
                                ByteData data =
                                    await signatureImage.toByteData();
                                Uint8List listData = data.buffer.asUint8List();
                                int height = signatureImage.height;
                                int width = signatureImage.width;
                                encoder.Image toEncodeImage =
                                    encoder.Image.fromBytes(
                                        width, height, listData);
                                encoder.JpegEncoder jpgEncoder =
                                    encoder.JpegEncoder();
                                List<int> encodedImage =
                                    jpgEncoder.encodeImage(toEncodeImage);

                                // await _viewModel.uploadSignature(Uint8List.fromList(encodedImage)).then((value) {
                                _flha.musterPoint = _musterController.text;
                                _flha.permitNo = _permitController.text;
                                _flha.companyName = _companyController.text;
                                _flha.workToBeDone = _workController.text;
                                _viewModel
                                    .addRecord(
                                        _flha,
                                        _tasksList,
                                        Uint8List.fromList(encodedImage),
                                        FirebaseAuth.instance.currentUser.email)
                                    .then((_) {
                                  Fluttertoast.showToast(
                                      msg: "FLHA Record added",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                                Navigator.pop(context);
                                // });
                                // }
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

  List<TableRow> customTableRow(List<Map<String, String>> taskList) {
    List<TableRow> localList = [];
    for (int i = 0; i < taskList.length; i++) {
      localList.add(TableRow(children: [
        Text(taskList[i]['task'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        Text(taskList[i]['hazard'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        Text(taskList[i]['priority'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        Text(taskList[i]['plan'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      ]));
    }
    return localList;
  }

  // Widget customCheckGroup(String itemName, String nameFlha) {
  //   List<String> _checked = [];
  //   if (itemName == 'ppeInspected') {
  //     _checked.add(_flha.ppeInspected);
  //   } else if (itemName == 'preUseInspectionCompleted') {
  //     _checked.add(_flha.preUseInspectionCompleted);
  //   } else if (itemName == 'warningRibbon') {
  //     _checked.add(_flha.warningRibbon);
  //   } else if (itemName == 'workingAlone') {
  //     _checked.add(_flha.workingAlone);
  //   } else if (itemName == 'permitClosedOut') {
  //     _checked.add(_flha.permitClosedOut);
  //   } else if (itemName == 'areaCleanedUp') {
  //     _checked.add(_flha.areaCleanedUp);
  //   } else if (itemName == 'hazardsRemaining') {
  //     _checked.add(_flha.hazardsRemaining);
  //   } else if (itemName == 'incidentInjuries') {
  //     _checked.add(_flha.incidentInjuries);
  //   }
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       Expanded(
  //           child: Text(itemName,
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
  //       CheckboxGroup(
  //         padding: EdgeInsets.only(left: 5),
  //         labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
  //         orientation: GroupedButtonsOrientation.HORIZONTAL,
  //         labels: <String>["Yes", "No"],
  //         checked: _checked,
  //         activeColor: Color(0xFF4A4F54),
  //         onSelected: (List selected) => setState(() {
  //           if (selected.length > 1) {
  //             selected.removeAt(0);
  //           }
  //           _checked = selected;
  //           addRecord(nameFlha, _checked[0]);
  //         }),
  //       )
  //     ],
  //   );
  // }

  Widget customCheckGroup(String itemName, String nameFlha) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            child: Text(itemName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        CheckboxGroup(
          padding: EdgeInsets.only(left: 5),
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          labels: <String>["Yes", "No"],
          activeColor: Color(0xFF4A4F54),
          onSelected: (List selected) => setState(() {
            if (selected.length > 1) {
              selected.removeAt(0);
            } else {
              addRecord(nameFlha, selected[0]);
            }
            // _checked = selected;
          }),
        )
      ],
    );
  }

  void addRecord(String itemName, String value) {
    if (itemName == 'ppeInspected') {
      _flha.ppeInspected = value;
    } else if (itemName == 'preUseInspectionCompleted') {
      _flha.preUseInspectionCompleted = value;
    } else if (itemName == 'warningRibbon') {
      _flha.warningRibbon = value;
    } else if (itemName == 'workingAlone') {
      _flha.workingAlone = value;
    } else if (itemName == 'permitClosedOut') {
      _flha.permitClosedOut = value;
    } else if (itemName == 'areaCleanedUp') {
      _flha.areaCleanedUp = value;
    } else if (itemName == 'hazardsRemaining') {
      _flha.hazardsRemaining = value;
    } else if (itemName == 'incidentInjuries') {
      _flha.incidentInjuries = value;
    }
  }

  Widget customAlertDialog(String locationName) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      backgroundColor: Color(0xFF4A4F54).withOpacity(.7),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: Text(
        "$locationName",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Container(
              width: double.infinity,
              height: 300,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _lat != null && _long != null
                      ? LatLng(_lat, _long)
                      : _center,
                  zoom: 11.0,
                ),
                markers: _markers,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                onTap: (point) {
                  setState(() {
                    _markers.clear();
                    _lat = point.latitude;
                    _long = point.longitude;
                    // _locationAddress =
                    //     await _getLocationAddress(_lat, _long, _locationAddress);
                    _markers.add(Marker(
                      markerId: MarkerId(point.toString()),
                      position: point,
                    ));
                  });
                },
              ));
        },
      ),
      actions: [
        TextButton(
          child: Text(
            'Select',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
          ),
          onPressed: () {
            if (locationName == 'Task Location') {
              _getLocationAddress(_lat, _long).then((value) {
                setState(() {
                  _flha.taskLocation = GeoPoint(_lat, _long);
                  _flha.taskAddress = value;
                });
              });
            }
            // else if (locationName == 'Muster Location') {
            //   _getLocationAddress(_lat, _long).then((value) {
            //     setState(() {
            //       _flha.musterLocation = GeoPoint(_lat, _long);
            //       _flha.musterAddress = value;
            //     });
            //   });
            // }
            Navigator.pop(context);
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

  Widget customRecordDialog() {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      backgroundColor: Color(0xFF4A4F54).withOpacity(.7),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: Text(
        "Add Record",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomTextField(
                    prefixIcon: Icon(Icons.work_outline_outlined),
                    hintText: 'Task',
                    inputType: TextInputType.name,
                    controller: _taskAlertController,
                  ),
                  SizedBox(height: 3),
                  CustomTextField(
                    prefixIcon: Icon(Icons.work_outline_outlined),
                    hintText: 'Hazards',
                    inputType: TextInputType.name,
                    controller: _hazardAlertController,
                  ),
                  SizedBox(height: 3),
                  CustomTextField(
                    prefixIcon: Icon(Icons.work_outline_outlined),
                    hintText: 'Priority',
                    inputType: TextInputType.name,
                    controller: _priorityAlertController,
                  ),
                  SizedBox(height: 3),
                  CustomTextField(
                    prefixIcon: Icon(Icons.work_outline_outlined),
                    hintText: 'Plans to Eliminate/Control',
                    inputType: TextInputType.name,
                    controller: _planAlertController,
                  ),
                ],
              ));
        },
      ),
      actions: [
        TextButton(
          child: Text(
            'Add',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
          ),
          onPressed: () {
            if (_taskAlertController.text == '' ||
                _hazardAlertController.text == '' ||
                _priorityAlertController.text == '' ||
                _planAlertController.text == '') {
              Fluttertoast.showToast(
                  msg: "Fill all the fields",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              setState(() {
                _tasksList.add({
                  'task': _taskAlertController.text,
                  'hazard': _hazardAlertController.text,
                  'priority': _priorityAlertController.text,
                  'plan': _planAlertController.text
                });
              });
              _taskAlertController.text = '';
              _hazardAlertController.text = '';
              _priorityAlertController.text = '';
              _planAlertController.text = '';
              Navigator.pop(context);
            }
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

  Future<String> _getLocationAddress(double latitude, double longitude) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark placeMark = newPlace[0];
    String name = placeMark.name;
    // String subLocality = placeMark.subLocality;
    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    // String subAdministrativeArea = placeMark.administrativeArea;
    String postalCode = placeMark.postalCode;
    String country = placeMark.country;
    // String subThoroughfare = placeMark.subThoroughfare;
    String thoroughfare = placeMark.thoroughfare;
    // _isoCountryCode = placeMark.isoCountryCode;
    // address =
    //     "$name, $thoroughfare, $locality, $administrativeArea, $postalCode, $country";
    return "$name, $thoroughfare, $locality, $administrativeArea, $postalCode, $country";
  }

  var location = new Location.Location();
  bool _serviceEnabled;
  Location.PermissionStatus _permissionGranted;

  Future<bool> getLocationPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Navigator.of(context, rootNavigator: true).pop(context);
        return false;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == Location.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != Location.PermissionStatus.granted) {
        Navigator.of(context, rootNavigator: true).pop(context);
        return false;
      }
    }
    return true;
  }

  Future<void> myCurrentLocation() async {
    await location.getLocation().then((value) {
      print("locationLatitude: ${value.latitude.toString()}");
      print("locationLongitude: ${value.longitude.toString()}");
      setState(() {
        _lat = value.latitude;
        _long = value.longitude;
        // _latMuster = value.latitude;
        // _longMuster = value.longitude;
        _markers.add(Marker(
          markerId: MarkerId(value.toString()),
          position: LatLng(value.latitude, value.longitude),
        ));
      });
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
    _workController.dispose();
    _permitController.dispose();
    _companyController.dispose();
    _taskAlertController.dispose();
    _hazardAlertController.dispose();
    _priorityAlertController.dispose();
    _planAlertController.dispose();
    _musterController.dispose();
    _controller.clear();
    if (_mapController != null) _mapController.dispose();
    _isLoading = false;
    super.dispose();
  }
}
