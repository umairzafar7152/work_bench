import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature/signature.dart';
import 'package:work_bench/models/flha.dart';
import 'package:work_bench/reusable_widgets//custom_text_field.dart';
import 'package:image/image.dart' as encoder;
import 'package:work_bench/view_models/flha_view_model.dart';

class EditFLHAScreen extends StatefulWidget {
  EditFLHAScreen(
      {Key key, this.flha, this.tasksList, this.signatureList, this.flhaId})
      : super(key: key);
  final Flha flha;
  final List<Map<String, dynamic>> tasksList;
  final List<Map<String, dynamic>> signatureList;
  final String flhaId;

  @override
  _EditFLHAScreenState createState() => _EditFLHAScreenState();
}

class _EditFLHAScreenState extends State<EditFLHAScreen> {
  FlhaViewModel _viewModel = FlhaViewModel();
  bool _isLoading = false;
  TextEditingController _companyController = TextEditingController();
  TextEditingController _workController = TextEditingController();
  TextEditingController _permitController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _musterController = TextEditingController();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    _companyController.text = widget.flha.companyName;
    _workController.text = widget.flha.workToBeDone;
    _permitController.text = widget.flha.permitNo;
    _emailController.text = widget.flha.email;
    _musterController.text = widget.flha.musterPoint;
    // _flha = Flha();
    // _flha.uid = FirebaseAuth.instance.currentUser.uid;
    // _flha.date = format.format(DateTime.now());
    // setState(() {
    //   _isLoading = true;
    // });
    isConnected().then((value) {
      if (value) {
        _viewModel.fetchTaskRecord(widget.flhaId).then((value) {
          setState(() {
            _isLoading = false;
          });
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
                          Text('Company Name',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          CustomTextField(
                              prefixIcon: Icon(Icons.account_balance),
                              hintText: 'Company Name',
                              inputType: TextInputType.name,
                              controller: _companyController,
                              isEnabled: false),
                          SizedBox(height: 10),
                          Text('Work to be done',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          CustomTextField(
                              prefixIcon: Icon(Icons.work_outline_outlined),
                              hintText: 'Work to be done',
                              inputType: TextInputType.name,
                              controller: _workController,
                              isEnabled: false),
                          SizedBox(height: 10),
                          Text('Task Location',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                child: Text(
                                  "${widget.flha.taskAddress}",
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
                          SizedBox(height: 10),
                          Text('Muster Point',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          CustomTextField(
                              prefixIcon: Icon(Icons.person_outline_rounded),
                              hintText: 'Muster Point',
                              inputType: TextInputType.name,
                              controller: _musterController,
                              isEnabled: false),
                          SizedBox(height: 10),
                          Text('Permit No.',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          CustomTextField(
                              prefixIcon: Icon(Icons.text_fields_outlined),
                              hintText: 'Permit No.',
                              inputType: TextInputType.number,
                              controller: _permitController,
                              isEnabled: false),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'PPE Inspected\t',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'burbank')),
                                TextSpan(
                                    text: "${widget.flha.warningRibbon}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'burbank')),
                              ],
                            ),
                          ),
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
                              rows: widget
                                  .tasksList.map(
                                    ((element) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(element["task"],
                                                style:
                                                    TextStyle(fontSize: 14))),
                                            //Extracting from Map element the value
                                            DataCell(Text(element["hazard"],
                                                style:
                                                    TextStyle(fontSize: 14))),
                                            DataCell(Text(element["priority"],
                                                style:
                                                    TextStyle(fontSize: 14))),
                                            DataCell(Text(element["plan"],
                                                style:
                                                    TextStyle(fontSize: 14))),
                                          ],
                                        )),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'New Records',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w900),
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
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'Has a pre-use inspection of tools/equipment been completed?\t',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'burbank')),
                                TextSpan(
                                    text: "${widget.flha.warningRibbon}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'burbank')),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Warning ribbon needed?\t',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'burbank')),
                                TextSpan(
                                    text: "${widget.flha.warningRibbon}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'burbank')),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Is the worker working alone?\t',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'burbank')),
                                TextSpan(
                                    text: "${widget.flha.workingAlone}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'burbank')),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Job Completion',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Are all permit(s) closed out?\t',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'burbank')),
                                TextSpan(
                                    text: "${widget.flha.permitClosedOut}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'burbank')),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'Was the area cleaned up at the end of job/shift?\t',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'burbank')),
                                TextSpan(
                                    text: "${widget.flha.areaCleanedUp}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'burbank')),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Are there hazards remaining?\t',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'burbank')),
                                TextSpan(
                                    text: "${widget.flha.hazardsRemaining}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'burbank')),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'Were there any incidents/injuries?\t',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontFamily: 'burbank')),
                                TextSpan(
                                    text: "${widget.flha.incidentInjuries}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'burbank')),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Signatures',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          buildListView(),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: <Widget>[
                          //     Text(
                          //       'Signature',
                          //       style: TextStyle(
                          //           fontWeight: FontWeight.w900, fontSize: 20),
                          //     ),
                          //     Container(
                          //       color: Colors.grey[300],
                          //       child: widget.flha.signatureLink!=null&&widget.flha.signatureLink!=''?Image.network(widget.flha.signatureLink):Text(''),
                          //     )
                          //   ],
                          // ),

                          SizedBox(height: 10),
                          Text(
                            'Add Signature (Approve)',
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
                                if (_controller.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Sign to submit!",
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
                                  var signatureImage =
                                      await _controller.toImage();
                                  ByteData data =
                                      await signatureImage.toByteData();
                                  Uint8List listData =
                                      data.buffer.asUint8List();
                                  int height = signatureImage.height;
                                  int width = signatureImage.width;
                                  encoder.Image toEncodeImage =
                                      encoder.Image.fromBytes(
                                          width, height, listData);
                                  encoder.JpegEncoder jpgEncoder =
                                      encoder.JpegEncoder();
                                  List<int> encodedImage =
                                      jpgEncoder.encodeImage(toEncodeImage);

                                  await _viewModel
                                      .addSignatureRecord(
                                          Uint8List.fromList(encodedImage),
                                          widget.flhaId,
                                          FirebaseAuth
                                              .instance.currentUser.email)
                                      .then((value) async {
                                        await _viewModel.uploadTaskList(_tasksList, widget.flhaId).then((value) {
                                          Fluttertoast.showToast(
                                              msg: "Record Added successfully",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          Navigator.pop(context);
                                        });
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white70.withOpacity(.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                  )));
  }

  Widget buildListView() {
    return Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: _buildRequestList,
          itemCount: widget.signatureList.length,
        ));
  }

  Widget _buildRequestList(BuildContext context, int index) {
    return itemCard(index, widget.signatureList[index]);
  }

  Widget itemCard(int index, Map<String, dynamic> x1) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      clipBehavior: Clip.antiAlias,
      color: Color(0xFF4A4F54).withOpacity(.7),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "${x1['email']}",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            SizedBox(height: 3),
            Container(
              color: Colors.grey[300],
              child: x1['signatureLink'] != null && x1['signatureLink'] != ''
                  ? Image.network(x1['signatureLink'])
                  : Text(''),
            )
          ],
        ),
      ),
    );
  }

  TextEditingController _taskAlertController = TextEditingController();
  TextEditingController _hazardAlertController = TextEditingController();
  TextEditingController _priorityAlertController = TextEditingController();
  TextEditingController _planAlertController = TextEditingController();
  List<Map<String, String>> _tasksList = [];
  bool _enableTask = false;
  bool _enableHazard = false;
  bool _enablePriority = false;
  bool _enablePlan = false;
  String _selectTask;
  String _selectHazard;
  String _selectPriority;
  String _selectPlan;
  List<String> _tasks = [];
  List<String> _hazards = [];
  List<String> _priorities = [];
  List<String> _plans = [];
  String _taskValue;
  String _hazardValue;
  String _priorityValue;
  String _planValue;

  Widget customRecordDialog() {
    _tasks = [];
    _hazards = [];
    _priorities = [];
    _plans = [];
    for (int i = 0; i < _viewModel.tasks.length; i++) {
      _tasks.add(_viewModel.tasks[i]['task']);
      _hazards.add(_viewModel.tasks[i]['hazard']);
      _priorities.add(_viewModel.tasks[i]['priority']);
      _plans.add(_viewModel.tasks[i]['plan']);
    }
    _tasks.add("Add new value");
    _hazards.add("Add new value");
    _priorities.add("Add new value");
    _plans.add("Add new value");
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
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButton<String>(
                        value: _selectTask,
                        hint: Text('Select a task'),
                        items: _tasks.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectTask = val;
                          });
                          if (val == "Add new value") {
                            setState(() {
                              _taskValue = null;
                              _enableTask = true;
                              // selectTask = "";
                            });
                          } else {
                            setState(() {
                              _taskValue = val;
                              _enableTask = false;
                              // selectTask = val;
                            });
                          }
                        }),
                    SizedBox(height: 3),
                    CustomTextField(
                      isEnabled: _enableTask,
                      prefixIcon: Icon(Icons.work_outline_outlined),
                      hintText: 'Enter new hazard',
                      inputType: TextInputType.name,
                      controller: _taskAlertController,
                    ),
                    SizedBox(height: 3),
                    DropdownButton<String>(
                        value: _selectHazard,
                        hint: Text('Select a hazard'),
                        items: _hazards.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectHazard = val;
                          });
                          if (val == "Add new value") {
                            setState(() {
                              _hazardValue = null;
                              _enableHazard = true;
                            });
                          } else {
                            setState(() {
                              _hazardValue = val;
                              _enableHazard = false;
                            });
                          }
                        }),
                    SizedBox(height: 3),
                    CustomTextField(
                      isEnabled: _enableHazard,
                      prefixIcon: Icon(Icons.work_outline_outlined),
                      hintText: 'Enter new Hazard',
                      inputType: TextInputType.name,
                      controller: _hazardAlertController,
                    ),
                    SizedBox(height: 3),
                    DropdownButton<String>(
                        value: _selectPriority,
                        hint: Text('Select a priority'),
                        items: _priorities.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectPriority = val;
                          });
                          if (val == "Add new value") {
                            setState(() {
                              _priorityValue = null;
                              _enablePriority = true;
                            });
                          } else {
                            setState(() {
                              _priorityValue = val;
                              _enablePriority = false;
                            });
                          }
                        }),
                    SizedBox(height: 3),
                    CustomTextField(
                      isEnabled: _enablePriority,
                      prefixIcon: Icon(Icons.work_outline_outlined),
                      hintText: 'Enter new Priority',
                      inputType: TextInputType.name,
                      controller: _priorityAlertController,
                    ),
                    SizedBox(height: 3),
                    DropdownButton<String>(
                        value: _selectPlan,
                        hint: Text('Select a plan'),
                        items: _plans.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectPlan = val;
                          });
                          if (val == "Add new value") {
                            setState(() {
                              _planValue = null;
                              _enablePlan = true;
                            });
                          } else {
                            setState(() {
                              _planValue = val;
                              _enablePlan = false;
                            });
                          }
                        }),
                    SizedBox(height: 3),
                    CustomTextField(
                      isEnabled: _enablePlan,
                      prefixIcon: Icon(Icons.work_outline_outlined),
                      hintText: 'Enter Plans to Eliminate/Control',
                      inputType: TextInputType.name,
                      controller: _planAlertController,
                    ),
                  ],
                ));
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'Add',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
          ),
          onPressed: () {
            if (_enableTask) _taskValue = _taskAlertController.text;
            if (_enableHazard) _hazardValue = _hazardAlertController.text;
            if (_enablePriority) _priorityValue = _priorityAlertController.text;
            if (_enablePlan) _planValue = _planAlertController.text;
            if (_taskValue==null || _hazardValue==null || _priorityValue==null || _planValue==null
            ||_taskValue=='' || _hazardValue=='' || _priorityValue=='' || _planValue=='') {
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
                  'task': _taskValue,
                  'hazard': _hazardValue,
                  'priority': _priorityValue,
                  'plan': _planValue
                });
              });
              _taskAlertController.text = '';
              _hazardAlertController.text = '';
              _priorityAlertController.text = '';
              _planAlertController.text = '';
              _selectTask = null;
              _selectHazard = null;
              _selectPriority = null;
              _selectPlan = null;
              _taskValue = '';
              _hazardValue = '';
              _priorityValue = '';
              _planValue = '';
              Navigator.pop(context);
            }
            // if (_taskAlertController.text == '' ||
            //     _hazardAlertController.text == '' ||
            //     _priorityAlertController.text == '' ||
            //     _planAlertController.text == '') {
            //   Fluttertoast.showToast(
            //       msg: "Fill all the fields",
            //       toastLength: Toast.LENGTH_LONG,
            //       gravity: ToastGravity.BOTTOM,
            //       timeInSecForIosWeb: 1,
            //       backgroundColor: Colors.red,
            //       textColor: Colors.white,
            //       fontSize: 16.0);
            // } else {
            //   setState(() {
            //     _tasksList.add({
            //       'task': _taskAlertController.text,
            //       'hazard': _hazardAlertController.text,
            //       'priority': _priorityAlertController.text,
            //       'plan': _planAlertController.text
            //     });
            //   });
            //   _taskAlertController.text = '';
            //   _hazardAlertController.text = '';
            //   _priorityAlertController.text = '';
            //   _planAlertController.text = '';
            //   Navigator.pop(context);
            // }
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
    _workController.dispose();
    _permitController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _musterController.dispose();
    _taskAlertController.dispose();
    _hazardAlertController.dispose();
    _priorityAlertController.dispose();
    _planAlertController.dispose();
    super.dispose();
  }
}
