import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:work_bench/Screens/calculator_screen.dart';
import 'package:work_bench/Screens/employee_calendar.dart';
import 'package:work_bench/Screens/employee_info_screen.dart';
import 'package:work_bench/Screens/employees_list_screen.dart';
import 'package:work_bench/Screens/employer_alerts_screen.dart';
import 'package:work_bench/Screens/flha_screen.dart';
import 'package:work_bench/Screens/inspection_screen.dart';
import 'package:work_bench/Screens/jobs_screen.dart';
import 'package:work_bench/Screens/login_screen.dart';
import 'package:work_bench/Screens/main_page_employer.dart';
import 'package:work_bench/Screens/maintenance_screen.dart';
import 'package:work_bench/Screens/planner_screen.dart';
import 'package:work_bench/Screens/signup_employee_screen.dart';
import 'package:work_bench/Screens/signup_screen.dart';
import 'package:work_bench/Screens/vehicles_screen.dart';
import 'file:///D:/Flutter_Apps_Fiverr/work_bench/lib/view_models/user_authentication_details.dart';
import 'package:work_bench/providers/loading.dart';
import 'package:work_bench/screens/splash_screen.dart';
import 'package:work_bench/services/service_locator.dart';
import 'Screens/equipments_screen.dart';
import 'Screens/main_page_employee.dart';

void main() async {
  setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  // await NotificationsHelper.init();
  await FlutterDownloader.initialize();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserAuth()),
        ChangeNotifierProvider(create: (_) => Loading()),
        // ChangeNotifierProvider(create: (_) => AddEquipmentsViewModel()),
        // ChangeNotifierProvider(create: (_) => AddJobViewModel()),
        // ChangeNotifierProvider(create: (_) => AddVehicleViewModel()),
        // ChangeNotifierProvider(create: (_) => EmployeeListViewModel()),
        // ChangeNotifierProvider(create: (_) => GetEquipmentsViewModel()),
        // ChangeNotifierProvider(create: (_) => GetJobsViewModel()),
        // ChangeNotifierProvider(create: (_) => GetVehiclesViewModel()),
        // ChangeNotifierProvider(create: (_) => MaintenanceViewModel()),
      ],
      child: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Work Bench',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.grey,
            primaryColorBrightness: Brightness.light,
            accentColor: Color(0xFF4A4F54),
            accentColorBrightness: Brightness.light,
            fontFamily: 'Burbank',
            primaryColor: Colors.black,
          ),
          home: Container(
              decoration: BoxDecoration(
                color: Color(0xFF9C6D41),
              ),
              child: SplashScreen()),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF).withOpacity(.4),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        brightness: Brightness.dark,
        backgroundColor: Color(0xFFFFFFFF).withOpacity(.2),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.black,
            ),
            onPressed: () {}),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: GridView.count(
          semanticChildCount: 2,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          mainAxisSpacing: 20,
          crossAxisSpacing: 25,
          crossAxisCount: 2,
          children: <Widget>[
            categoryItems('Main Page Employer'),
            categoryItems('Log In'),
            categoryItems('Main Page Employee'),
            categoryItems('Sign Up Employer'),
            categoryItems('Sign Up Employee'),
            categoryItems('Employee Info Screen'),
            categoryItems('Employees List Screen'),
            categoryItems('Vehicles'),
            categoryItems('Equipments'),
            categoryItems('Maintenance'),
            categoryItems('Employer Alerts Screen'),
            categoryItems('Planner'),
            categoryItems('Jobs'),
            categoryItems('Employee Calendar'),
            categoryItems('Job Calculator'),
            categoryItems('Inspection Screen Employee'),
            categoryItems('FLHA Screen')
          ],
        ),
      ),
    );
  }

  Widget categoryItems(String itemName) {
    return TextButton(
      onPressed: () {
        if (itemName == 'Main Page Employer') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainPageEmployer()));
        } else if (itemName == 'Log In') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LogInScreen()));
        } else if (itemName == 'Main Page Employee') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainPageEmployee()));
        } else if (itemName == 'Sign Up Employer') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        } else if (itemName == 'Sign Up Employee') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignUpEmployeeScreen()));
        } else if (itemName == 'Employee Info Screen') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeInfoScreen()));
        } else if (itemName == 'Employees List Screen') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeesListScreen()));
        } else if (itemName == 'Vehicles') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VehiclesScreen()));
        } else if (itemName == 'Equipments') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EquipmentsScreen()));
        } else if (itemName == 'Maintenance') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MaintenanceScreen()));
        } else if (itemName == 'Employer Alerts Screen') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployerAlertsScreen()));
        } else if (itemName == 'Planner') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PlannerScreen()));
        } else if (itemName == 'Jobs') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => JobsScreen()));
        } else if (itemName == 'Employee Calendar') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EmployeeCalendar()));
        } else if (itemName == 'Job Calculator') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CalculatorScreen()));
        } else if (itemName == 'Inspection Screen Employee') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InspectionScreen()));
        } else if (itemName == 'FLHA Screen') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FLHAScreen()));
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           Posts(distance: _distance, category: itemName)),
        // );
      },
      child: itemButton(itemName),
    );
  }

  Widget itemButton(String itemName) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color(0xFF4A4F54).withOpacity(.7),
      ),
      child: Center(
        child: Text(
          itemName,
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
