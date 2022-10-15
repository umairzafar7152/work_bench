import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as Location;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:work_bench/models/equipment.dart';
import 'package:work_bench/reusable_widgets/custom_text_field.dart';

class EquipmentDetailScreen extends StatefulWidget {
  EquipmentDetailScreen({Key key, this.equipment}) : super(key: key);

  final Equipment equipment;

  @override
  _EquipmentDetailScreenState createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
  String _avatarUrl =
      'https://firebasestorage.googleapis.com/v0/b/work-bench-2bf1d.appspot.com/o/img_1.jpg?alt=media&token=c47fd2c6-6e84-48f8-8318-a1c9923fcc98';
  bool _isLoading;

  // String _locationAddress = "";
  // File _insuranceFile;
  TextEditingController _nameController = TextEditingController();
  GoogleMapController _mapController;
  Set<Marker> _markers = HashSet<Marker>();
  Directory _storageDir;

  var _lat;
  var _long;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
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
              _nameController.text = widget.equipment.name;
              _lat = widget.equipment.location.latitude;
              _long = widget.equipment.location.longitude;
              _markers.clear();
              _markers.add(Marker(
                markerId: MarkerId(value.toString()),
                position: LatLng(_lat, _long),
              ));
              getExternalStorageDirectory().then((value) {
                _storageDir = value;
              });
              // _getLocationAddress(_lat, _long);
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
              'Equipment Details',
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
                          Text('Equipment Image: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18)),
                          SizedBox(height: 7),
                          CircleAvatar(
                              radius: 60,
                              backgroundImage: widget.equipment.imageUrl != null
                                  ? NetworkImage(widget.equipment.imageUrl)
                                  : NetworkImage(_avatarUrl)),
                          SizedBox(height: 10),
                          Text('Equipment Name: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18)),
                          SizedBox(height: 7),
                          CustomTextField(
                              isEnabled: false,
                              prefixIcon: Icon(Icons.text_fields_outlined),
                              hintText: 'Equipment Name',
                              inputType: TextInputType.name,
                              controller: _nameController),
                          SizedBox(height: 10),
                          Text('Equipment Location: ',
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
                                onTap: (_) {},
                              )),
                          SizedBox(height: 10),
                          Text('Insurance: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18)),
                          SizedBox(height: 7),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: GestureDetector(
                              onTap: () async {
                                if (widget.equipment.insuranceUrl != null &&
                                    widget.equipment.insuranceUrl != '') {
                                  final status =
                                      await Permission.storage.request();
                                  if (status.isGranted) {
                                    await FlutterDownloader.enqueue(
                                      url: widget.equipment.insuranceUrl,
                                      savedDir: _storageDir.path,
                                      fileName: 'download',
                                      showNotification: true,
                                      openFileFromNotification: true,
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Permission Denied",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "No file found!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
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
                                        Icon(Icons.download_outlined,
                                            color:
                                                Colors.black87.withOpacity(.6)),
                                        SizedBox(width: 10),
                                        Text(
                                          'Insurance',
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
                          SizedBox(height: 10),
                        ],
                      )),
                ),
        ));
  }

  // Future<String> _getLocationAddress(double latitude, double longitude) async {
  //   List<Placemark> newPlace =
  //   await placemarkFromCoordinates(latitude, longitude);
  //   Placemark placeMark = newPlace[0];
  //   String name = placeMark.name;
  //   // String subLocality = placeMark.subLocality;
  //   String locality = placeMark.locality;
  //   String administrativeArea = placeMark.administrativeArea;
  //   // String subAdministrativeArea = placeMark.administrativeArea;
  //   String postalCode = placeMark.postalCode;
  //   String country = placeMark.country;
  //   // String subThoroughfare = placeMark.subThoroughfare;
  //   String thoroughfare = placeMark.thoroughfare;
  //   // _isoCountryCode = placeMark.isoCountryCode;
  //   _locationAddress =
  //   "$name, $thoroughfare, $locality, $administrativeArea, $postalCode, $country";
  //   return "$name, $thoroughfare, $locality, $administrativeArea, $postalCode, $country";
  // }

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
    if (_mapController != null) _mapController.dispose();
    _markers.clear();
    super.dispose();
  }
}
