import 'dart:async';
import 'dart:collection';
import 'package:connectivity/connectivity.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as Location;
import 'package:work_bench/models/job.dart';
import 'package:work_bench/reusable_widgets/custom_text_field.dart';
import 'package:carousel_slider/carousel_slider.dart';

class JobPreviewEmployeeScreen extends StatefulWidget {
  JobPreviewEmployeeScreen({Key key, this.job, this.jobId}) : super(key: key);
  final Job job;
  final String jobId;

  @override
  _JobPreviewEmployeeScreenState createState() =>
      _JobPreviewEmployeeScreenState();
}

class _JobPreviewEmployeeScreenState extends State<JobPreviewEmployeeScreen> {
  // String _avatarUrl =
  //     'https://firebasestorage.googleapis.com/v0/b/work-bench-2bf1d.appspot.com/o/img_1.jpg?alt=media&token=c47fd2c6-6e84-48f8-8318-a1c9923fcc98';
  bool _isLoading;
  String _dateText = "";
  // String _locationAddress = "";
  List<String> _imgUrls = [];
  List<String> _invoiceUrls = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _empNameController = TextEditingController();
  TextEditingController _tasksController = TextEditingController();
  TextEditingController _addNotesController = TextEditingController();
  TextEditingController _hoursController = TextEditingController();
  TextEditingController _equipmentController = TextEditingController();
  GoogleMapController _mapController;
  Set<Marker> _markers = HashSet<Marker>();
  int _current = 0;
  int _currentInvoice = 0;

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
            myCurrentLocation().then((_) async {
              // _getLocationAddress(_lat, _long);
              //pictures
              if(widget.job.image1!=null && widget.job.image1!='' && !_imgUrls.contains(widget.job.image1)) {
                _imgUrls.add(widget.job.image1);
              }
              if(widget.job.image2!=null && widget.job.image2!='' && !_imgUrls.contains(widget.job.image2)) {
                _imgUrls.add(widget.job.image2);
              }
              if(widget.job.image3!=null && widget.job.image3!='' && !_imgUrls.contains(widget.job.image3)) {
                _imgUrls.add(widget.job.image3);
              }
              if(widget.job.image4!=null && widget.job.image4!='' && !_imgUrls.contains(widget.job.image4)) {
                _imgUrls.add(widget.job.image4);
              }
              if(widget.job.image5!=null && widget.job.image5!='' && !_imgUrls.contains(widget.job.image5)) {
                _imgUrls.add(widget.job.image5);
              }
              // invoices
              if(widget.job.invoice1!=null && widget.job.invoice1!='' && !_invoiceUrls.contains(widget.job.invoice1)) {
                _invoiceUrls.add(widget.job.invoice1);
              }
              if(widget.job.invoice2!=null && widget.job.invoice2!='' && !_invoiceUrls.contains(widget.job.invoice2)) {
                _invoiceUrls.add(widget.job.invoice2);
              }
              if(widget.job.invoice3!=null && widget.job.invoice3!='' && !_invoiceUrls.contains(widget.job.invoice3)) {
                _invoiceUrls.add(widget.job.invoice3);
              }
              if(widget.job.invoice4!=null && widget.job.invoice4!='' && !_invoiceUrls.contains(widget.job.invoice4)) {
                _invoiceUrls.add(widget.job.invoice4);
              }
              if(widget.job.invoice5!=null && widget.job.invoice5!='' && !_invoiceUrls.contains(widget.job.invoice5)) {
                _invoiceUrls.add(widget.job.invoice5);
              }
              _titleController.text = widget.job.title;
              _hoursController.text = widget.job.hours;
              _tasksController.text = widget.job.tasks;
              _dateText = widget.job.date;
              _addNotesController.text = widget.job.notes;
              _lat = widget.job.location.latitude;
              _long = widget.job.location.longitude;
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
              'Job Details',
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
                      SizedBox(height: 10),
                      CustomTextField(
                          isEnabled: false,
                          prefixIcon: Icon(Icons.text_fields_outlined),
                          hintText: 'Job title',
                          inputType: TextInputType.name,
                          controller: _titleController),
                      SizedBox(height: 10),
                      Text('Total work hours: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      CustomTextField(
                          isEnabled: false,
                          prefixIcon: Icon(Icons.text_fields_outlined),
                          hintText: 'Hours worked',
                          inputType: TextInputType.number,
                          controller: _hoursController),
                      SizedBox(height: 10),
                      Text('Tasks: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      CustomTextField(
                          isEnabled: false,
                          prefixIcon: Icon(Icons.text_fields_outlined),
                          hintText: 'Tasks',
                          inputType: TextInputType.name,
                          controller: _tasksController),
                      SizedBox(height: 10),
                      Text('Pictures: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      // Image.network(widget.job.image1!=null&&widget.job.image1!=''?widget.job.image1:_avatarUrl,
                      //     width: 200, height: 200),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: CarouselSlider(
                              items: _imgUrls
                                  .map(
                                    (String url) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                          return DetailScreen(imageUrl: url);
                                        }));
                                  },
                                  child: Container(
                                    // margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: NetworkImage(url),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  .toList(),
                              options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  aspectRatio: 2.0,
                                  onPageChanged: (_index, reason) {
                                    setState(() {
                                      _current = _index;
                                    });
                                  }),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _imgUrls.map((url) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == _imgUrls.indexOf(url)
                                      ? Color.fromRGBO(0, 0, 0, 0.9)
                                      : Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('Equipment: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      CustomTextField(
                          isEnabled: false,
                          prefixIcon: Icon(Icons.text_fields_outlined),
                          hintText: 'Equipment',
                          inputType: TextInputType.name,
                          controller: _equipmentController),
                      SizedBox(height: 10),
                      Text('Invoices: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      SizedBox(height: 7),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: CarouselSlider(
                              items: _invoiceUrls
                                  .map(
                                    (String url) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                          return DetailScreen(imageUrl: url);
                                        }));
                                  },
                                  child: Container(
                                    // margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: NetworkImage(url),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  .toList(),
                              options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  aspectRatio: 2.0,
                                  onPageChanged: (_index, reason) {
                                    setState(() {
                                      _currentInvoice = _index;
                                    });
                                  }),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _invoiceUrls.map((url) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentInvoice == _invoiceUrls.indexOf(url)
                                      ? Color.fromRGBO(0, 0, 0, 0.9)
                                      : Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
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
                            onTap: (_) {},
                          )),
                      SizedBox(height: 10),
                      DateTimePicker(
                        enabled: false,
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
                          hintText: _dateText != null || _dateText != ""
                              ? _dateText
                              : 'Date',
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
                          isEnabled: false,
                          prefixIcon: Icon(Icons.text_fields_outlined),
                          hintText: 'Add Notes',
                          inputType: TextInputType.text,
                          maxLines: 5,
                          controller: _addNotesController),
                      SizedBox(height: 10),
                    ],
                  ),
                )),
        ));
  }

  // Future<String> _getLocationAddress(double latitude, double longitude) async {
  //   List<Placemark> newPlace =
  //       await placemarkFromCoordinates(latitude, longitude);
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
  //       "$name, $thoroughfare, $locality, $administrativeArea, $postalCode, $country";
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
    _titleController.dispose();
    _empNameController.dispose();
    _mapController.dispose();
    _markers.clear();
    super.dispose();
  }
}

class DetailScreen extends StatelessWidget {
  DetailScreen({Key key, @required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (_) {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network(
            imageUrl,
          ),
        ),
      ),
    );
  }
}
