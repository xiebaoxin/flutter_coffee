import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'DialogUtils.dart';
import '../globleConfig.dart';

class MapUtil {

  /// 高德地图
  static Future<bool> gotoAMap(longitude, latitude) async {
    var url = '${(!kIsWeb && Platform.isAndroid) ? 'android' : 'ios'}amap://navi?sourceApplication=amap&lat=$latitude&lon=$longitude&dev=0&style=2';

    bool canLaunch = await canLaunchUrl(Uri.parse(url));

    if (!canLaunch) {
      DialogUtils.showToastDialog(G.navigatorKey.currentContext, '未检测到高德地图~');
      return false;
    }

    await launchUrl(Uri.parse(url));

    return true;
  }

  /// 腾讯地图
  static Future<bool> gotoTencentMap(longitude, latitude) async {
    var url = 'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$latitude,$longitude&referer=IXHBZ-QIZE4-ZQ6UP-DJYEO-HC2K2-EZBXJ';
    bool canLaunch = await canLaunchUrl(Uri.parse(url));

    if (!canLaunch) {
      DialogUtils.showToastDialog(G.navigatorKey.currentContext, '未检测到腾讯地图~');
      return false;
    }

    await launchUrl(Uri.parse(url));

    return canLaunch;
  }

  /// 百度地图
  static Future<bool> gotoBaiduMap(longitude, latitude) async {
    var url = 'baidumap://map/direction?destination=$latitude,$longitude&coord_type=bd09ll&mode=driving';

    bool canLaunch = await canLaunchUrl(Uri.parse(url));

    if (!canLaunch) {
      DialogUtils.showToastDialog(G.navigatorKey.currentContext, '未检测到百度地图~');
      return false;
    }

    await launchUrl(Uri.parse(url));

    return canLaunch;
  }

  /// 苹果地图
  static Future<bool> gotoAppleMap(longitude, latitude) async {
    var url = 'http://maps.apple.com/?&daddr=$latitude,$longitude';

    bool canLaunch = await canLaunchUrl(Uri.parse(url));

    if (!canLaunch) {
      DialogUtils.showToastDialog(G.navigatorKey.currentContext, '打开失败~');
      return false;
    }

    await launchUrl(Uri.parse(url));
    return true;
  }
}
