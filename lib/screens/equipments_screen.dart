import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:work_bench/models/equipment.dart';
import 'package:work_bench/screens/add_equipment_screen.dart';
import 'package:provider/provider.dart';
import 'package:work_bench/screens/equipment_detail_screen.dart';
import 'package:work_bench/view_models/equipments_view_model.dart';

class EquipmentsScreen extends StatefulWidget {
  EquipmentsScreen({Key key}) : super(key: key);

  @override
  _EquipmentsScreenState createState() => _EquipmentsScreenState();
}

class _EquipmentsScreenState extends State<EquipmentsScreen> {
  var _isLoading;
  EquipmentsViewModel _viewModel = EquipmentsViewModel();

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _viewModel.getDataOfEquipments().then((value) {
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
                'Equipments',
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
                                builder: (_) => AddEquipmentScreen()));
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

  Widget buildListView(EquipmentsViewModel viewModel) {
    return Container(
        padding: EdgeInsets.all(10),
        child: ChangeNotifierProvider<EquipmentsViewModel>(
          create: (context) => viewModel,
          child: Consumer<EquipmentsViewModel>(
            builder: (context, model, child) {
              if (model.equipments.length == 0)
                return Center(
                  child: Text(
                    'No Equipments...',
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
                  itemCount: model.equipments.length,
                );
            },
          ),
        ));
  }

  Widget _buildRequestList(BuildContext context, int index) {
    return itemCard(index, _viewModel.equipments[index]);
  }

  Widget itemCard(int index, Equipment x1) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => EquipmentDetailScreen(equipment: x1)));
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
                      x1?.address,
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
