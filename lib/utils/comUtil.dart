import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encry;
import 'package:date_format/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_coffee/constants/color.dart';
import '../components/keyboard/keyboard_main.dart';
import 'utils.dart';


class EncryptUtil {

  static const AESKEY =  "szwangpeicryptke"; // 秘钥 16*n:
  static const AESIV = "wangpeisignstrin"; // 偏移量

  //aes加密
  String aesEncode(String content) {
    try {
//      final key = encry.Key.fromUtf8('my 32 length key................');
//      final key = encry.Key.fromBase64(base64Encode(bytes));
//      final encrypter =encry.Encrypter(encry.AES(key, mode: encry.AESMode.cbc));
      final encrypter =encry.Encrypter(encry.AES(encry.Key.fromUtf8(AESKEY), mode: encry.AESMode.cbc));
      final encrypted = encrypter.encrypt(content, iv: encry.IV.fromUtf8(AESIV));
//      final encrypter =encry.Encrypter(encry.AES(key, mode: encry.AESMode.cbc));
//      final encrypted = encrypter.encrypt(content, iv: encry.IV.fromBase64(base64Encode(bytes)));
      return encrypted.base64;
    } catch (err) {
      print("aes encode error:$err");
      return content;
    }
  }

  //aes解密
  dynamic aesDecode(dynamic base64) {
    try {
      final key = encry.Key.fromUtf8(AESKEY);
      final encrypter = encry.Encrypter(encry.AES(key, mode: encry.AESMode.cbc));
      return encrypter.decrypt64(base64, iv: encry.IV.fromUtf8(AESKEY));
    } catch (err) {
      print("aes decode error:$err");
      return base64;
    }
  }
}


const String MIN_DATETIME = '2020-01-01 08:08:10';
const String MAX_DATETIME = '2029-12-01 20:08:00';
const String ENCSOUT = "wangpei";

class ComFun {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future get theToken async {
    SharedPreferences prefs = await _prefs;
    return  prefs.getString("token");

  }

  static String get timestamp =>
      DateTime.now().millisecondsSinceEpoch.toString();

  static String md5me(String parastr) {
    var content = new Utf8Encoder().convert(parastr);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static Map<String, String>  aesen(String head,Map<String, dynamic> params){
    Map<String, String> treeMap = Map();
    params.putIfAbsent("timestamp", ()=> timestamp );
//先排序，按字段加密，
    String enstr=head;
    sortaz(params).forEach((k,v){
      if(v.toString().isNotEmpty){
//        print(k+"=="+v.toString());  //类型不一样的时候就toString()
        enstr +="$k$v";
        treeMap[k]=EncryptUtil().aesEncode(v);
      }

    });

    enstr+=ENCSOUT;
    print(enstr);
    String signstr=EncryptUtil().aesEncode(md5me(enstr));
    treeMap.putIfAbsent("sign", ()=> signstr );
    print(treeMap);
    return treeMap;
  }

  // 获取安装地址
  Future<String> get apkLocalPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  static TargetPlatform get defaultTargetPlatform {
    TargetPlatform result;
    //这里根据平台来赋值，但是只有iOS、Android、Fuchsia，没有PC
    if (Platform.isIOS) {
      result = TargetPlatform.iOS;
    } else if (Platform.isAndroid) {
      result = TargetPlatform.android;
    } else if (Platform.isFuchsia) {
      result = TargetPlatform.fuchsia;
    }
    assert(() {
      if (Platform.environment.containsKey('FLUTTER_TEST'))
        result = TargetPlatform.android;
      return true;
    }());
    //这里判断debugDefaultTargetPlatformOverride有没有值，有值的话，就赋值给result
//    'package:flutter/foundation.dart';
    if (debugDefaultTargetPlatformOverride != null)
      result = debugDefaultTargetPlatformOverride;

    //如果到这一步，还没有取到 TargetPlatform 的值，就会抛异常
    if (result == null) {
      throw FlutterError('Unknown platform.\n'
          '${Platform.operatingSystem} was not recognized as a target platform. '
          'Consider updating the list of TargetPlatforms to include this platform.');
    }
    return result;
  }

  Future<bool> checkPermission() async {
    bool rtstats = true;
//    rtstats =await openAppSettings();
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.speech,
        Permission.microphone,
        Permission.camera,
        Permission.phone,
        Permission.photos,
        Permission.reminders,
        Permission.notification,
        Permission.activityRecognition,
        Permission.sms,
        Permission.contacts
      ].request();
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();
    }

