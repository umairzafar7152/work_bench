import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as Location;
import 'package:work_bench/models/job.dart';
import 'package:work_bench/reusable_widgets/custom_text_field.dart';
import 'package:work_bench/screens/jobs_screen.dart';
import 'package:work_bench/view_models/jobs_view_model.dart';

class AddJobScreen extends StatefulWidget {
  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  List<String> _employeeName = [];
  List<String> _selectedEmpIds = [];
  List<String> _employeeHours = [];
  // String _avatarUrl =
  //     'https://firebasestorage.googleapis.com/v0/b/work-bench-2bf1d.appspot.com/o/img_1.jpg?alt=media&token=c47fd2c6-6e84-48f8-8318-a1c9923fcc98';
  final ImagePicker _picker = ImagePicker();
  // PickedFile _pickedFile;
  PickedFile _imageFile1;
  PickedFile _imageFile2;
  PickedFile _imageFile3;
  PickedFile _imageFile4;
  PickedFile _imageFile5;
  PickedFile _pickedInvoiceFile1;
  PickedFile _pickedInvoiceFile2;
  PickedFile _pickedInvoiceFile3;
  PickedFile _pickedInvoiceFile4;
  PickedFile _pickedInvoiceFile5;
  String dropDownValueEquipment;
  String dropDownValue;
  JobsViewModel _viewModel = JobsViewModel();
  bool _isLoading;
  String _dateText = "";
  String _locationAddress = "";
  TextEditingController _titleController = TextEditingController();
  TextEditingController _empNameController = TextEditingController();
  TextEditingController _tasksController = TextEditingController();
  TextEditingController _addNotesController = TextEditingController();
  TextEditingController _hoursController = TextEditingController();
  GoogleMapController _mapController;
  List<String> _employeesList;
  List<String> _equipmentsList = [];
  List<String> _equipmentsIds = [];
  List<String> _employeesId;
  int _empListIndex;
  int _eqListIndex;
  Set<Marker> _markers = HashSet<Marker>();

