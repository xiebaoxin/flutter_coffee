import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart'; //高德地图amap_base_location
import 'package:amap_map_fluttify/amap_map_fluttify.dart'; //高德地图amap_base_map
import 'dart:math';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/mapUtils.dart';

/**
 * ShowMapScreen
 * 地图缩放
 * 标注
 */
class MapLocationScreen extends StatefulWidget {
  final Map<String, dynamic> machine;
  MapLocationScreen(this.machine);
  @override
  MapLocationScreenState createState() => MapLocationScreenState();
}

class MapLocationScreenState extends State<MapLocationScreen> {
  AmapController _mapcontroller;
  final _amapLocation = AmapLocation.instance; //定位
  LatLng _tolatLng;
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
                // 地图类型
                mapType: MapType.Standard,
                // 是否显示缩放控件
                showZoomControl: true,
                // 是否显示指南针控件
                showCompass: true,
                // 是否显示比例尺控件
                showScaleControl: true,
                // 是否使能缩放手势
                zoomGesturesEnabled: true,
                // 是否使能滚动手势
                scrollGesturesEnabled: true,
                // 是否使能旋转手势
                rotateGestureEnabled: true,
                // 是否使能倾斜手势
                tiltGestureEnabled: true,

                // 缩放级别
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
              onTap: ()=>MapUtil.gotoAMap(_tolatLng.longitude, _tolatLng.latitude),
            ),
                ListTile(
                  title: Text("百度导航"),
                  onTap: ()=>MapUtil.gotoBaiduMap(_tolatLng.longitude, _tolatLng.latitude),
                ),
                ListTile(
                  title: Text("苹果导航"),
                  onTap: ()=>MapUtil.gotoAppleMap(_tolatLng.longitude, _tolatLng.latitude),
                ),
                ListTile(
                  title: Text("腾讯地图"),
                  onTap: ()=>MapUtil.gotoTencentMap(_tolatLng.longitude, _tolatLng.latitude),
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
      //将地图中心点移动到选择的点
      await _mapcontroller.setCenterCoordinate(_tolatLng);

      await _mapcontroller.addMarker(MarkerOption(
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
//    print("------LatLng($nextLat, $nextLng)------");

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
//      iconProvider: _assetsIcon1,
      infoWindowEnabled: true,
      object: '1',//index
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getinitLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mapcontroller = null;
  }
}
