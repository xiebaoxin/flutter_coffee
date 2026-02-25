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
import 'package:flutter_coffee/stubs/jpush_stub.dart';
import 'package:flutter_coffee/stubs/fluwx_stub.dart' as fluwx;
import 'package:flutter_coffee/stubs/tobias_stub.dart' as tobias;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './routers/routes.dart';
import './routers/application.dart';
import './model/globle_provider.dart';
import 'homepage.dart';
import 'globleConfig.dart';
import 'wellcome.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
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

//   AppLifecycleState appLifecycleState;
  final JPush  jpush = JPush();
   String debugLable = 'Unknown';

  @override
  Widget build(BuildContext context) {
    _initNotice();
    initPlatformState();
    _initPayInstall();

    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;

    return MaterialApp(
        title: GlobalConfig.appName,
        navigatorKey: G.navigatorKey,
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
          primaryColor: KColorConstant.mainColor,
          primaryIconTheme:
          const IconThemeData(color: KColorConstant.themeColor),
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),

          iconTheme:
          IconThemeData(color: KColorConstant.mainColor), //用于Icon颜色

          buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              buttonColor: KColorConstant.mainColor,
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
        NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      debugLable = "flutter jpush getRegistrationID: $rid";

      print(debugLable);
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  Future _showNotification(String? title, String? content) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'developer-default',
        'developer-default',
        channelDescription: 'jpush developer-default channal',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title ?? '', content ?? '', platformChannelSpecifics,
        payload: 'complete'); }

  _initNotice() async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
    final DarwinInitializationSettings initializationSettingsMacOS =
    DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
  print("---$id--$title---$body---$payload--");
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    if (details.payload != null) {
      debugPrint('notification payload: ${details.payload}');
    }
  }

}
