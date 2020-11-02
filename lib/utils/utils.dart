import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import '../components/keyboard/keyboard_main.dart';
import 'dart:math' as math;
import '../globleConfig.dart';

String servpic(String imgname) {
  return imgname.isEmpty ? "" : imgname;//"${GlobalConfig.aliossfacedir}$imgname";
}


Map sortaz(Map<String, dynamic> map) {
  List<String> keys = map.keys.toList();
  // key排序
  keys.sort((a, b) {
    List<int> al = a.codeUnits;
    List<int> bl = b.codeUnits;
    for (int i = 0; i < al.length; i++) {
      if (bl.length <= i) return 1;
      if (al[i] > bl[i]) {
        return 1;
      } else if (al[i] < bl[i]) return -1;
    }
    return 0;
  });

  var treeMap = Map();
  keys.forEach((element) {
    treeMap[element] = map[element];
  });
  return treeMap;
}

void getPassword(context, Function callback) {
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

Color string2Color(String colorString) {
  int value = 0x00000000;

  if (isNotEmpty(colorString)) {
    if (colorString[0] == '#') {
      colorString = colorString.substring(1);
    }
    value = int.tryParse(colorString, radix: 16);
    if (value != null) {
      if (value < 0xFF000000) {
        value += 0xFF000000;
      }
    }
  }
  return Color(value);
}

Map url2query(String url) {
  var search = new RegExp('([^&=]+)=?([^&]*)');
  var result = new Map();

  // Get rid off the beginning ? in query strings.
  if (url.startsWith('?')) url = url.substring(1);

  // A custom decoder.
  decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

  // Go through all the matches and build the result map.
  for (Match match in search.allMatches(url)) {
    result[decode(match.group(1))] = decode(match.group(2));
  }

  return result;
}

Color randomColor() {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
      .withOpacity(1.0);
}

/**
 * 11位时间戳转为时间格式
 */
String readTimestamp(int timestamp) {
//  return formatDate(timestamp, [yyyy, '年', mm, '月', dd])
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
}
//时间转时间戳
int strtotimestamp(String datetime){
//  String datetime = "2020-8-15  16:00:00";//注意格式否则在DateTime.parse()时会报错
  var _strtimes = DateTime.parse(datetime );//首先先将字符串格式的时间转为DateTime类型，因为millisecondsSinceEpoch方法转换要求为该格式
  var _intendtime = _strtimes .millisecondsSinceEpoch;//方法一
//  var _intendtime =  DateTime.fromMillisecondsSinceEpoch(_strtimes );//方法二
  return _intendtime;
  //_intendtime 为以及转换好的时间戳
}


int timetonowdays(int timestamp) {
  var now = new DateTime.now();
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  return diff.inDays;
}

/**
 * 倒计时
 * difftimes 时间差秒
 */
void CountdowntimeFunc(int difftimes, Timer timerIndex, Function callBack) {
  var newDate = DateTime.now();
  const period = const Duration(seconds: 1);
//    print(time);
  var diffDate = DateTime.fromMillisecondsSinceEpoch(
      newDate.millisecondsSinceEpoch + difftimes * 1000);
  //DateTime.parse(time.toString());
  timerIndex = Timer.periodic(period, (timer) {
    //到时回调
    diffDate = diffDate.subtract(Duration(seconds: 1));
    // count++;
    if (diffDate.difference(newDate).inSeconds <= 0) {
      //取消定时器，避免无限回调
      timer.cancel();
      timer = null;
    }
    // print();
    var _surplus = diffDate.difference(newDate);
    int day = (_surplus.inSeconds ~/ 3600) ~/ 24;
    int hour = (_surplus.inSeconds ~/ 3600) % 24;
    int minute = _surplus.inSeconds % 3600 ~/ 60;
    int second = _surplus.inSeconds % 60;
    // formatTime(hour) + ":" + formatTime(minute) + ":" + formatTime(second);
    if (callBack != null) {
      callBack(day, hour, minute, second);
    }

    // debugPrint(_text);
  });
}

 int getTime([DateTime time]) {
if(time == null) {
return (DateTime.now().millisecondsSinceEpoch/1000).round();
} else {
return (time.millisecondsSinceEpoch/1000).round();
}
}
