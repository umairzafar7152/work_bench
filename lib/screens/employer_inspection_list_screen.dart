import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:work_bench/models/inspection.dart';
import 'package:work_bench/screens/employer_inspection_screen.dart';
import 'package:work_bench/screens/inspection_screen.dart';
import 'package:work_bench/view_models/employer_inspection_view_model.dart';

class EmployerInspectionListScreen extends StatefulWidget {
  EmployerInspectionListScreen({Key key}) : super(key: key);

  @override
  _EmployerInspectionListScreenState createState() => _EmployerInspectionListScreenState();
}

class _EmployerInspectionListScreenState extends State<EmployerInspectionListScreen> {
  EmployerInspectionViewModel _viewModel = EmployerInspectionViewModel();
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    isConnected().then((value) {
      if (value) {
        _viewModel.getInspectionRecord().then((value) {
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
              : buildListView(_viewModel),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => InspectionScreen()));
            },
            child: const Icon(Icons.add, color: Colors.black),
            backgroundColor: Color(0xFF4A4F54),
          ),
        ));
  }

  Widget buildListView(EmployerInspectionViewModel viewModel) {
    return Container(
        padding: EdgeInsets.all(10),
        child: ChangeNotifierProvider<EmployerInspectionViewModel>(
          create: (context) => viewModel,
          child:
          Consumer<EmployerInspectionViewModel>(builder: (context, model, child) {
            if (model.inspection.length == 0)
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
                itemCount: model.inspection.length,
              );
          }),
        ));
  }

  Widget _buildRequestList(BuildContext context, int index) {
    return itemCard(index, _viewModel.inspection[index]);
  }

  Widget itemCard(int index, Inspection x1) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmployerInspectionScreen(inspection: _viewModel.inspection[index])));
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
                              child: Icon(Icons.miscellaneous_services_outlined),
                            ),
                          ),
                          TextSpan(
                              text: x1.equipmentName,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: 'burbank')),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
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
