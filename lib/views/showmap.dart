import 'package:flutter/material.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart'; //高德地图amap_base_location
import 'package:amap_map_fluttify/amap_map_fluttify.dart'; //高德地图amap_base_map
import 'dart:math';
import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:permission_handler/permission_handler.dart';//权限
/**
 * ShowMapScreen
 * 地图缩放
 * 标注
 */
class ShowMapScreen extends StatefulWidget {
  @override
//  _ShowMapScreenState createState() => _ShowMapScreenState();
  DrawPointScreenState createState() => DrawPointScreenState();
}

final _networkIcon = NetworkImage(
    'https://w3.hoopchina.com.cn/30/a7/6a/30a76aea75aef69e4ea0e7d3dee552c7001.jpg');
final _assetsIcon1 = AssetImage('images/test_icon.png');
final _assetsIcon2 = AssetImage('images/arrow.png');

class _ShowMapScreenState extends State<ShowMapScreen> {
  AmapController _mapcontroller;
  final _amapLocation =AmapLocation.instance;//定位
  double lat ;
  double lng ;
  List<LatLng> markers = [
    LatLng(30.308802, 120.071179),
    LatLng(30.2412, 120.00938),
    LatLng(30.296945, 120.35133),
    LatLng(30.328955, 120.365063),
    LatLng(30.181862, 120.369183),
  ];

  @override
  void initState() {
//    _getLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('绘制点标记'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          return AmapView(

          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {

           await _getLocation();
            //_clearLocation();
           final nextLatLng = _nextLatLng();
          await _mapcontroller.addMarker(MarkerOption(
            latLng: nextLatLng,
          ));
//          await _mapcontroller.changeLatLng(nextLatLng);

        },
      ),
    );
  }

  @override
  void dispose() {
    _mapcontroller.dispose();
    super.dispose();
  }
//随机生成经纬度
  LatLng _nextLatLng() {
    final _random = Random();
    double nextLat = (301818 + _random.nextInt(303289 - 301818)) / 10000;
    double nextLng = (1200093 + _random.nextInt(1203691 - 1200093)) / 10000;
    return LatLng(nextLat, nextLng);
  }
  //清空标记
  _clearLocation(){
    _mapcontroller.clear();
//    _mapcontroller.clearMarkers(markers);
  }
  //定位标记
  _getLocation()async {
    if (await Permission.location
        .request()
        .isGranted) {
      Location location = await _amapLocation.fetchLocation();
/*
      await for (final location in _amapLocation.listenLocation()) {
        print("--${location.address},[${location.latLng.latitude},${location.latLng
            .longitude}],${location.altitude}--");
      }*/

     await _mapcontroller.showMyLocation(MyLocationOption());
    }

  }



  //判空
  bool isNotEmpty(var text){
    if(text==null||text.toString().isEmpty||text.toString()=='null'||text.toString()==null){
      return false;
    }else{
      return true;
    }
  }

}


class DrawPointScreenState extends State<ShowMapScreen>  {
  AmapController _mapcontroller;
  final _amapLocation =AmapLocation.instance;//定位
  
  List<Marker> _markers = [];
  Marker _hiddenMarker;
  SmoothMoveMarker _moveMarker;
  MultiPointOverlay _multiPointOverlay;

