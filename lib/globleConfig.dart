export './constants/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:color_dart/color_dart.dart';
import 'components/loading.dart';

class GlobalConfig {
  static final String appName = '极网咖啡';
  static final String appCopId="7";
  static final  String gtoken="C20AD4D76FE97759AA27A0C99BFF6710";

  static final  String regdoc="http://www.wangpeiaiot.com/regText.html";
  static final  String sevdoc="http://www.wangpeiaiot.com/regText.html";

  static final  String base='http://wp-api.wangpeiaiot.com/v1/front/';
  static final  String facebase='http://wp-api.wangpeiaiot.com/v1/front/';

  //获取阿里云OsS上传图片服务器地址
  static final String aliossserver= "http://oss-cn-beijing.aliyuncs.com";
  static final String aliossimgbase= "http://wangpei-iot.oss-cn-beijing.aliyuncs.com";
  static final String aliossfacedir=aliossimgbase+"/image/";

  static final String wxAppId='wx7897159e41b39e12';

  static final String aMapAppId="bdd600f2668b2e07b4420b4f63077be8";
  static final String aMapIosAppId="26b329caee06b1c0a1f84cd54dac4c4f";

  static final Widget rightArrowIcon = Icon(Icons.chevron_right, color: Colors.black26);

  static final String shopBaseServer="http://cashier.wangpeiaiot.com:8088/";
  static final String shopAppId="PSSHOP";
  static final String shopAppsecret="POWIEU8823A0AS879SA27";

}

class G {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 初始化loading
  static final Loading loading = Loading();

  /// 手动延时
  static sleep({ int milliseconds = 1000 }) async => await Future.delayed(Duration(milliseconds: milliseconds));

  /// 获取当前的state
  static NavigatorState getCurrentState() => navigatorKey.currentState;

  /// 获取当前的context
  static BuildContext getCurrentContext() => navigatorKey.currentContext;

  /// 获取屏幕上下边距
  /// 用于兼容全面屏，刘海屏
  static EdgeInsets screenPadding() => MediaQuery.of(getCurrentContext()).padding;

  /// 获取屏幕宽度
  static double screenWidth() => MediaQuery.of(getCurrentContext()).size.width;

  /// 获取屏幕高度
  static double screenHeight() => MediaQuery.of(getCurrentContext()).size.height;

  /// 返回页面
  static void pop() => getCurrentState().pop();

  /// 底部border
  /// ```
  /// @param {Color} color
  /// @param {bool} show  是否显示底部border
  /// ```
  static Border borderBottom({Color color, bool show = true}){
    return Border(
        bottom: BorderSide(
            color: (color == null || !show)  ? (show ? rgba(242, 242, 242, 1) : Colors.transparent) : color,
            width: 1
        )
    );
  }

  static gotowin(Widget objwin ){
 /*   Navigator.push(navigatorKey.currentContext, CupertinoPageRoute(
        builder: (BuildContext context) {
          return objwin;
        }));*/
    Navigator.of(navigatorKey.currentContext).push(
        PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return objwin;
        },
        transitionsBuilder:
            (___, Animation<double> animation, ____, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: RotationTransition(
              turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        })
    );

  }

}