import 'package:flutter/material.dart';
import 'CustomJPasswordFieldWidget.dart';
import 'keyboard_widget.dart';
import 'pay_password.dart';

/// 支付密码  +  自定义键盘

class MpsKeyboard extends StatefulWidget {
  static final String sName = "enter";

  @override
  State<StatefulWidget> createState() {
    return KeyboardState();
  }
}


class KeyboardState extends State<MpsKeyboard> {
   String pwdData = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  VoidCallback? _showBottomSheetCallback;

  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showBottomSheet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext c) {
    return Container(
      width: double.maxFinite,
      height: 300.0,
      color: Color(0xffffffff),
      child: Column(
        children: <Widget>[
         Align(
              alignment: Alignment.centerRight,
              child:GestureDetector(
                onTap: (){Navigator.pop(context);},
                  child:Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:  Text(
                  '取消',
                  style: TextStyle(fontSize: 18.0, color: Color(0xff333333)),
                  )
              ) ,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              '请输入支付密码',
              style: TextStyle(fontSize: 18.0, color: Color(0xff333333)),
            ),
          ),

          ///密码框
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: _buildPwd(pwdData),
          ),
        ],
      ),
    );
  }

  /// 密码键盘 确认按钮 事件
  void onAffirmButton() {
Navigator.of(context).pop(pwdData);
Navigator.of(context).pop(pwdData);
  }

  void _onKeyDown(PayKeyEvent data){
    if (data.isDelete()) {
      if (pwdData.length > 0) {
        pwdData = pwdData.substring(0, pwdData.length - 1);
        setState(() {});
      }
    } else if (data.isCommit()) {
      if (pwdData.length != 6) {
        return;
      }
      onAffirmButton();
    } else {
      if (pwdData.length < 6) {
        pwdData += data.key;
      }
      setState(() {});
    }
  }
  /// 底部弹出 自定义键盘  下滑消失
  void _showBottomSheet() {
    setState(() {
      _showBottomSheetCallback = null;
    });
    _scaffoldKey.currentState
        ?.showBottomSheet<void>((BuildContext context) {
      return MyKeyboard(_onKeyDown);
    })
        .closed
        .whenComplete(() {
      if (mounted) {
        setState(() {
          _showBottomSheetCallback = _showBottomSheet;
        });
      }
    });
  }

  Widget _buildPwd(var pwd) {
    return GestureDetector(
      child: Container(
        width: 250.0,
        height:40.0,
        child: CustomJPasswordField(pwd),
      ),
      onTap: () {
        _showBottomSheetCallback?.call();
      },
    );
  }
}