  @override
  Widget build(BuildContext context) {
    _getLocation();
    return Scaffold(
      appBar: AppBar(title: const Text('绘制点标记')),
      body: DecoratedColumn(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Stack(
              children: <Widget>[
                AmapView(
                  zoomLevel: 6,
                  markers: [
                    MarkerOption(
                      latLng:_mylocation!=null? _mylocation.latLng : getNextLatLng(),
//                  iconUri: _assetsIcon1,
//                  imageConfig: createLocalImageConfiguration(context),
                    ),
                  ],
                  onMapCreated: (controller) async {
                    _mapcontroller = controller;
                      await controller.setZoomLevel(6);
                  },
                ),
                Container(
                  height: 100,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          Flexible(
            child: DecoratedColumn(
              scrollable: true,
              divider: kDividerTiny,
              children: <Widget>[
                ListTile(
                  title: Center(child: Text('添加Widget Marker')),
                  onTap: () async {
                    final marker = await _mapcontroller?.addMarkers(
                      [
                        for (int i = 0; i < 50; i++)
                          MarkerOption(
                            latLng: getNextLatLng(),
                            widget: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('使用Widget作为Marker: $i'),
                                Image.asset('images/test_icon.png'),
                              ],
                            ),
                            title: '北京$i',
                            snippet: '描述$i',
                          )
                      ],
                    );
                    _markers.addAll(marker);
                  },
                ),
                ListTile(
                  title: Center(child: Text('添加Marker')),
                  onTap: () async {
                    final marker = await _mapcontroller?.addMarker(
                      MarkerOption(
                        latLng: getNextLatLng(),
                        title: '北京${Random().nextDouble()}',
                        snippet: '描述${Random().nextDouble()}',
                        iconProvider: _assetsIcon1,
                        infoWindowEnabled: true,
                        object: '自定义数据${Random().nextDouble()}',
                      ),
                    );
                    await _mapcontroller?.setMarkerClickedListener((marker) async {
                      /*await _mapcontroller.showCustomInfoWindow(
                        marker,
                        Container(
                          width: 128,
                          height: 222,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(await marker.title),
                        ),
                      );*/
                    });
                    _markers.add(marker);
                  },
                ),
                ListTile(
                  title: Center(child: Text('移动Marker坐标')),
                  onTap: () async {
                    await _markers?.first?.setCoordinate(getNextLatLng());
                  },
                ),
                ListTile(
                  title: Center(child: Text('添加一个不显示的marker')),
                  onTap: () async {
                    await _hiddenMarker?.remove();
                    _hiddenMarker = await _mapcontroller?.addMarker(
                      MarkerOption(
                        latLng: getNextLatLng(),
                        title: '北京',
                        snippet: '描述',
                        iconProvider: _assetsIcon1,
                        visible: false,
                      ),
                    );
                  },
                ),
              /*  BooleanSetting(
                  head: '是否显示隐藏的Marker',
                  selected: false,
                  onSelected: (visible) async {
                    await _hiddenMarker?.setVisible(visible);
                  },
                ),*/
                ListTile(
                  title: Center(child: Text('调用方法开启弹窗')),
                  onTap: () async {
                    if (_markers.isNotEmpty) {
                      final marker = _markers[0];
                      marker.showInfoWindow();
                    }
                  },
                ),
                ListTile(
                  title: Center(child: Text('调用方法关闭弹窗')),
                  onTap: () async {
                    if (_markers.isNotEmpty) {
                      final marker = _markers[0];
                      marker.hideInfoWindow();
                    }
                  },
                ),
              /*  ContinuousSetting(
                  head: '添加旋转角度的Marker',
                  onChanged: (value) async {
                    await _mapcontroller?.clearMarkers(_markers);
                    final marker = await _mapcontroller?.addMarker(
                      MarkerOption(
                        latLng: LatLng(39.90960, 116.397228),
                        title: '北京',
                        snippet: '描述',
                        iconProvider: _assetsIcon1,
                        draggable: true,
                        rotateAngle: 360 * value,
                        anchorU: 0,
                        anchorV: 0,
                      ),
                    );
                    _markers.add(marker);
                  },
                ),*/
                ListTile(
                  title: Center(child: Text('批量添加Marker')),
                  onTap: () {
                    _mapcontroller?.addMarkers(
                      [
                        for (int i = 0; i < 100; i++)
                          MarkerOption(
                            latLng: getNextLatLng(),
//                            title: '北京$i',
//                            snippet: '描述$i',
                            iconProvider:
                            i % 2 == 0 ? _assetsIcon1 : _assetsIcon2,
                            infoWindowEnabled: false,
//                            rotateAngle: 90,
                            object: 'Marker_$i',
                          ),
                      ],
                    )?.then(_markers.addAll);
                  },
                ),
                ListTile(
                  title: Center(child: Text('删除Marker')),
                  onTap: () async {
                    if (_markers.isNotEmpty) {
                      await _markers[0].remove();
                      _markers.removeAt(0);
                    }
                  },
                ),
                ListTile(
                  title: Center(child: Text('清除所有Marker')),
                  onTap: () async {
                    await _mapcontroller.clearMarkers(_markers);
                  },
                ),
                ListTile(
                  title: Center(child: Text('Marker添加点击事件')),
                  onTap: () {
                    _mapcontroller?.setMarkerClickedListener((marker) async {
                      marker.setIcon(
                        _assetsIcon2,
                        createLocalImageConfiguration(context),
                      );
                      return true;
                    });
                  },
                ),
                ListTile(
                  title: Center(child: Text('Marker添加拖动事件')),
                  onTap: () {
                    _mapcontroller?.setMarkerDragListener(
                      onMarkerDragEnd: (marker) async {
                        toast(
                          '${await marker.title}, ${await marker.location}',
                        );
                      },
                    );
                  },
                ),
       /*         ListTile(
                  title: Center(child: Text('将地图缩放至可以显示所有Marker')),
                  onTap: () async {
                    Stream.fromIterable(_markers)
                        .asyncMap((marker) => marker.location)
                        .toList()
                        .then((boundary) {
                      debugPrint('boundary: $boundary');
                      return _mapcontroller?.zoomToSpan(
                        boundary,
                        padding: EdgeInsets.only(
                          top: 100,
                        ),
                      );
                    });
                  },
                ),*/
                ListTile(
                  title: Center(child: Text('监听Marker弹窗事件')),
                  onTap: () async {
                    await _mapcontroller
                        ?.setInfoWindowClickListener((marker) async {
                      toast('${await marker.title}, ${await marker.location}');
                      return false;
                    });
                  },
                ),
              /*  ListTile(
                  title: Center(child: Text('画热力图')),
                  onTap: () async {
                    await _mapcontroller?.addHeatmapTileOverlay(
                      HeatmapTileOption(latLngList: getNextBatchLatLng(50)),
                    );
                  },
                ),*/
    /*     ListTile(
                  title: Center(child: Text('添加平滑移动点')),
                  onTap: () async {
                    _moveMarker = await _mapcontroller?.addSmoothMoveMarker(
                      SmoothMoveMarkerOption(
                        path: [for (int i = 0; i < 10; i++) getNextLatLng()],
                        iconProvider: _assetsIcon1,
                        duration: Duration(seconds: 10),
                      ),
                    );
                    Future.delayed(
                      Duration(seconds: 5),
                          () => _moveMarker.stop(),
                    );
                  },
                ),
              ListTile(
                  title: Center(child: Text('进入二级地图页面')),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DrawPointScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Center(child: Text('添加海量点')),
                  onTap: () async {
                    _multiPointOverlay =
                    await _mapcontroller?.addMultiPointOverlay(
                      MultiPointOption(
                        pointList: [
                          for (int i = 0; i < 10000; i++)
                            PointOption(
                              latLng: getNextLatLng(),
                              id: i.toString(),
                              title: 'Point$i',
                              snippet: 'Snippet$i',
                              object: 'Object$i',
                            )
                        ],
                        iconProvider: _assetsIcon1,
                      ),
                    );
                    await _mapcontroller?.setMultiPointClickedListener(
                          (id, title, snippet, object) async {
                        toast(
                          'id: $id, title: $title, snippet: $snippet, object: $object',
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: Center(child: Text('删除海量点')),
                  onTap: () async {
                    await _multiPointOverlay?.remove();
                  },
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
  Location _mylocation;
  _getLocation()async {
    if (await Permission.location
        .request()
        .isGranted) {

      _mylocation = await _amapLocation.fetchLocation();

      setState(() {

      });
/*
      await for (final location in _amapLocation.listenLocation()) {
        print("--${location.address},[${location.latLng.latitude},${location.latLng
            .longitude}],${location.altitude}--");
      }*/
      await _mapcontroller.showMyLocation(MyLocationOption());
    
    }

  }
  
  //随机生成经纬度
  LatLng getNextLatLng() {
    final _random = Random();
    double nextLat = (301818 + _random.nextInt(303289 - 301818)) / 10000;
    double nextLng = (1200093 + _random.nextInt(1203691 - 1200093)) / 10000;
    return LatLng(nextLat, nextLng);
  }

}