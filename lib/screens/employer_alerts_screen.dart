import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EmployerAlertsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("assets/images/background_img.jpg"),
        //       fit: BoxFit.cover),
        // ),
        child: EmployerAlertsPage(title: 'Alerts'));
  }
}

class EmployerAlertsPage extends StatefulWidget {
  EmployerAlertsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EmployerAlertsPageState createState() => _EmployerAlertsPageState();
}

class _EmployerAlertsPageState extends State<EmployerAlertsPage> {
  final List<Map<String, dynamic>> requests = [];
  bool _isLoading = false;
  List<String> empNameList = [
    'Equipment/Vehicle Name',
    'Equipment/Vehicle Name',
    'Equipment/Vehicle Name',
    'Equipment/Vehicle Name',
  ];
  List<String> empPositionList = [
    'issue found in it',
    'issue found in it',
    'issue found in it',
    'issue found in it'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF).withOpacity(.4),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Color(0xFFFFFFFF).withOpacity(.2),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A4F54)),
        ),
      )
          : Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView.builder(
          itemBuilder: _buildRequestList,
          itemCount: empNameList.length,
        ),
        // _newSnapshot?.length == 0
        //     ? Center(
        //   child: Text(
        //     'No pending approval...',
        //     style: TextStyle(
        //       fontSize: 20,
        //       color: Color(0xFF0C0467),
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // )
        //     : Container(
        //   padding: EdgeInsets.all(10),
        //   child: ListView.builder(
        //     itemBuilder: _buildRequestList,
        //     itemCount: _newSnapshot.length,
        //   ),
      ),
    );
  }

  Widget _buildRequestList(BuildContext context, int index) {
    // return itemCard(index, _newSnapshot[index]);
    return itemCard(index, empNameList[index]);
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
  Widget itemCard(int index, String x1) {
    return Container(
      height: 90,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        clipBehavior: Clip.antiAlias,
        color: Color(0xFF4A4F54).withOpacity(.7),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                x1,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                empPositionList[index],
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> addDataToCloud(
  //     Map<String, dynamic> dataToUpload, QueryDocumentSnapshot x2) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('approved_items');
  //   collectionReference.add(dataToUpload).then((value) {
  //     // _approvedItemId = value.id;
  //   }).catchError((error, stackTrace) {
  //     print("FAILED TO ADD DATA: $error");
  //     print("STACKTRACE IS:  $stackTrace");
  //   });
  //   // deleting data from pending approvals
  //   FirebaseFirestore.instance.collection('acquired_items').doc(x2.id).delete();
  // }
  //
  // Future<dynamic> getDataOfItems(String emailRequired) async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("acquired_items")
  //       .where("lessor_email", isEqualTo: emailRequired)
  //       .get();
  //   _snapshot = querySnapshot.docs;
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
  //
  // String getUserEmail() {
  //   final User user = _auth.currentUser;
  //   _uId = user.uid;
  //   return user.email;
  // }

  // Future<DocumentSnapshot> getDataOfUser(String userIdRequired) async {
  //   var docRef =
  //       FirebaseFirestore.instance.collection("users").doc(userIdRequired);
  //   await docRef.get().then((value) {
  //     setState(() {
  //       _userSnapshot = value;
  //     });
  //   });
  //   return _userSnapshot;
  // }

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
