// Stub for amap_map_fluttify, amap_location_fluttify, amap_core_fluttify
import 'package:flutter/material.dart';

class AmapCore {
  static Future<void> init(String key) async {}
}

class AmapService {
  static final AmapService instance = AmapService();
  Future<void> init({String? iosKey, String? androidKey}) async {}
}

class LatLng {
  final double latitude;
  final double longitude;
  LatLng(this.latitude, this.longitude);
}

enum MapType { Standard, Satellite, Night, Navi, Bus }

class MyLocationOption {
  final bool? show;
  MyLocationOption({this.show});
}

class MarkerOption {
  final LatLng? latLng;
  final String? title;
  final String? snippet;
  final Widget? widget;
  final bool? infoWindowEnabled;
  final String? object;
  MarkerOption({this.latLng, this.title, this.snippet, this.widget, this.infoWindowEnabled, this.object});
}

class AmapController {
  Future<void> setCenterCoordinate(LatLng? latLng, {double? zoomLevel, bool? animated}) async {}
  Future<void> setZoomLevel(double zoom) async {}
  Future<void> requireAlwaysAuth() async {}
  Future<void> showMyLocation(MyLocationOption option) async {}
  Future<Marker> addMarker(MarkerOption option) async => Marker();
  Future<List<Marker>> addMarkers(List<MarkerOption> options) async => [];
  Future<void> setInfoWindowClickListener(Future<bool> Function(Marker marker)? listener) async {}
}

class AmapView extends StatelessWidget {
  final double? zoomLevel;
  final bool? showZoomControl;
  final bool? showCompass;
  final bool? showScaleControl;
  final bool? zoomGesturesEnabled;
  final bool? scrollGesturesEnabled;
  final bool? rotateGestureEnabled;
  final bool? tiltGestureEnabled;
  final MapType? mapType;
  final LatLng? centerCoordinate;
  final void Function(AmapController)? onMapCreated;
  final void Function(MapMove)? onMapMoveEnd;
  final bool? maskDelay;

  const AmapView({
    super.key,
    this.zoomLevel,
    this.showZoomControl,
    this.showCompass,
    this.showScaleControl,
    this.zoomGesturesEnabled,
    this.scrollGesturesEnabled,
    this.rotateGestureEnabled,
    this.tiltGestureEnabled,
    this.mapType,
    this.centerCoordinate,
    this.onMapCreated,
    this.onMapMoveEnd,
    this.maskDelay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: const Center(child: Text('Map not available on web', style: TextStyle(color: Colors.grey))),
    );
  }
}

class MapMove {
  final LatLng? latLng;
  MapMove({this.latLng});
}

class Location {
  final LatLng latLng;
  final String? city;
  final String? address;
  final double? altitude;
  Location({LatLng? latLng, this.city, this.address, this.altitude})
      : latLng = latLng ?? LatLng(0, 0);
}

class AmapLocation {
  static final AmapLocation instance = AmapLocation();
  Future<Location> fetchLocation() async {
    return Location(latLng: LatLng(0, 0), city: '', address: '', altitude: 0);
  }
  void dispose() {}
}

class Marker {
  final LatLng? position;
  final String? title;
  final String? snippet;
  Future<String> get object async => '';
  Future<LatLng?> get location async => position;
  Marker({this.position, this.title, this.snippet});
}
