import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart'; //高德地图amap_base_location
import 'package:amap_map_fluttify/amap_map_fluttify.dart'; //高德地图amap_base_map
import 'dart:math';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/dataUtils.dart';
import '../views/comm/comwidget.dart';

/**
 * ShowMapScreen
 * 地图缩放
 * 标注
 */
class ShowMapScreen extends StatefulWidget {
  @override
  DrawPointScreenState createState() => DrawPointScreenState();
//  _ShowMapScreenState createState() => _ShowMapScreenState();
}

final _assetsIcon1 = AssetImage('images/test_icon.png');
final _assetsIcon2 = AssetImage('images/arrow.png');

class DrawPointScreenState extends State<ShowMapScreen> {
  AmapController _mapcontroller;
  final _amapLocation = AmapLocation.instance; //定位
  List<Marker> _markers = [];
  Map<String, dynamic> _machine;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(title: const Text('绘制点标记')),
        body: DecoratedColumn(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Stack(
            children: <Widget>[
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

                // 标识点击回调
//                onMarkerClicked: (Marker marker) {
//
//                },
//      // 地图点击回调
//      onMapClick: (LatLng coord) {},
//      // 地图拖动回调
//      onMapDrag: (MapDrag drag) {},
                // 地图创建完成回调

                // 缩放级别
                zoomLevel: 16,
                /*   // 中心点坐标
                  centerCoordinate:_mylocation.latLng,
                  markers: [
                    for (int i = 0; i < _shopsList.length; i++)
                      getTheMakerOption(_shopsList[i]),
                  ],*/
                onMapCreated: (controller) async {
                  _mapcontroller = controller;

                  await controller.requireAlwaysAuth();
                  await controller.setZoomLevel(16.0);
                  await controller.showMyLocation(MyLocationOption());
                },
              ),
              Container(
                height: 100,
                color: Colors.black26,
          /*      child: Visibility(
                    visible: _machine!=null,
                    child: Container(
                  width: 128,
                  height: 222,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:ListTile(
                    title: Text(_machine['name']),
                    subtitle: Text(_machine['address']),
                  ) ,
                )),*/
              ),
            ],
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: DecoratedColumn(
              scrollable: true,
              divider: kDividerTiny,
              children: <Widget>[
                for (int i = 0; i < _shopsList.length; i++)
                  ComWidget.machineitem(_shopsList[i]),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  List<Map<String, dynamic>> _shopsList = List();

  Location _mylocation;
  String _city;
  _getinitLocation() async {
    if (await Permission.location.request().isGranted) {
      _mylocation = await _amapLocation.fetchLocation();

      _city = await _mylocation.city;

      //将地图中心点移动到选择的点
      await _mapcontroller.setCenterCoordinate(_mylocation.latLng);

      await _mapcontroller.addMarker(MarkerOption(
        latLng: _mylocation.latLng,
      ));

      if (_mylocation != null && _mylocation.latLng != null) {
        Map<String, String> params = {
          "longitudeLatitude":
              "${_mylocation.latLng.longitude},${_mylocation.latLng.latitude}",
          "range": "5000"
        };

        _shopsList = await DataUtils.getNearByDevice(context, params);
        if (_shopsList != null && _shopsList.length > 0) {
          print("--3333----");
          final marker = await _mapcontroller?.addMarkers(
            [
              for (int i = 0; i < _shopsList.length; i++)
                getTheMakerOption(_shopsList[i]),
            ],
          );
          _markers.addAll(marker);

          await _mapcontroller?.setInfoWindowClickListener((marker) async {
            _machine= _shopsList[int.parse(await marker.object)];
            print(_machine);
            setState(() {

            });
            print('--setInfoWindowClickListener-----${await marker.title}, ${await marker.location}');
            return false;
          });
        }
      }
      setState(() {});
    }
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
      object: '${_shopsList.indexOf(it)}',//index
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
