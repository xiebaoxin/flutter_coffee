export './constants/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class GlobalConfig {
  static final String appName = '极网咖啡';
  static final String appCopId="7";
  static final  String regdoc="http://www.wangpeiaiot.com/regText.html";
  static final  String sevdoc="http://www.wangpeiaiot.com/regText.html";


  static final  String base='http://192.168.1.208:9100/v1/';
  static final  String facebase='http://192.168.1.208:9100/v1/';

  //获取阿里云OsS上传图片服务器地址
  static final String aliossserver= "http://oss-cn-beijing.aliyuncs.com";
  static final String aliossimgbase= "http://wangpei-iot.oss-cn-beijing.aliyuncs.com";
  static final String aliossfacedir=aliossimgbase+"/image/";

  static final String wxAppId='wx10e64c57c456e417';
  static final String aMapAppId="bdd600f2668b2e07b4420b4f63077be8";
  static final String aMapIosAppId="26b329caee06b1c0a1f84cd54dac4c4f";
  static final Widget rightArrowIcon = Icon(Icons.chevron_right, color: Colors.black26);

}

class Constants {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

 /* NavigatorState get navigatorState => Constants.navigatorKey.currentState;
  BuildContext get currentContext => navigatorState.context;
  ThemeData get currentTheme => Theme.of(currentContext);*/


}