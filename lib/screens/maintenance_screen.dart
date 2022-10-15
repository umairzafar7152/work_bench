import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:work_bench/models/maintenance.dart';
import 'package:work_bench/reusable_widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:work_bench/view_models/maintenance_view_model.dart';

class MaintenanceScreen extends StatefulWidget {
  MaintenanceScreen({Key key}) : super(key: key);

  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  String dropDownValue;
  TextEditingController alertServiceController = TextEditingController();
  bool _isLoading;
  MaintenanceViewModel _viewModel = MaintenanceViewModel();
  List<String> _list = [];
  List<String> _listIds = [];

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _viewModel.getDataOfMaintenance().then((value) async {
      await _viewModel.getList().then((value) async {
        for (int i = 0; i < _viewModel.list.length; i++) {
          var a = _viewModel.list[i].data()['name'];
          if (a != null) {
            _list.add(a);
            _listIds.add(_viewModel.list[i].id);
          }
          print(a);
        }
        setState(() {
          _isLoading = false;
        });
        // _viewModel.getListIds().then((value) {
        // });
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
                "Maintenance Record",
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
                : buildListView(_viewModel)));
  }

  Widget buildListView(MaintenanceViewModel viewModel) {
    return Container(
        padding: EdgeInsets.all(10),
        child: ChangeNotifierProvider<MaintenanceViewModel>(
          create: (context) => viewModel,
          child:
              Consumer<MaintenanceViewModel>(builder: (context, model, child) {
            if (model.maintenanceRecords.length == 0)
              return Center(
                child: Text(
                  'No record found...',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            else
              return ListView.builder(
                itemBuilder: _buildRequestList,
                itemCount: model.maintenanceRecords.length,
              );
          }),
        ));
  }

  Widget _buildRequestList(BuildContext context, int index) {
    return itemCard(index, _viewModel.maintenanceRecords[index]);
  }

  Widget itemCard(int index, Maintenance x1) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      clipBehavior: Clip.antiAlias,
      color: Color(0xFF4A4F54).withOpacity(.7),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    x1.name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.person_outline_rounded),
                          ),
                        ),
                        TextSpan(text: x1.email, style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'burbank')),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.miscellaneous_services_outlined),
                          ),
                        ),
                        TextSpan(text: x1.service, style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'burbank')),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.calendar_today_outlined),
                          ),
                        ),
                        TextSpan(text: x1.date, style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'burbank')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        "Add Record",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return
        Container(
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
                        hint: Text('Select Equipment/Vehicle'),
                        items: _list.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (x) {
                          setState(() {
                            dropDownValue = x;
                          });
                        },
                      ),
                    )),
                // CustomTextField(
                //     prefixIcon: Icon(Icons.directions_bus_outlined),
                //     hintText: 'Equipment/Vehicle Name',
                //     inputType: TextInputType.name,
                //     controller: alertNameController),
                SizedBox(height: 5),
                CustomTextField(
                    prefixIcon: Icon(Icons.text_fields_outlined),
                    hintText: 'Service you did',
                    inputType: TextInputType.name,
                    controller: alertServiceController),
                SizedBox(height: 5),
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
            print(
                "ADD SERVICE CONTROLLER TEXT: ${alertServiceController.text}");
            if (dropDownValue == null || alertServiceController.text == '') {
              Fluttertoast.showToast(
                  msg: "Fill all the fields",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              var format = DateFormat('yyyy-MM-dd');
              _viewModel
                  .addMaintenance(Maintenance(
                      uid: FirebaseAuth.instance.currentUser.uid,
                      email: FirebaseAuth.instance.currentUser.email,
                      name: dropDownValue,
                      service: alertServiceController.text,
                      date: format.format(DateTime.now())))
                  .then((value) {
                setState(() {
                  _isLoading = false;
                });
                Fluttertoast.showToast(
                    msg: "Record added successfully",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pop(context);
              });
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
    alertServiceController.dispose();
    super.dispose();
  }
}
