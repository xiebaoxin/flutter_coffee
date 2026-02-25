import 'pay_password.dart';
import 'custom_keyboard_button.dart';
import 'package:flutter/material.dart';


/// 自定义密码 键盘

class MyKeyboard extends StatefulWidget {
  final callback;

  MyKeyboard(this.callback);

  @override
  State<StatefulWidget> createState() {
    return MyKeyboardStat();
  }
}

class MyKeyboardStat extends State<MyKeyboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var backMethod;
  void onCommitChange() {
    widget.callback(PayKeyEvent("commit"));
  }

  void onOneChange(BuildContext cont) {
    widget.callback(PayKeyEvent("1"));
  }

  void onTwoChange(BuildContext cont) {
    widget.callback(PayKeyEvent("2"));
  }

  void onThreeChange(BuildContext cont) {
    widget.callback(PayKeyEvent("3"));
  }

  void onFourChange(BuildContext cont) {
    widget.callback(PayKeyEvent("4"));
  }

  void onFiveChange(BuildContext cont) {
    widget.callback(PayKeyEvent("5"));
  }

  void onSixChange(BuildContext cont) {
    widget.callback(PayKeyEvent("6"));
  }

  void onSevenChange(BuildContext cont) {
    widget.callback(PayKeyEvent("7"));
  }

  void onEightChange(BuildContext cont) {
    widget.callback(PayKeyEvent("8"));
  }

  void onNineChange(BuildContext cont) {
    widget.callback(PayKeyEvent("9"));
  }

  void onZeroChange(BuildContext cont) {
    widget.callback(PayKeyEvent("0"));
  }

  void onDeleteChange() {
    widget.callback(PayKeyEvent("del"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _scaffoldKey,
      width: double.infinity,
      height: 250.0,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height:30.0,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              '下滑隐藏',
              style: TextStyle(fontSize: 12.0, color: Color(0xff999999)),
            ),
          ),

          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: '1', callback: (val) => onOneChange(context)),
                  CustomKbBtn(
                      text: '2', callback: (val) => onTwoChange(context)),
                  CustomKbBtn(
                      text: '3', callback: (val) => onThreeChange(context)),
                ],
              ),

              Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: '4', callback: (val) => onFourChange(context)),
                  CustomKbBtn(
                      text: '5', callback: (val) => onFiveChange(context)),
                  CustomKbBtn(
                      text: '6', callback: (val) => onSixChange(context)),
                ],
              ),

              Row(
                children: <Widget>[
                  CustomKbBtn(
                      text: '7', callback: (val) => onSevenChange(context)),
                  CustomKbBtn(
                      text: '8', callback: (val) => onEightChange(context)),
                  CustomKbBtn(
                      text: '9', callback: (val) => onNineChange(context)),
                ],
              ),

              Row(
                children: <Widget>[
                  CustomKbBtn(text: '删除', callback: (val) => onDeleteChange()),
                  CustomKbBtn(
                      text: '0', callback: (val) => onZeroChange(context)),
                  CustomKbBtn(text: '确定', callback: (val) => onCommitChange()),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
