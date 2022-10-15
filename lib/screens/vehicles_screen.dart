import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work_bench/models/vehicle.dart';
import 'package:work_bench/screens/add_vehicle_screen.dart';
import 'package:provider/provider.dart';
import 'package:work_bench/screens/vehicle_detail_screen.dart';
import 'package:work_bench/view_models/vehicles_view_model.dart';

class VehiclesScreen extends StatefulWidget {
  VehiclesScreen({Key key}) : super(key: key);

  @override
  _VehiclesScreenState createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  var _isLoading;
  VehiclesViewModel _viewModel = VehiclesViewModel();

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _viewModel.getDataOfVehicles().then((value) {
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
        //   image: DecorationImage(
        //       image: AssetImage("assets/images/background_img.jpg"),
        //       fit: BoxFit.cover),
        // ),
        child: Scaffold(
            backgroundColor: Color(0xFFFFFFFF).withOpacity(.4),
            appBar: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Color(0xFFFFFFFF).withOpacity(.2),
              centerTitle: true,
              title: Text(
                "Vehicles",
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddVehicleScreen()));
                      },
                      child: Icon(
                        Icons.add,
                        size: 28.0,
                        color: Colors.black,
                      ),
                    )),
              ],
            ),
            body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF4A4F54)),
                    ),
                  )
                : buildListView(_viewModel)));
  }

  Widget buildListView(VehiclesViewModel viewModel) {
    return Container(
        padding: EdgeInsets.all(10),
        child: ChangeNotifierProvider<VehiclesViewModel>(
          create: (context) => viewModel,
          child: Consumer<VehiclesViewModel>(
                  builder: (context, model, child) {
            if (model.vehicles.length == 0)
              return Center(
                child: Text(
                  'No Vehicles...',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            return ListView.builder(
              itemBuilder: _buildRequestList,
              itemCount: model.vehicles.length,
            );
          }),
        ));
  }

  Widget _buildRequestList(BuildContext context, int index) {
    return itemCard(index, _viewModel.vehicles[index]);
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

  Widget itemCard(int index, Vehicle x1) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: x1)));
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
              CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  backgroundImage: NetworkImage(x1?.imageUrl)),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      x1?.name,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      x1.address,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 80.0,
      width: MediaQuery.of(context).size.width,
      color: Colors.white70.withOpacity(.4),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: <Widget>[
          Text(
            'Choose vehicle image',
            style: TextStyle(fontSize: 14, color: Color(0xFF4A4F54)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    size: 30,
                    color: Color(0xFF4A4F54),
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.image_outlined,
                    size: 30,
                    color: Color(0xFF4A4F54),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    takePhoto(ImageSource.gallery);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Future<PickedFile> takePhoto(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    PickedFile _pickedFile;
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _pickedFile = pickedFile;
    });
    return _pickedFile;
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
}
