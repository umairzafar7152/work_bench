import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:work_bench/models/job.dart';

class EmployeeCalendar extends StatefulWidget {
  EmployeeCalendar({Key key}) : super(key: key);

  @override
  _EmployeeCalendarState createState() => _EmployeeCalendarState();
}

class _EmployeeCalendarState extends State<EmployeeCalendar> {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('job');
  Map<DateTime, List<Job>> _jobsMap = {};
  bool _isLoading = false;
  // ValueNotifier<List<Job>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  // EmployeeCalendarModel _viewModel = EmployeeCalendarModel();

  Future<Map<DateTime, List<Job>>> _getJobEvents(List<Job> jobs) async {
    Map<DateTime, List<Job>> localMap = {};
    for (int i = 0; i < jobs.length; i++) {
      print(DateTime.parse(jobs[i].date));
      if (localMap[DateTime.parse(jobs[i].date)] == null)
        localMap[DateTime.parse(jobs[i].date)] = [];
      localMap[DateTime.parse(jobs[i].date)].add(jobs[i]);
    }
    return localMap;
  }

  Future<List<Job>> _getMyJobs(String uid) async {
    List<Job> list = [];
    QuerySnapshot ref =
        await collectionReference.where("employeeId", isEqualTo: uid).get();
    var documents = ref.docs;
    if (documents.length > 0) {
      try {
        for (int i = 0; i < documents.length; i++) {
          Job job = Job.fromMap(documents[i].data());
          list.add(job);
        }
      } catch (e) {
        print("Exception: $e");
        return list;
      }
    }
    return list;
  }

  List<Job> _getEventsOfDay(DateTime day) {
    print("$day \n CHECK>>>>>>>>||||||${_jobsMap[day]}");
    return _jobsMap[day] ?? [];
  }

  @override
  void initState() {
    _jobsMap = {};
    _selectedDay = _focusedDay;
    // _viewModel.getDataOfJobs();
    _getMyJobs(FirebaseAuth.instance.currentUser.uid).then((value) {
      _getJobEvents(value).then((value) {
        setState(() {
          _jobsMap = value;
        });
      });
      // _selectedEvents = ValueNotifier(_getEventsOfDay(_selectedDay));
    });
    // _getJobEvents(_viewModel.jobs);
    // _viewModel.getJobEvents();
    super.initState();
  }

  // List<Job> _getEventsForDay(DateTime day) {
  //   // Implementation example
  //   return jobEvents[day] ?? [];
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      // _selectedEvents.value = _getEventsOfDay(_selectedDay);
    }
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
                "Job Events",
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
                : Column(
                    children: <Widget>[
                      TableCalendar<Job>(
                        headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18)),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                                color: Color(0xFF4A4F54),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        calendarFormat: _calendarFormat,
                        eventLoader: _getEventsOfDay,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Color(0xFF4A4F54).withOpacity(.5),
                            shape: BoxShape.circle,
                          ),
                          outsideDaysVisible: false,
                          selectedDecoration: BoxDecoration(
                            color: Color(0xFF4A4F54),
                            shape: BoxShape.circle,
                          ),
                        ),
                        onDaySelected: _onDaySelected,
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                      ..._getEventsOfDay(_selectedDay).map((Job j) => ListTile(title: Text(j.title),)),
                      const SizedBox(height: 8.0),
                      // Expanded(
                      //   child: ValueListenableBuilder<List<Job>>(
                      //     valueListenable: _selectedEvents,
                      //     builder: (context, value, _) {
                      //       return ListView.builder(
                      //         itemCount: value.length,
                      //         itemBuilder: (context, index) {
                      //           return Container(
                      //             margin: const EdgeInsets.symmetric(
                      //               horizontal: 12.0,
                      //               vertical: 4.0,
                      //             ),
                      //             decoration: BoxDecoration(
                      //               border: Border.all(),
                      //               borderRadius: BorderRadius.circular(12.0),
                      //             ),
                      //             child: ListTile(
                      //               onTap: () => print('${value[index]}'),
                      //               title: Text('${value[index]}'),
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     },
                      //   ),
                      // )
                    ],
                  )));
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
