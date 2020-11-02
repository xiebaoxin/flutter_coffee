import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_coffee/model/carts_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:tobias/tobias.dart' as tobias;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './routers/routes.dart';
import './routers/application.dart';
import './model/globle_provider.dart';
import 'homepage.dart';
import 'globleConfig.dart';
import 'wellcome.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  /// 强制竖屏
  ///
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<GlobleProvider>(
        create: (context) => GlobleProvider(),
      ),
      ChangeNotifierProvider<CartsProvider>(
        create: (context) => CartsProvider(),
      ),
    ],
    child: InitApp(),
  ));


}

////flutter packages pub run flutter_launcher_icons:main  --一键生成logo

class InitApp extends StatelessWidget {

  AppLifecycleState appLifecycleState;
  JPush jpush = new JPush();
  String debugLable = 'Unknown';

  @override
  Widget build(BuildContext context) {
    _initNotice();
    initPlatformState();
    _initPayInstall();

    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return MaterialApp(
        title: GlobalConfig.appName,
        navigatorKey: Constants.navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator,
        initialRoute: "/",
        onGenerateTitle: (context) {
          return GlobalConfig.appName;
        },
      locale: Locale('zh', 'CH'),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],

        theme: ThemeData(
          brightness: Brightness.light,
          /*
     * primarySwatch是主题颜色的一个样本。通过这个样本可以在一些条件下生成一些其他的属性。
     * 例如，若没有指定primaryColor，并且当前主题不是深色主题，那么primaryColor就会默认为primarySwatch指定的颜色，
     * 还有一些相似的属性：accentColor、indicatorColor等也会受到primarySwatch的影响。
        accentColor - Color类型，前景色(按钮、文本、覆盖边缘效果等)
        */
          //用于导航栏、FloatingActionButton的背景色等
//            primarySwatch:Colors.blueGrey,
//            primaryColor  App主要部分的背景色（ToolBar,Tabbar等）
          primaryColor: KColorConstant.mainColor,
          primaryIconTheme:
          const IconThemeData(color: KColorConstant.themeColor),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: Colors.white),
            textTheme: TextTheme(
              title: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),

          iconTheme:
          IconThemeData(color: KColorConstant.mainColor), //用于Icon颜色

          buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              buttonColor: KColorConstant.mainColor,
//              highlightColor: Colors.greenAccent
          ),
        ),

//          WellCome() // SplashPage(),alipaytest(),//
    );
  }


  _initPayInstall() async {
    await fluwx.registerWxApi(
        appId: GlobalConfig.wxAppId,
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://aic.wangpeiaiot.com/"
//        enableMTA: false
    );
    var result = await fluwx.isWeChatInstalled;
    print("===weixin--is installed： $result");
    var resulta = await tobias.isAliPayInstalled();
    print("===tobias--alipay is installed： $resulta");
  }


  Future<void> initPlatformState() async {
    jpush.isNotificationEnabled().then((bool value) {
      print("通知授权打开: $value");
      if (!value) jpush.openSettingsForNotification();
    }).catchError((onError) {
      debugLable = "通知授权打开错误: ${onError.toString()}";
      jpush.openSettingsForNotification();
      print(debugLable);
    });

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
            print(
                "=====flutter -- jiguang--- onReceiveNotification======: $message");

            var msg = message['extras'];
            if (msg != null) {
              if (msg['cn.jpush.android.EXTRA'] != null) {
                var retnotifydata = msg['cn.jpush.android.EXTRA'];
                print("--极光推送--【${retnotifydata['type']}】");
                _showNotification(msg['alert'], msg['title']);
              }
            }
          }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter-- jiguang--- onOpenNotification: $message");
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("=====2====flutter onReceiveMessage: $message");

      }, onReceiveNotificationAuthorization:
          (Map<String, dynamic> message) async {
        debugLable =
        "flutter -- jiguang--- onReceiveNotificationAuthorization: $message";

        print(debugLable);
      });
    } on PlatformException {
      print('Failed to get jpush platform version.');
    }

    jpush.setup(
      appKey: "2249b5a99e12efe664c9b083", //你自己应用的 AppKey
      channel: "theChannel",
      production: false,
      debug: true,
    );

    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      debugLable = "flutter jpush getRegistrationID: $rid";

      print(debugLable);
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  Future _showNotification(String title, String content) async {
    //安卓的通知配置，必填参数是渠道id, 名称, 和描述, 可选填通知的图标，重要度等等。
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'developer-default',
        'developer-default',
        'jpush developer-default channal',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, content, platformChannelSpecifics,
        payload: 'complete'); }

  _initNotice() async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  print("---$id--$title---$body---$payload--");
    /*  await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              Application.goto(context, "/home");
            },
          )
        ],
      ),
    );*/
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
//    Application.goto(context, "/home");
  }

}

