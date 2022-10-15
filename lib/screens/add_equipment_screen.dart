import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as Location;
import 'package:work_bench/models/equipment.dart';
import 'package:work_bench/reusable_widgets/custom_text_field.dart';
import 'package:work_bench/screens/equipments_screen.dart';
import 'package:work_bench/view_models/equipments_view_model.dart';

class AddEquipmentScreen extends StatefulWidget {
  @override
  _AddEquipmentScreenState createState() => _AddEquipmentScreenState();
}

class _AddEquipmentScreenState extends State<AddEquipmentScreen> {
  String _avatarUrl =
      'https://firebasestorage.googleapis.com/v0/b/work-bench-2bf1d.appspot.com/o/img_1.jpg?alt=media&token=c47fd2c6-6e84-48f8-8318-a1c9923fcc98';
  EquipmentsViewModel _viewModel = EquipmentsViewModel();
  bool _isLoading;
  String _locationAddress = "";
  PickedFile _pickedEquipmentImage;
  File _insuranceFile;
  TextEditingController _nameController = TextEditingController();
  GoogleMapController _mapController;
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
            myCurrentLocation().then((_) {
              _getLocationAddress(_lat, _long);
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
              'Add Equipment',
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text('Equipment Image: ', style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                          SizedBox(height: 7),
                          imageProfile(_pickedEquipmentImage),
                          // GestureDetector(
                          //   onTap: () {
                          //     showModalBottomSheet(
                          //         context: context,
                          //         builder: ((builder) => bottomSheet()));
                          //   },
                          //   child: Container(
                          //     width: double.infinity,
                          //     child: Padding(
                          //         padding: const EdgeInsets.only(
                          //             left: 15, bottom: 11, top: 11, right: 15),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           children: <Widget>[
                          //             Icon(Icons.attachment_outlined,
                          //                 color:
                          //                     Colors.black87.withOpacity(.6)),
                          //             SizedBox(width: 10),
                          //             Text(
                          //               _pickedEquipmentImage != null
                          //                   ? _pickedEquipmentImage.path
                          //                       .split('/')
                          //                       .last
                          //                   : "Equipment Image",
                          //               style: TextStyle(
                          //                   fontSize: 16,
                          //                   color:
                          //                       Colors.black87.withOpacity(.6)),
                          //             ),
                          //           ],
                          //         )),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white70.withOpacity(.5),
                          //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          Text('Equipment Name: ', style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                          SizedBox(height: 7),
                          CustomTextField(
                              prefixIcon: Icon(Icons.text_fields_outlined),
                              hintText: 'Equipment Name',
                              inputType: TextInputType.name,
                              controller: _nameController),
                          SizedBox(height: 10),
                          Text('Equipment Location: ', style: TextStyle(
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
                          // GestureDetector(
                          //   onTap: () {
                          //     //  show map
                          //   },
                          //   child: Container(
                          //     width: double.infinity,
                          //     child: Padding(
                          //         padding: const EdgeInsets.only(
                          //             left: 15, bottom: 11, top: 11, right: 15),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           children: <Widget>[
                          //             Icon(Icons.location_on_outlined, color: Colors.black87.withOpacity(.6)),
                          //             SizedBox(width: 10),
                          //             Text(
                          //               _pickedFile!=null?_pickedFile.path.split('/').last:"Location",
                          //               style: TextStyle(fontSize: 16, color: Colors.black87.withOpacity(.6)),
                          //             ),
                          //           ],
                          //         )),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white70.withOpacity(.5),
                          //       borderRadius: const BorderRadius.all(
                          //           const Radius.circular(30.0)),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          Text('Insurance: ', style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                          SizedBox(height: 7),
                          GestureDetector(
                            onTap: () async {
                              FilePickerResult result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                setState(() {
                                  _insuranceFile =
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
                                      Icon(Icons.attachment_outlined,
                                          color:
                                              Colors.black87.withOpacity(.6)),
                                      SizedBox(width: 10),
                                      Text(
                                        null != _insuranceFile
                                            ? _insuranceFile.path
                                                .split('/')
                                                .last
                                            : 'Insurance',
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
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () async {
                              if (_pickedEquipmentImage == null ||
                                  _nameController.text == '' ||
                                  _insuranceFile == null) {
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
                                if (_pickedEquipmentImage != null &&
                                    _insuranceFile != null) {
                                  Future.wait([
                                    _viewModel.uploadEquipmentImage(
                                        File(_pickedEquipmentImage.path)),
                                    _viewModel.uploadInsurance(_insuranceFile)
                                  ]).then((value) {
                                    _viewModel
                                        .addEquipment(Equipment(
                                            name: _nameController.text,
                                            address: _locationAddress,
                                            imageUrl: _viewModel.imageUrl,
                                            insuranceUrl:
                                                _viewModel.insuranceUrl,
                                            location: GeoPoint(_lat, _long),
                                            uid: FirebaseAuth
                                                .instance.currentUser.uid))
                                        .then((value) {
                                      Fluttertoast.showToast(
                                          msg: "Equipment added successfully",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => EquipmentsScreen()));
                                      // Navigator.pop(context);
                                    });
                                  }).onError((_, __) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: "Upload failed!",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  });
                                }
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
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF4A4F54)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
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

  Widget imageProfile(PickedFile imageFile) {
    return TextButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: ((builder) => bottomSheet()));
        },
        child: CircleAvatar(
          radius: 60,
          backgroundImage: imageFile?.path != null
              ? FileImage(File(imageFile.path))
              : NetworkImage(_avatarUrl),
        ));
  }

  Widget bottomSheet() {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      color: Colors.white70.withOpacity(.4),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Equipment image',
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

  Future<PickedFile> takePhoto(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    PickedFile _pickedFile;
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _pickedFile = pickedFile;
      _pickedEquipmentImage = pickedFile;
    });
    return _pickedFile;
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
    _nameController.dispose();
    if(_mapController != null)
      _mapController.dispose();
    _markers.clear();
    super.dispose();
  }
}
