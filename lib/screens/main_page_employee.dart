import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:work_bench/models/employee.dart';
import 'package:work_bench/screens/employee_edit_profile_screen.dart';
import 'package:work_bench/screens/employee_jobs_screen.dart';
import 'package:work_bench/screens/equipments_screen.dart';
import 'package:work_bench/screens/inspection_screen.dart';
import 'package:work_bench/screens/login_screen.dart';
import 'package:work_bench/screens/planner_screen.dart';
import 'package:work_bench/screens/vehicles_screen.dart';
import 'package:work_bench/view_models/user_authentication_details.dart';
import 'employer_flha_list_screen.dart';
import 'maintenance_screen.dart';

class MainPageEmployee extends StatefulWidget {
  MainPageEmployee({
    Key key
  }) : super(key: key);
  @override
  _MainPageEmployeeState createState() => _MainPageEmployeeState();
}

class _MainPageEmployeeState extends State<MainPageEmployee> {
  String _avatarUrl =
      'https://firebasestorage.googleapis.com/v0/b/work-bench-2bf1d.appspot.com/o/avatar_1.jpg?alt=media&token=c3084db6-0605-4525-ae78-5b83c28e9e5d';
  Map<String, dynamic> _snapshot;
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    getDataOfUser(FirebaseAuth.instance.currentUser.uid).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("assets/images/background_img.jpg"),
        //         fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Color(0xFFFFFFFF).withOpacity(.4),
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Color(0xFFFFFFFF).withOpacity(.2),
            centerTitle: true,
            title: Text(
              "Employee Home",
              style: TextStyle(color: Colors.black),
            ),
            leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditEmployeeProfileScreen(employee: Employee.fromMap(_snapshot)))).then((value) {
                            if(value!=null) {
                              setState(() {
                                _snapshot = value;
                              });
                            }
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 3, bottom: 3, left: 12),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        _snapshot != null
                            ? _snapshot['profileImage'] == '' || _snapshot['profileImage'] == null
                            ? _avatarUrl
                            : "${_snapshot['profileImage'].toString()}"
                            :
                        _avatarUrl),
                  ),
                )),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      UserAuth().logOut();
                      // await auth.signOut().then((_) {
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => LogInScreen()));
                      // });
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.black,
                      size: 26.0,
                    ),
                  )),
            ],
          ),
          body: _isLoading
              ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A4F54)),
            ),
          )
              : GridView.count(
            semanticChildCount: 2,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            mainAxisSpacing: 20,
            crossAxisSpacing: 25,
            crossAxisCount: 2,
            children: <Widget>[
              categoryItems('Inspection', 'assets/images/inspection.png'),
              categoryItems('Equipment', 'assets/images/equipment.png'),
              categoryItems('Vehicles', 'assets/images/vehicle.png'),
              // categoryItems('Alerts', 'assets/images/alerts.png'),
              categoryItems('Planner', 'assets/images/planner.png'),
              categoryItems('Maintenance', 'assets/images/maintenance.png'),
              // categoryItems('Calendar', 'assets/images/calendar.png'),
              categoryItems('My Jobs', 'assets/images/job.png'),
              categoryItems('FLHA', 'assets/images/inspection.png'),
            ],
          ),
        ));
  }

  Widget categoryItems(String itemName, String itemUrl) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            switch (itemName) {
              case 'Inspection':
                return InspectionScreen();
                break;
              case 'Equipment':
                return EquipmentsScreen();
                break;
              case 'Vehicles':
                return VehiclesScreen();
                break;
              // case 'Alerts':
              //   return EmployerAlertsScreen();
              //   break;
              case 'Planner':
                return PlannerScreen();
                break;
              case 'Maintenance':
                return MaintenanceScreen();
                break;
              // case 'Calendar':
              //   return EmployeeCalendar();
              //   break;
              case 'My Jobs':
                return EmployeeJobsScreen();
                break;
              case 'FLHA':
                return EmployerFLHAListScreen();
                break;
            }
            return null;
          }),
        );
      },
      child: itemButton(itemName, itemUrl),
    );
  }

  Widget itemButton(String itemName, String iconUrl) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color(0xFF4A4F54).withOpacity(.7),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 70,
            child: Image.asset(
              iconUrl,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            flex: 30,
            child: Center(
              child: Text(
                itemName,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getDataOfUser(String userIdRequired) async {
    var docRef =
        FirebaseFirestore.instance.collection("employees").doc(userIdRequired);
    await docRef.get().then((value) {
      setState(() {
        // _snapshot = value;
        _snapshot = value.data();
      });
    });
    return _snapshot;
  }

  @override
  void dispose() {
    // _snapshot = null;
    _isLoading = null;
    super.dispose();
  }
}
