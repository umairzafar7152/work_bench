import 'package:connectivity/connectivity.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:work_bench/models/planner.dart';
import 'package:work_bench/reusable_widgets//custom_text_field.dart';
import 'package:work_bench/view_models/planner_view_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PlannerScreen extends StatefulWidget {
  PlannerScreen({Key key}) : super(key: key);

  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  FlutterLocalNotificationsPlugin localNotifications;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  PlannerViewModel _viewModel = PlannerViewModel();
  String _dropDownValue;
  List<String> _list = ['alert', 'schedule', 'note'];
  bool _isLoading = false;
  String _dateTimeText;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    tz.initializeTimeZones();
    var _initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: _initializationSettingsAndroid, iOS: iosInitialize);
    localNotifications = new FlutterLocalNotificationsPlugin();
    localNotifications.initialize(initializationSettings, onSelectNotification: selectNotification);

    _viewModel.getDataOfPlanner().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    runApp(
      MaterialApp(
        title: 'Work Bench',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColorBrightness: Brightness.light,
          accentColor: Color(0xFF4A4F54),
          accentColorBrightness: Brightness.light,
          fontFamily: 'Burbank',
          primaryColor: Colors.black,
        ),
        home: PlannerScreen(),
      ),
    );
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
              "Planner",
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
                            return customAlertDialog();
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
              : _viewModel.plannerRecords.length == 0
              ? Center(
            child: Text(
              'No record found...',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : buildListView(_viewModel)
        ));
  }

  Widget buildListView(PlannerViewModel viewModel) {
    return Container(
        padding: EdgeInsets.all(10),
        child: ChangeNotifierProvider<PlannerViewModel>(
          create: (context) => viewModel,
          child: Consumer<PlannerViewModel>(
            builder: (context, model, child) => ListView.builder(
              itemBuilder: _buildRequestList,
              itemCount: _viewModel.plannerRecords.length,
            ),
          ),
        ));
  }

  Future _showNotification(DateTime time, String title) async {
    var androidDetails = new AndroidNotificationDetails("channelId", "channelName", "channelDescription", importance: Importance.high);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(android: androidDetails, iOS: iosDetails);
    // await localNotifications.show(0, 'Notification Title', "body of notification", generalNotificationDetails);
    await localNotifications.zonedSchedule(
      0,
      '$title',
      'Tap to view',
      tz.TZDateTime.from(time, tz.local),
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Widget _buildRequestList(BuildContext context, int index) {
    // return itemCard(index, _newSnapshot[index]);
    return itemCard(index, _viewModel.plannerRecords[index]);
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
  Widget itemCard(int index, Planner x1) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        clipBehavior: Clip.antiAlias,
        color: Color(0xFF4A4F54).withOpacity(.7),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Title: ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'burbank')),
                    TextSpan(text: x1.title, style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w900, fontFamily: 'burbank')),
                  ],
                ),
              ),
              SizedBox(height: 2),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Time: ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'burbank')),
                    TextSpan(text: x1.date, style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'burbank')),
                  ],
                ),
              ),
              SizedBox(height: 2),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Type: ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'burbank')),
                    TextSpan(text: x1.typeEvent, style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'burbank')),
                  ],
                ),
              ),
              SizedBox(height: 2),
              x1.typeEvent == 'note'
                  ? RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Note: ",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'burbank')),
                          TextSpan(
                              text: x1.note,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: 'burbank'))
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget customAlertDialog() {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      backgroundColor: Color(0xFF4A4F54).withOpacity(.7),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      title: Text(
        "Add Event",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
      ),
      content: StatefulBuilder(builder: (context, setState) {
        return Container(
            width: 280,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              CustomTextField(
                  prefixIcon: Icon(Icons.text_fields_outlined),
                  hintText: 'Title',
                  inputType: TextInputType.name,
                  controller: _titleController),
              SizedBox(height: 5),
              DateTimePicker(
                use24HourFormat: false,
                type: DateTimePickerType.dateTime,
                // dateMask: 'MMM dd, yyyy',
                initialValue: '',
                // icon: Icon(Icons.event_available_rounded),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                dateLabelText: 'Date Time',
                onChanged: (val) {
                  setState(() {
                    _dateTimeText = val;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  hintText: 'Date Time',
                  hintStyle: TextStyle(color: Colors.black87.withOpacity(.6)),
                  filled: true,
                  fillColor: Colors.white70.withOpacity(.5),
                  border: OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.white24)
                      //borderSide: const BorderSide(),
                      ),
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                ),
              ),
              SizedBox(height: 5),
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
                      value: _dropDownValue,
                      hint: Text('Type of Event (alert,schedule,note)'),
                      items: _list.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (x) {
                        setState(() {
                          _dropDownValue = x;
                        });
                      },
                    ),
                  )),
              SizedBox(height: 5),
              _dropDownValue != null && _dropDownValue == 'note'
                  ? CustomTextField(
                      prefixIcon: Icon(Icons.text_fields_outlined),
                      hintText: 'Add Note',
                      inputType: TextInputType.multiline,
                      controller: _noteController,
                      maxLines: 5)
                  : Container(),
            ]));
      }),
      actions: [
        TextButton(
          child: Text(
            'Add',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
          ),
          onPressed: () {
            if (_titleController.text == '' ||
                _dateTimeText == null ||
                _dropDownValue == null) {
              Fluttertoast.showToast(
                  msg: "Fill all the fields",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (_dropDownValue == 'note' && _noteController.text == '') {
              Fluttertoast.showToast(
                  msg: "Fill the notes",
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
              if(_dropDownValue == 'alert') {
                _showNotification(
                    DateTime.parse(_dateTimeText), _titleController.text);
              }
              if (_dropDownValue == 'note' && _noteController.text != '') {
                _viewModel.addPlanner(Planner(
                    date: _dateTimeText,
                    title: _titleController.text,
                    uid: FirebaseAuth.instance.currentUser.uid,
                    typeEvent: _dropDownValue,
                    note: _noteController.text));
              } else {
                _viewModel.addPlanner(Planner(
                    date: _dateTimeText,
                    title: _titleController.text,
                    uid: FirebaseAuth.instance.currentUser.uid,
                    typeEvent: _dropDownValue));
              }
              Fluttertoast.showToast(
                  msg: "Record added successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
              _titleController.text = '';
              _noteController.text = '';
              _dateTimeText = null;
              _dropDownValue = null;
              Navigator.of(context, rootNavigator: true).pop('dialog');
            }
            setState(() {
              _isLoading = false;
            });
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
    _noteController.dispose();
    _isLoading = false;
    super.dispose();
  }
}
