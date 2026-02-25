import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_coffee/stubs/amap_stub.dart';
import 'dart:math';
import 'package:flutter_coffee/stubs/decorated_flutter_stub.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/mapUtils.dart';

class MapLocationScreen extends StatefulWidget {
  final Map<String, dynamic> machine;
  MapLocationScreen(this.machine);
  @override
  MapLocationScreenState createState() => MapLocationScreenState();
}

class MapLocationScreenState extends State<MapLocationScreen> {
  AmapController? _mapcontroller;
  final _amapLocation = AmapLocation.instance;
  LatLng? _tolatLng;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('到这里去')),
        body: DecoratedColumn(
      children: <Widget>[
        Flexible(
          flex: 1,
          child:
              AmapView(
                mapType: MapType.Standard,
                showZoomControl: true,
                showCompass: true,
                showScaleControl: true,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                rotateGestureEnabled: true,
                tiltGestureEnabled: true,
                zoomLevel: 16,
                onMapCreated: (controller) async {
                  _mapcontroller = controller;

                  await controller.requireAlwaysAuth();
                  await controller.setZoomLevel(16.0);
                  await controller.showMyLocation(MyLocationOption());
                },
              ),

        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: DecoratedColumn(
              scrollable: true,
              divider: kDividerTiny,
              children: <Widget>[
            ListTile(
              title: Text("高德导航"),
              onTap: ()=>MapUtil.gotoAMap(_tolatLng!.longitude, _tolatLng!.latitude),
            ),
                ListTile(
                  title: Text("百度导航"),
                  onTap: ()=>MapUtil.gotoBaiduMap(_tolatLng!.longitude, _tolatLng!.latitude),
                ),
                ListTile(
                  title: Text("苹果导航"),
                  onTap: ()=>MapUtil.gotoAppleMap(_tolatLng!.longitude, _tolatLng!.latitude),
                ),
                ListTile(
                  title: Text("腾讯地图"),
                  onTap: ()=>MapUtil.gotoTencentMap(_tolatLng!.longitude, _tolatLng!.latitude),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }


  _getinitLocation() async {
    if (await Permission.location.request().isGranted) {
      _tolatLng=getTheLatLng(widget.machine);
      await _mapcontroller?.setCenterCoordinate(_tolatLng);

      await _mapcontroller?.addMarker(MarkerOption(
        latLng: _tolatLng,
      ));

      }
      setState(() {});
    }

  LatLng getTheLatLng(Map<String, dynamic> it) {
    double nextLat =
        double.parse(it['latitudeLongitude'].toString().split(",")[1]);
    double nextLng =
        double.parse(it['latitudeLongitude'].toString().split(",")[0]);

    return LatLng(nextLat, nextLng);
  }

  MarkerOption getTheMakerOption(Map<String, dynamic> it) {
    return MarkerOption(
      latLng: getTheLatLng(it),
      title: '${it['name']}NO:${it['serialNumber']}',
      snippet: '${it['address']}',
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${it['name']}',
            style: TextStyle(fontSize: 10, color: Colors.red),
          ),
          Image.asset('images/test_icon.png'),
        ],
      ),
      infoWindowEnabled: true,
      object: '1',
    );
  }

  @override
  void initState() {
    super.initState();
    _getinitLocation();
  }

  @override
  void dispose() {
    super.dispose();
    _mapcontroller = null;
  }
}
