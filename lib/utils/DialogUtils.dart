import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'package:provider/provider.dart';
import '../model/globle_provider.dart';
import '../components/ToastDialog.dart';
import '../components/LoadingDialog.dart';

class DialogUtils extends Dialog {
  static Widget uircularProgress() {
    return CircularProgressIndicator(
      strokeWidth: 4.0,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
    );
  }

  // 显示加载对话框
  static showLoadingDialog(context, {String text = ''}) {
    showDialog<Null>(
        context: context, // BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
            // 调用对话框
            text: text.isEmpty ? '加载中...' : text,
          );
        });
  }

  // 关闭加载对话框
  static closeLoadingDialog(context) {
    Navigator.pop(context);
  }

  Future<bool> showMyDialog(context, String text) {
    return showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                    title: Text("温馨提示"),
                    content: Text(text),
                    actions: <Widget>[
                      TextButton(
                        child: Text("取消"),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text("确定"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      )
                    ])).then((value) => value ?? false);
  }

  Future<bool> showSelectImageType(context) {
    return showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                    title: Text("选择相片方式"),
                    content: SizedBox(
                      height: 10,
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text("相册"),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text("拍照"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      )
                    ])).then((value) => value ?? false);
  }

  Future showToast(context, text, {duration}) async {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ToastDialog(
            text: text ?? '操作成功',
          );
        });
    await Future.delayed(Duration(milliseconds: duration ?? 3000)); //等待秒
    Navigator.pop(context);
  }

  /// 显示文字对话框
  static showToastDialog(context, text, {duration}) async {
/*

    NavigatorState  navigatorState = Constants.navigatorKey.currentState;
    BuildContext  currentContext = navigatorState.context;
*/
    if (context != null) {
      showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ToastDialog(
              text: text ?? '操作成功',
            );
          });
      // 定时器关闭对话框
      await Future.delayed(Duration(milliseconds: duration ?? 1200)); //等待秒
      Navigator.pop(context);
    }
  }

  static close2Logout(context, {bool cancel = false}) async {
    final model =  Provider.of<GlobleProvider>(context);
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          '登录验证',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        ),
        content: Text('请重新登录！'),
        actions: <Widget>[
          TextButton(
            child: Text(cancel ? "取消" : ''),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
              onPressed: () async {
                print('正在退出……');
                Navigator.of(context).pop();
                await model.setlogout();
                Navigator.pushNamed(context, '/login');
              },
              child: Text('确定')),
        ],
      ),
    );
  }
}
