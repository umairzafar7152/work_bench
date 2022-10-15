import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_bench/models/flha.dart';
import 'package:work_bench/screens/edit_flha_screen.dart';
import 'package:work_bench/screens/flha_screen.dart';
import 'package:work_bench/view_models/employer_flha_view_model.dart';

class EmployerFLHAListScreen extends StatefulWidget {
  EmployerFLHAListScreen({Key key}) : super(key: key);

  @override
  _EmployerFLHAListScreenState createState() => _EmployerFLHAListScreenState();
}

class _EmployerFLHAListScreenState extends State<EmployerFLHAListScreen> {
  EmployerFlhaViewModel _viewModel = EmployerFlhaViewModel();
  bool _isLoading = false;

  var format = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    isConnected().then((value) {
      if (value) {
        _viewModel.getFlhaRecord().then((value) {
          _viewModel.getTaskListRecord();
          _viewModel.getSignatureRecord();
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
              : buildListView(_viewModel),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => FLHAScreen()));
            },
            child: const Icon(Icons.add, color: Colors.black),
            backgroundColor: Color(0xFF4A4F54),
          ),
        ));
  }

  Widget buildListView(EmployerFlhaViewModel viewModel) {
    return Container(
        padding: EdgeInsets.all(10),
        child: ChangeNotifierProvider<EmployerFlhaViewModel>(
          create: (context) => viewModel,
          child:
              Consumer<EmployerFlhaViewModel>(builder: (context, model, child) {
            if (model.flha.length == 0)
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
                itemCount: model.flha.length,
              );
          }),
        ));
  }

  Widget _buildRequestList(BuildContext context, int index) {
    return itemCard(index, _viewModel.flha[index]);
  }

  Widget itemCard(int index, Flha x1) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EditFLHAScreen(
                    flha: x1,
                    tasksList:
                        _viewModel.taskList[_viewModel.flhaIds[index]], flhaId: _viewModel.flhaIds[index], signatureList: _viewModel.signatureList[_viewModel.flhaIds[index]])));
      },
      child: Card(
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
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.person_outline_rounded),
                            ),
                          ),
                          TextSpan(
                              text: x1.email,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: 'burbank')),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.calendar_today_outlined),
                            ),
                          ),
                          TextSpan(
                              text: x1.date,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: 'burbank')),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.account_balance),
                            ),
                          ),
                          TextSpan(
                              text: x1.companyName,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: 'burbank')),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(Icons.location_on_outlined),
                            ),
                          ),
                          TextSpan(
                              text: x1.taskAddress,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: 'burbank')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
    _isLoading = false;
    super.dispose();
  }
}
