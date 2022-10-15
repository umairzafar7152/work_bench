import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:work_bench/models/inspection.dart';
import 'package:work_bench/reusable_widgets/custom_text_field.dart';

class EmployerInspectionScreen extends StatefulWidget {
  EmployerInspectionScreen({Key key, this.inspection}) : super(key: key);
  final Inspection inspection;

  @override
  _EmployerInspectionScreenState createState() =>
      _EmployerInspectionScreenState();
}

class _EmployerInspectionScreenState extends State<EmployerInspectionScreen> {
  // Flha _flha;
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _equipmentController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    _emailController.text = widget.inspection.email;
    _dateController.text = widget.inspection.date;
    _equipmentController.text = widget.inspection.equipmentName;
    _noteController.text = widget.inspection.note;
    // _flha = Flha();
    // _flha.uid = FirebaseAuth.instance.currentUser.uid;
    // _flha.date = format.format(DateTime.now());
    // setState(() {
    //   _isLoading = true;
    // });
    // isConnected().then((value) {
    //   if (value) {
    //
    //   } else {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   }
    // });
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
                          Text('Email',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          CustomTextField(
                              prefixIcon: Icon(Icons.person_outline_rounded),
                              hintText: 'Email',
                              inputType: TextInputType.name,
                              controller: _emailController,
                              isEnabled: false),
                          SizedBox(height: 10),
                          Text('Date',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          CustomTextField(
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                              hintText: 'Date',
                              inputType: TextInputType.name,
                              controller: _dateController,
                              isEnabled: false),
                          SizedBox(height: 10),
                          Text('Vehicle',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          CustomTextField(
                              prefixIcon:
                                  Icon(Icons.miscellaneous_services_outlined),
                              hintText: 'Vehicle',
                              inputType: TextInputType.name,
                              controller: _equipmentController,
                              isEnabled: false),
                          SizedBox(height: 10),
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
                              customTableRow(
                                  'Engine', widget.inspection.engine),
                              customTableRow('Frame', widget.inspection.frame),
                              customTableRow('Boom', widget.inspection.boom),
                              customTableRow('Stick', widget.inspection.stick),
                              customTableRow(
                                  'ROPS/FOPS', widget.inspection.rops),
                              customTableRow('Hyd. Cylinders',
                                  widget.inspection.hydCylinders),
                              customTableRow(
                                  'Latches/locks', widget.inspection.latches),
                              customTableRow(
                                  'Bucket/blade', widget.inspection.bucket),
                              customTableRow('Tires', widget.inspection.tires),
                              customTableRow('Rubber track',
                                  widget.inspection.rubberTrack),
                              customTableRow(
                                  'Linkages', widget.inspection.linkages),
                              customTableRow('Undercarriage',
                                  widget.inspection.underCarriage),
                              customTableRow(
                                  'work tool', widget.inspection.workTool),
                              customTableRow(
                                  'Final drives', widget.inspection.finalDrives)
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
                              customTableRow(
                                  'Engine', widget.inspection.opEngine),
                              customTableRow('Hyd. Cylinders',
                                  widget.inspection.opHydCylinders),
                              customTableRow('Track speed',
                                  widget.inspection.opTrackSpeed),
                              customTableRow(
                                  'Boom drift', widget.inspection.opBoomDrift),
                              customTableRow('Bushing movement',
                                  widget.inspection.opBushingMovement),
                              customTableRow('Leaks, drips',
                                  widget.inspection.opLeaksDrips)
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
                                  widget.inspection.skidSteerChainCase),
                              customTableRow('Skid steer driveline',
                                  widget.inspection.skidSteerDriveline),
                              customTableRow(
                                  'Wheel loader articulation joint',
                                  widget
                                      .inspection.wheelLoaderArticulationJoint),
                              customTableRow('Excavator swing bearing',
                                  widget.inspection.excavatorSwingBearing),
                              customTableRow('Dozer PAT blade',
                                  widget.inspection.dozerPatBlade)
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Note',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 20)),
                          ),
                          SizedBox(height: 10.0),
                          CustomTextField(
                              isEnabled: false,
                              prefixIcon: Icon(Icons.text_fields_outlined),
                              hintText: 'Add Note',
                              inputType: TextInputType.multiline,
                              controller: _noteController,
                              maxLines: 5),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  )));
  }

  TableRow customTableRow(String itemName, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(itemName,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(value != null ? value : 'N/A',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      )
    ]);
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
    _emailController.dispose();
    _equipmentController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
