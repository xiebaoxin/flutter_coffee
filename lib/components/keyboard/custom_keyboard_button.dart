import 'package:flutter/material.dart';


///  自定义 键盘 按钮

class CustomKbBtn extends StatefulWidget {
  final String text;

  CustomKbBtn({Key? key, required this.text, this.callback}) : super(key: key);
  final callback;

  @override
  State<StatefulWidget> createState() {
    return ButtonState();
  }
}

class ButtonState extends State<CustomKbBtn> {
  ///回调函数执行体
  var backMethod;

  void back() {
    widget.callback('$backMethod');
  }

  @override
  Widget build(BuildContext context) {

    MediaQueryData mediaQuery = MediaQuery.of(context);
    var _screenWidth = mediaQuery.size.width;

    return Container(
        height:50.0,
        width: _screenWidth / 3,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0)),
            side: BorderSide(color: Color(0x10333333)),
          ),
          child: Text(
            widget.text,
            style: TextStyle(color: Color(0xff333333), fontSize: 20.0),
          ),
          onPressed: back,
        ));
  }
}
