import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_bench/models/job.dart';

class EmployeeCalendarService {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('job');

  Future<List<Job>> getMyJobs(String uid) async {
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
}
