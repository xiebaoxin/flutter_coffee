import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_coffee/stubs/amap_stub.dart';
import 'dart:math';
import 'package:flutter_coffee/stubs/decorated_flutter_stub.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/dataUtils.dart';
import '../views/comm/comwidget.dart';

class ShowMapScreen extends StatefulWidget {
  @override
  DrawPointScreenState createState() => DrawPointScreenState();
}

final _assetsIcon1 = AssetImage('images/test_icon.png');
final _assetsIcon2 = AssetImage('images/arrow.png');

class DrawPointScreenState extends State<ShowMapScreen> {
  AmapController? _mapcontroller;
  final _amapLocation = AmapLocation.instance;
  List<Marker> _markers = [];
  Map<String, dynamic>? _machine;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DecoratedColumn(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Stack(
            children: <Widget>[
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
              Container(
                height: 100,
                color: Colors.black26,
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

  List<Map<String, dynamic>> _shopsList = [];

  Location? _mylocation;
  String? _city;
  _getinitLocation() async {
    if (await Permission.location.request().isGranted) {
      _mylocation = await _amapLocation.fetchLocation();

      _city = _mylocation?.city;

      await _mapcontroller?.setCenterCoordinate(_mylocation!.latLng);

      await _mapcontroller?.addMarker(MarkerOption(
        latLng: _mylocation?.latLng,
      ));

      if (_mylocation != null && _mylocation!.latLng != null) {
        Map<String, String> params = {
          "longitudeLatitude":
              "${_mylocation!.latLng.longitude},${_mylocation!.latLng.latitude}",
          "range": "5000"
        };

        _shopsList = await DataUtils.getNearByDevice(context, params);
        if (_shopsList.length > 0) {
          print("--3333----");
          final marker = await _mapcontroller?.addMarkers(
            [
              for (int i = 0; i < _shopsList.length; i++)
                getTheMakerOption(_shopsList[i]),
            ],
          );
          if (marker != null) _markers.addAll(marker);

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
      object: '${_shopsList.indexOf(it)}',
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
