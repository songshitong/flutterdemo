import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amap_base_location/amap_base_location.dart';
import 'package:permission_handler/permission_handler.dart';

class AmapPage extends StatefulWidget {
  @override
  _AmapPageState createState() => _AmapPageState();
}

class _AmapPageState extends State<AmapPage> {
  final _amapLocation = AMapLocation();
  Location location;
  bool isStartLocation = false;
  @override
  void initState() {
    super.initState();
    final options = LocationClientOptions(
      isOnceLocation: true,
      locatingWithReGeocode: true,
    );
    AMap.init('94c6f1bd9aa0a479e08804b8d3e57b7c').then((value) async {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler().requestPermissions([PermissionGroup.location]);

      print("value $value");
      isStartLocation = true;
      await _amapLocation.init();
      _amapLocation.getLocation(options).then((result) {
        setState(() {
          location = result;
          print("location $location");
        });
      });
    });
  }

  @override
  void dispose() {
    if (isStartLocation) _amapLocation.stopLocate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("高德地图"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[Text("$location")],
        ),
      ),
    );
  }
}