    return rtstats;
  }


  Future<String>  getDeviceInfoName() async{
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isIOS){
//      print('IOS设备：');
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return "${iosInfo.name},${iosInfo.systemVersion}";
    }else if(Platform.isAndroid){
//      print('Android设备');
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "${androidInfo.brand},${androidInfo.model},${androidInfo.version.release}";
    }
    return "";
  }

  Future setdefaultunitindex(int uindex) async {
    SharedPreferences prefs = await _prefs;

    return prefs.setInt("${prefs.getString('token')}-unitindex", uindex);

  }


  static String getImgPath(String name, {String format: 'png'}) {
    return 'images/$name.$format';
  }

  static Color nameToColor(String name) {
    // assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  static bool isChinaId(String cardId) {
    if (cardId.length != 18) {
      return false; // 位数不够
    }
    // 身份证号码正则
    RegExp postalCode = new RegExp(
        r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
    // 通过验证，说明格式正确，但仍需计算准确性
    if (!postalCode.hasMatch(cardId)) {
      return false;
    }
    //将前17位加权因子保存在数组里
    final List idCardList = [
      "7",
      "9",
      "10",
      "5",
      "8",
      "4",
      "2",
      "1",
      "6",
      "3",
      "7",
      "9",
      "10",
      "5",
      "8",
      "4",
      "2"
    ];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    final List idCardYArray = [
      '1',
      '0',
      '10',
      '9',
      '8',
      '7',
      '6',
      '5',
      '4',
      '3',
      '2'
    ];
    // 前17位各自乖以加权因子后的总和
    int idCardWiSum = 0;

    for (int i = 0; i < 17; i++) {
      int subStrIndex = int.parse(cardId.substring(i, i + 1));
      int idCardWiIndex = int.parse(idCardList[i]);
      idCardWiSum += subStrIndex * idCardWiIndex;
    }
    // 计算出校验码所在数组的位置
    int idCardMod = idCardWiSum % 11;
    // 得到最后一位号码
    String idCardLast = cardId.substring(17, 18);
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod == 2) {
      if (idCardLast != 'x' && idCardLast != 'X') {
        return false;
      }
    } else {
      //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
      if (idCardLast != idCardYArray[idCardMod]) {
        return false;
      }
    }
    return true;
  }

  static bool isChinaPhoneLegal(String str) {
    return new RegExp(
        '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147)|(146)|(145))\\d{8}\$')
        .hasMatch(str);
  }

  static String getTimeDuration(String comTime) {
    var nowTime = DateTime.now();
    var compareTime = DateTime.parse(comTime);
    if (nowTime.isAfter(compareTime)) {
      if (nowTime.year == compareTime.year) {
        if (nowTime.month == compareTime.month) {
          if (nowTime.day == compareTime.day) {
            if (nowTime.hour == compareTime.hour) {
              if (nowTime.minute == compareTime.minute) {
                return '片刻之间';
              }
              return (nowTime.minute - compareTime.minute).toString() + '分钟前';
            }
            return (nowTime.hour - compareTime.hour).toString() + '小时前';
          }
          return (nowTime.day - compareTime.day).toString() + '天前';
        }
        return (nowTime.month - compareTime.month).toString() + '月前';
      }
      return (nowTime.year - compareTime.year).toString() + '年前';
    }
    return 'time error';
  }

  static double setPercentage(percentage, context) {
    return MediaQuery.of(context).size.width * percentage;
  }

  /// Display date picker.
  static void showXDatePicker(context, Function callback) {
    DateTime nowDay = DateTime.now();
//    String outformat='yyyy-MM-dd HH:mm:ss';
    String initTime =
    formatDate(nowDay, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn, ":00"]);

    bool showTitle = true;
    String format = 'yy年M月d日,H时:m分';

    DateTimePickerLocale locale = DateTimePickerLocale.zh_cn;
    DateTime dateTimei;
    dateTimei = DateTime.parse(initTime);

    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: DateTime.parse(initTime),
      dateFormat: format,
      locale: locale,
      pickerTheme: DateTimePickerTheme(
        showTitle: showTitle,
      ),
      pickerMode: DateTimePickerMode.datetime, // show TimePicker
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        dateTimei = dateTime;
        callback(dateTimei.toString());
      },
      onConfirm: (dateTime, List<int> index) {
        dateTimei = dateTime;
//        print(dateTime);
//        print(dateTimei.toIso8601String());
        callback(dateTimei.toIso8601String());
      },
    );
  }

  /// Display date picker.
  static void showXTimePicker(context, Function callback) async {
    await showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((TimeOfDay val) {
//      print("选择的时间是:${val.hour}时${val.minute}分");
      callback("${val.hour}:${val.minute}:00");
    }).catchError((error) {
      print("error:${error}");
    }); // initialTim
  }

  void xbxselector(context,String title, List<Map<String, String>> inithlist, Function callback) {
    /*List<Map<String, dynamic>> inithlist = [
      {'name': "1小时", "value": 1},
      {'name': "2小时", "value": 2},
      {'name': "6小时", "value": 6},
      {'name': "12小时", "value": 12},
      {'name': "1天", "value": 24},
      {'name': "2天", "value": 48},
      {'name': "3天", "value": 72},
      {'name': "1周", "value": 24 * 7},
      {'name': "半月", "value": 24 * 15},
      {'name': "1月", "value": 24 * 30},
    ];*/

    String retalue = "";
    showModalBottomSheet(
        context: context,
        builder: (
            BuildContext context,
            ) {
          return StatefulBuilder(builder: (context, mystate) {
            return Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(title),
                            IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: inithlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  inithlist[index]['name'],
                                  style: TextStyle(
                                      color: retalue == inithlist[index]['value']
                                          ? KColorConstant.themeColor
                                          : KColorConstant.txtFontColor),
                                ),
                              ),
                              onTap: () {
                                mystate(() {
                                  retalue = inithlist[index]['value'];
                                });
                              },
                            );
                          },
                        ),
                      ),
                      Divider(),
                      FlatButton(
                          onPressed: () {
                            callback(retalue);
                          },
                          child: Text("确定"))
                    ],
                  ),
                ));
          });
        });
  }

  static void getPassword(context, Function callback) {
    Widget bottomShowWidget = Material(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: SafeArea(
          bottom: false,
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0xFFFFFFFF),
              height: 400,
              child: MpsKeyboard(),
            ),
          )),
    );
    Navigator.of(context)
        .push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return bottomShowWidget;
        }))
        .then((v) {
      if (v != null) {
        callback(v);
      }
    });
  }

  void selectHours(context, Function callback) {
    List<Map<String, dynamic>> inithlist = [
      {'name': "1小时", "value": 1},
      {'name': "2小时", "value": 2},
      {'name': "6小时", "value": 6},
      {'name': "12小时", "value": 12},
      {'name': "1天", "value": 24},
      {'name': "2天", "value": 48},
      {'name': "3天", "value": 72},
      {'name': "1周", "value": 24 * 7},
      {'name': "半月", "value": 24 * 15},
      {'name': "1月", "value": 24 * 30},
    ];

    int _hours = 1;
    showModalBottomSheet(
        context: context,
        builder: (
            BuildContext context,
            ) {
          return StatefulBuilder(builder: (context, mystate) {
            return Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("有效期限"),
                            IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        height: 170,
                        child: ListView.builder(
                          itemCount: inithlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  inithlist[index]['name'],
                                  style: TextStyle(
                                      color: _hours == inithlist[index]['value']
                                          ? KColorConstant.themeColor
                                          : KColorConstant.txtFontColor),
                                ),
                              ),
                              onTap: () {
                                mystate(() {
                                  _hours = inithlist[index]['value'];
                                });
                              },
                            );

                          },
                        ),
                      ),
                      Divider(),
                      FlatButton(
                          onPressed: () {
                            callback(_hours);
                          },
                          child: Text("确定"))
                    ],
                  ),
                ));
          });
        });
  }

  void showSnackDialog<T>({BuildContext context, Widget child}) {
    final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        _scaffoldKey1.currentState.showSnackBar(
          SnackBar(
            content: Text('您选择了: $value'),
          ),
        );
      }
    });
  }

  static String getTimeDate(String comTime) {
    var compareTime = DateTime.parse(comTime);
    String weekDay = '';
    switch (compareTime.weekday) {
      case 2:
        weekDay = '周二';
        break;
      case 3:
        weekDay = '周三';
        break;
      case 4:
        weekDay = '周四';
        break;
      case 5:
        weekDay = '周五';
        break;
      case 6:
        weekDay = '周六';
        break;
      case 7:
        weekDay = '周日';
        break;
      default:
        weekDay = '周一';
    }
    return '${compareTime.month}-${compareTime.day}  $weekDay';
  }

  int _lastClickTime = 0;
  Future doubleExit(BuildContext context) async {
    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      await onWillPop(context).then((rv) {
        rv ? exitApp(context) : new Future.value(false);
      });
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      await onWillPop(context).then((rv) {
        rv ? exitApp(context) : new Future.value(false);
      });
    }
  }

  static Future<void> exitApp(BuildContext context) async {
    AndroidBackTop.backDeskTop(); //设置为返回不退出app
    return false; //一定要return false

    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  Future<bool> onWillPop(context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('退出提示'),
        content: new Text('确定将退出app吗？确定后系统将返回桌面。'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('取消',
                style: TextStyle(
                  color: Colors.black26,
                )),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text(
              '确定',
            ),
          ),
        ],
      ),
    ) ??
        false;
  }



  static Future<String> scanqr() async {
    String scmsg = "";
    try {
      var options = ScanOptions();
      ScanResult result = await BarcodeScanner.scan(options: options);
      scmsg = result.rawContent;
    } on PlatformException catch (e) {
      scmsg = "相机权限错误: $e";
    } on FormatException {
      scmsg = "二维码读取错误";
    } catch (e) {
      scmsg = e.toString();
    }
    print("扫描结果:$scmsg");
    return scmsg;
  }


  Widget buildMyButton(BuildContext context, String text, Function pressfun,
      {double width = 100,
        double height = 45,
        Color bgcolor = KColorConstant.themeColor,
        bool disabled = false,
        TextStyle textstyle = const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'FZLanTing',
            fontSize: 14,
            color: Colors.white)}) {
    return RaisedButton(
        color: bgcolor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular((height / 2) - 4.0)),
        ),
        child: Container(
            alignment: Alignment.center,
            width: width,
            height: height,
          /*  decoration: new BoxDecoration(
              color: bgcolor, //背景
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(height / 2 - 4)),
//                BorderRadius.all(Radius.circular(25.0)),
              //设置四周边框
              border: null, //new Border.all(width: 1, color: Colors.green),
            ),*/
            child: Text(
              text,
              style: textstyle,
              maxLines: 1,
            )),

        onPressed: disabled ? null : pressfun);
  }


 static Widget buideloginInput(BuildContext context, String Labtext,
      TextEditingController textControllor,
      { Widget header,
        Widget suffix,
        TextStyle textstyle,
        TextInputType textInputType,
        bool enable = true,
        bool obscure=false,
        Function changfun}) {

    Widget textInputRow = Container(
        alignment: Alignment.center,
        width:double.infinity ,
        height: 46,
        decoration: new BoxDecoration(
          color: KColorConstant.greyinputbackground,
          borderRadius: BorderRadius.all(Radius.circular(23.0)),
          border: Border.all(width: 1.0, color: KColorConstant.greyinputbackground),
        ),
        child: Padding(
                padding: new EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Padding(
                          padding:
                          new EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: header),
                      new Expanded(
                        child: new TextField(
                          controller: textControllor,
                          cursorColor: KColorConstant.mainColor,
                          keyboardType: textInputType??TextInputType.streetAddress,

                          obscureText: obscure,
                          decoration: InputDecoration(
                              hintText: '请输入$Labtext',
                              contentPadding: EdgeInsets.all(9.0),
                              border:InputBorder.none,
                               suffixIcon: suffix,
                          ),

                        ),
                      ),
                    ])),
         );

    return !enable
        ? IgnorePointer(
      child:  textInputRow,
    )
        :  textInputRow;
  }

}

class AndroidBackTop {
  //初始化通信管道-设置退出到手机桌面
  static const String CHANNEL = "android/back/desktop";
  //设置回退到手机桌面
  static Future<bool> backDeskTop() async {
    final platform = MethodChannel(CHANNEL);
    //通知安卓返回,到手机桌面
    try {
      final bool out = await platform.invokeMethod('backDesktop');
      if (out) debugPrint('返回到桌面');
    } on PlatformException catch (e) {
      debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)${e.toString()}");
//      print(e.toString());
    }
    return Future.value(false);
  }
}
