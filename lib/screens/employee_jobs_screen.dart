import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_bench/models/job.dart';
import 'package:work_bench/screens/job_preview_employee_screen.dart';
import 'package:work_bench/view_models/employee_jobs_view_model.dart';

class EmployeeJobsScreen extends StatefulWidget {
  EmployeeJobsScreen({Key key}) : super(key: key);

  @override
  _EmployeeJobsScreenState createState() => _EmployeeJobsScreenState();
}

class _EmployeeJobsScreenState extends State<EmployeeJobsScreen> {
  EmployeeJobsViewModel _viewModel = EmployeeJobsViewModel();
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _viewModel.getDataOJobs().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    // getMyJobs(FirebaseAuth.instance.currentUser.uid).then((value) {
    //   setState(() {
    //     _myJobs = value;
    //   });
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
                "My Jobs",
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
                : _viewModel.jobs.length == 0
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
                    : buildListView(_viewModel)));
  }

  Widget buildListView(EmployeeJobsViewModel viewModel) {
    return Container(
        padding: EdgeInsets.all(10),
        child: ChangeNotifierProvider<EmployeeJobsViewModel>(
          create: (context) => viewModel,
          child: Consumer<EmployeeJobsViewModel>(
            builder: (context, model, child) => ListView.builder(
              itemBuilder: _buildRequestList,
              itemCount: model.jobs.length,
            ),
          ),
        ));
  }

  Widget _buildRequestList(BuildContext context, int index) {
    return itemCard(index, _viewModel.jobs[index]);
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  Widget itemCard(int index, Job x1) {
    String status;
    if (calculateDifference(DateTime.parse(x1.date)) == 0) {
      status = 'Today';
    } else if (calculateDifference(DateTime.parse(x1.date)) < 0) {
      status = 'Past';
    } else {
      status = 'Future';
    }
    // String status = DateTime.parse(x1.date).isBefore(DateTime.now())?'Past':'Current';
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => JobPreviewEmployeeScreen(
                      job: x1,
                      jobId: _viewModel.jobIds[index],
                    )));
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              text: x1.title,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'burbank')),
                        ],
                      ),
                    ),
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
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: 'burbank')),
                        ],
                      ),
                    ),
                    // Text(
                    //   x1.address,
                    //   style: TextStyle(fontSize: 20, color: Colors.black),
                    // ),
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
                              text: x1.address,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: 'burbank')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Text(
                status,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w900),
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
    // _selectedEvents.dispose();
    _isLoading = false;
    super.dispose();
  }
}