  var _lat;
  var _long;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  _handleTap(LatLng point) {
    setState(() {
      _markers.clear();
      _lat = point.latitude;
      _long = point.longitude;
      _getLocationAddress(_lat, _long);
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
      ));
    });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    isConnected().then((value) {
      if (value) {
        getLocationPermissions().then((value1) {
          if (value1) {
            myCurrentLocation().then((_) async {
              _getLocationAddress(_lat, _long);
              _employeesList = await _viewModel.getEmployeesList();
              _employeesId = await _viewModel.getEmployeesId();
              await _viewModel.getEquipments().then((value) {
                for (int i = 0; i < _viewModel.equipmentList.length; i++) {
                  String a = _viewModel.equipmentList[i].data()['name'];
                  String b = _viewModel.equipmentList[i].id;
                  if (a != null) {
                    _equipmentsList.add(a);
                    _equipmentsIds.add(b);
                  }
                  print(a.toString());
                  print(b.toString());
                }
              });
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
            brightness: Brightness.dark,
            backgroundColor: Color(0xFFFFFFFF).withOpacity(.2),
            centerTitle: true,
            title: Text(
              'Schedule a job',
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
                  child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Text('Job Title: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      CustomTextField(
                          prefixIcon: Icon(Icons.text_fields_outlined),
                          hintText: 'Job title',
                          inputType: TextInputType.name,
                          controller: _titleController),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Text('Select Employees: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18)),
                          TextButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  barrierColor: Colors.white.withOpacity(.4),
                                  builder: (BuildContext context) {
                                    return customAlertDialog(_employeesList);
                                  });
                            },
                            child: Text(
                              'Add Employee',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18),
                            ),
                            style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF4A4F54)),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('Hours', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: _buildEmployeeList,
                        itemCount: _employeeName.length,
                      ),
                      SizedBox(height: 10),
                      Text('Enter tasks: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      CustomTextField(
                          prefixIcon: Icon(Icons.text_fields_outlined),
                          hintText: 'Tasks',
                          inputType: TextInputType.text,
                          controller: _tasksController,
                          maxLines: 5,),
                      SizedBox(height: 10),
                      Text('Select Pictures: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      // imageProfile(_pickedFile, false),
                      SizedBox(
                        height: 80,
                        child: GridView.count(
                          crossAxisCount: 5,
                          children: <Widget>[
                            itemImage(1, _imageFile1),
                            itemImage(2, _imageFile2),
                            itemImage(3, _imageFile3),
                            itemImage(4, _imageFile4),
                            itemImage(5, _imageFile5),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Text('  Select Equipment: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18)),
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: DropdownButton<String>(
                                  value: dropDownValueEquipment,
                                  hint: Text('Equipment Name'),
                                  items: _equipmentsList.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropDownValueEquipment = value;
                                      _eqListIndex =
                                          _equipmentsList.indexOf(value);
                                    });
                                  },
                                ),
                              ))
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('Select Invoices: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      SizedBox(
                        height: 80,
                        child: GridView.count(
                          crossAxisCount: 5,
                          children: <Widget>[
                            imageProfile(_pickedInvoiceFile1, 1),
                            imageProfile(_pickedInvoiceFile2, 2),
                            imageProfile(_pickedInvoiceFile3, 3),
                            imageProfile(_pickedInvoiceFile4, 4),
                            imageProfile(_pickedInvoiceFile5, 5),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Job Location: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      Container(
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
                            onTap: _handleTap,
                          )),
                      SizedBox(height: 10),
                      DateTimePicker(
                        use24HourFormat: false,
                        // type: DateTimePickerType.dateTimeSeparate,
                        // dateMask: 'MMM dd, yyyy',
                        initialValue: '',
                        // icon: Icon(Icons.event_available_rounded),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        onChanged: (val) {
                          setState(() {
                            _dateText = val;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.event_available_rounded),
                          hintText: 'Date',
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
                      SizedBox(height: 10),
                      Text('Additional notes: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      CustomTextField(
                          prefixIcon: Icon(Icons.text_fields_outlined),
                          hintText: 'Add Notes',
                          inputType: TextInputType.text,
                          maxLines: 5,
                          controller: _addNotesController),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () async {
                          if (_titleController.text == '' ||
                              _dateText == '' ||
                              _empListIndex == null) {
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
                              _isLoading = true;
                            });
                            _job.uid = FirebaseAuth.instance.currentUser.uid;
                            _job.location = GeoPoint(_lat, _long);
                            _job.address = _locationAddress;
                            _job.title = _titleController.text;
                            _job.date = _dateText;
                            // _job.employeeId = _employeesId[_empListIndex];
                            // _job.employeeEmail = _employeesList[_empListIndex];
                            _job.tasks = _tasksController.text;
                            // _job.hours = _hoursController.text;
                            if(_eqListIndex!=null) {
                              _job.equipment = _equipmentsList[_eqListIndex];
                              _job.equipmentId = _equipmentsIds[_eqListIndex];
                            } else {
                              _job.equipment = '';
                              _job.equipmentId = '';
                            }
                            _job.notes = _addNotesController.text;
                            _uploadAllFiles();
                            // _viewModel.addJob(Job(
                            //   uid: FirebaseAuth.instance.currentUser.uid,
                            //   location: GeoPoint(_lat, _long),
                            //   address: _locationAddress,
                            //   title: _titleController.text,
                            //   date: _dateText,
                            //   employeeId: "${_employeesId[_empListIndex]}",
                            //   employeeEmail: _employeesList[_empListIndex]
                            // )).then((value) {
                            //   Fluttertoast.showToast(
                            //       msg: "Job added successfully",
                            //       toastLength: Toast.LENGTH_LONG,
                            //       gravity: ToastGravity.BOTTOM,
                            //       timeInSecForIosWeb: 1,
                            //       backgroundColor: Colors.green,
                            //       textColor: Colors.white,
                            //       fontSize: 16.0);
                            //   // setState(() {
                            //   //   _isLoading = false;
                            //   // });
                            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobsScreen()));
                            // });
                          }
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF4A4F54)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )),
        ));
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
    _locationAddress =
        "$name, $thoroughfare, $locality, $administrativeArea, $postalCode, $country";
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

  Widget _buildEmployeeList(BuildContext context, int index) {
    // return itemCard(index, _newSnapshot[index]);
    return itemCard(
        index: index, x1: _employeeName[index], x2: _employeeHours[index]);
  }

  Widget itemCard({int index, String x1, String x2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                        fontSize: 18,
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
                        fontSize: 18,
                        color: Color(0xFF727070),
                        fontWeight: FontWeight.w900),
                  ),
                ),
              )
            ]),
      ),
    );
  }

  Future<void> myCurrentLocation() async {
    await location.getLocation().then((value) {
      print("locationLatitude: ${value.latitude.toString()}");
      print("locationLongitude: ${value.longitude.toString()}");
      setState(() {
        _lat = value.latitude;
        _long = value.longitude;
        _markers.add(Marker(
          markerId: MarkerId(value.toString()),
          position: LatLng(value.latitude, value.longitude),
        ));
      });
    });
  }

  Widget imageProfile(PickedFile imageFile, int imageNumber) {
    return TextButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: ((builder) => bottomSheet(true, imageNumber)));
        },
        child: CircleAvatar(
          radius: 80,
          backgroundImage: imageFile == null
              ? AssetImage("assets/images/img_1.jpg")
              : FileImage(File(imageFile.path)),
        ));
  }

  Widget itemImage(int imageNumber, PickedFile imageFile) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
            context: context, builder: ((builder) => bottomSheet(false, imageNumber)));
      },
      child: CircleAvatar(
        radius: 80,
        backgroundImage: imageFile == null
            ? AssetImage("assets/images/img_1.jpg")
            : FileImage(File(imageFile.path)),
      ),
    );
  }

  Widget bottomSheet(bool isInvoicePicture, int imageNumber) {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: <Widget>[
          Text(
            'Choose picture',
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
                    takePhoto(ImageSource.camera, isInvoicePicture, imageNumber);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    size: 30,
                    color: Color(0xFF4A4F54),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    takePhoto(ImageSource.gallery, isInvoicePicture, imageNumber);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source, bool isInvoice, int imageNumber) async {
    final pickedFile = await _picker.getImage(source: source);
    if(isInvoice) {
      setState(() {
        if (imageNumber == 1) {
          _pickedInvoiceFile1 = pickedFile;
        } else if (imageNumber == 2) {
          _pickedInvoiceFile2 = pickedFile;
        } else if (imageNumber == 3) {
          _pickedInvoiceFile3 = pickedFile;
        } else if (imageNumber == 4) {
          _pickedInvoiceFile4 = pickedFile;
        } else if (imageNumber == 5) {
          _pickedInvoiceFile5 = pickedFile;
        }
      });
    } else {
      setState(() {
        if (imageNumber == 1) {
          _imageFile1 = pickedFile;
        } else if (imageNumber == 2) {
          _imageFile2 = pickedFile;
        } else if (imageNumber == 3) {
          _imageFile3 = pickedFile;
        } else if (imageNumber == 4) {
          _imageFile4 = pickedFile;
        } else if (imageNumber == 5) {
          _imageFile5 = pickedFile;
        }
      });
      // setState(() {
      //   _pickedFile = pickedFile;
      // });
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

  Future<String> _uploadFile(File fileToUpload, String type) async {
    Reference reference;
    if (type == 'jobInvoice') {
      reference = FirebaseStorage.instance
          .ref()
          .child("jobInvoice")
          .child(fileToUpload.path.split('/').last);
    } else {
      reference = FirebaseStorage.instance
          .ref()
          .child("jobPicture")
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

  Future<void> _picture1Async() async {
    if(_imageFile1!=null) {
      await _uploadFile(File(_imageFile1.path), 'picture').then((value) async {
        print("TESTING1>>>>>>>>>$value");
        _job.image1 = value;
      });
    }
  }
  Future<void> _picture2Async() async {
    if(_imageFile2!=null) {
      await _uploadFile(File(_imageFile2.path), 'picture').then((value) async {
        print("TESTING2>>>>>>>>>$value");
        _job.image2 = value;
      });
    }
  }
  Future<void> _picture3Async() async {
    if(_imageFile3!=null) {
      await _uploadFile(File(_imageFile3.path), 'picture').then((value) async {
        print("TESTING3>>>>>>>>>$value");
        _job.image3 = value;
      });
    }
  }
  Future<void> _picture4Async() async {
    if(_imageFile4!=null) {
      await _uploadFile(File(_imageFile4.path), 'picture').then((value) async {
        print("TESTING4>>>>>>>>>$value");
        _job.image4 = value;
      });
    }
  }
  Future<void> _picture5Async() async {
    if(_imageFile5!=null) {
      await _uploadFile(File(_imageFile5.path), 'picture').then((value) async {
        print("TESTING5>>>>>>>>>$value");
        _job.image5 = value;
      });
    }
  }


  Future<void> _invoice1Async() async {
    if(_pickedInvoiceFile1!=null) {
      await _uploadFile(File(_pickedInvoiceFile1.path), 'jobInvoice')
          .then((value) async {
        print("TESTING6>>>>>>>>>$value");
        _job.invoice1 = value;
      });
    }
  }
  Future<void> _invoice2Async() async {
    if(_pickedInvoiceFile2!=null) {
      await _uploadFile(File(_pickedInvoiceFile2.path), 'jobInvoice')
          .then((value) async {
        print("TESTING7>>>>>>>>>$value");
        _job.invoice2 = value;
      });
    }
  }
  Future<void> _invoice3Async() async {
    if(_pickedInvoiceFile3!=null) {
      await _uploadFile(File(_pickedInvoiceFile3.path), 'jobInvoice')
          .then((value) async {
        print("TESTING8>>>>>>>>>$value");
        _job.invoice3 = value;
      });
    }
  }
  Future<void> _invoice4Async() async {
    if(_pickedInvoiceFile4!=null) {
      await _uploadFile(File(_pickedInvoiceFile4.path), 'jobInvoice')
          .then((value) async {
        print("TESTING9>>>>>>>>>$value");
        _job.invoice4 = value;
      });
    }
  }
  Future<void> _invoice5Async() async {
    if(_pickedInvoiceFile5!=null) {
      await _uploadFile(File(_pickedInvoiceFile5.path), 'jobInvoice')
          .then((value) async {
        print("TESTING10>>>>>>>>>$value");
        _job.invoice5 = value;
      });
    }
  }

  Job _job = new Job();

  Future<void> _uploadAllFiles() async {
    Future.wait([_picture1Async(), _picture2Async(), _picture3Async(), _picture4Async(), _picture5Async(),
      _invoice1Async(), _invoice2Async(), _invoice3Async(), _invoice4Async(), _invoice5Async()])
        .then((value) async {
      for(int i=0;i<_employeeName.length;i++) {
        _job.employeeEmail = _employeeName[i];
        _job.employeeId = _selectedEmpIds[i];
        _job.hours = _employeeHours[i];
        await _viewModel.addJob(_job);
      }
      Fluttertoast.showToast(
          msg: "Job added successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => JobsScreen()));
    });
  }

  Widget customAlertDialog(List<String> list) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      backgroundColor: Color(0xFF4A4F54).withOpacity(.7),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: Text(
        "Add Employee",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
      ),
      content: StatefulBuilder(builder: (context, setState) {
        return Container(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                        hint: Text('Select Employee'),
                        items: list.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dropDownValue = value;
                            _empListIndex = _employeesList.indexOf(value);
                          });
                        },
                      ),
                    )),
                SizedBox(height: 5),
                CustomTextField(
                    prefixIcon: Icon(Icons.timer),
                    hintText: 'Employee Hours',
                    inputType: TextInputType.number,
                    controller: _hoursController),
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
            if (_hoursController.text != '' && _empListIndex!=null) {
              setState(() {
                  _employeeName.add(dropDownValue);
                  _employeeHours.add(_hoursController.text);
                  _selectedEmpIds.add(_employeesId.elementAt(_empListIndex));
              });
              _hoursController.text = '';
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
              _hoursController.text = '';
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


  @override
  void dispose() {
    _titleController.dispose();
    _empNameController.dispose();
    _mapController.dispose();
    _markers.clear();
    super.dispose();
  }
}


// DecoratedBox(
// decoration: ShapeDecoration(
// color: Colors.white70.withOpacity(.5),
// shape: RoundedRectangleBorder(
// side: BorderSide(
// width: 1.0,
// style: BorderStyle.solid,
// color: Colors.black87),
// borderRadius:
// BorderRadius.all(Radius.circular(30.0)),
// ),
// ),
// child: Padding(
// padding: const EdgeInsets.only(left: 8),
// child: DropdownButton<String>(
// value: dropDownValue,
// hint: Text('Employee Email'),
// items: _employeesList.map((String value) {
// return new DropdownMenuItem<String>(
// value: value,
// child: new Text(value),
// );
// }).toList(),
// onChanged: (value) {
// setState(() {
// dropDownValue = value;
// _empListIndex =
// _employeesList.indexOf(value);
// });
// },
// ),
// ))