import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_bench/models/job.dart';
import 'package:work_bench/services/employee_calendar_service.dart';
import 'package:work_bench/services/service_locator.dart';

class EmployeeCalendarModel extends ChangeNotifier {
  final EmployeeCalendarService _service = serviceLocator<EmployeeCalendarService>();

  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;
  // Map<DateTime, List<Job>> _jobsMap = {};
  // Map<DateTime, List<Job>> get jobsMap => _jobsMap;

  Future<void> getDataOfJobs() async {
    _service.getMyJobs(FirebaseAuth.instance.currentUser.uid).then((value) {
      _jobs.addAll(value);
      // _getJobEvents();
    });
    notifyListeners();
  }

  // void getJobEvents() {
  //   for(int i=0;i<_jobs.length;i++) {
  //     print(DateTime.parse(_jobs[i].date));
  //     // if(_jobsMap[DateTime.parse(_jobs[i].date)]==null)
  //     //   _jobsMap[DateTime.parse(_jobs[i].date)] = [];
  //     _jobsMap[DateTime.parse(_jobs[i].date)].add(_jobs[i]);
  //   }
  // }

  // List<Job> getEventsOfDay(DateTime day) {
  //   return _jobsMap[day]??[];
  // }
//   var jobEvents = LinkedHashMap<DateTime, List<Job>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
//   )..addAll(_jobs);
//
//   var _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//   key: (item) => DateTime.utc(2020, 10, item * 5),
//   value: (item) => List.generate(
//   item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
//   ..addAll({
//   DateTime.now(): [
//   Event('Today\'s Event 1'),
//   Event('Today\'s Event 2'),
//   ],
// });
//
// int getHashCode(DateTime key) {
//   return key.day * 1000000 + key.month * 10000 + key.year;
// }
}
