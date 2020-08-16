import 'dart:core'; //timer
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/globle_provider.dart';
//import 'package:fluwx/fluwx.dart' as fluwx;
//import '../utils/dataUtils.dart';
import '../globleConfig.dart';
import '../utils/DialogUtils.dart';
import '../utils/dataUtils.dart';
import '../utils/comUtil.dart';
import '../routers/application.dart';
import 'fogetpwd.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _phoneState, _pwdState = false;
  String _checkStr = '';
  TextEditingController _phonecontroller = new TextEditingController();
  TextEditingController _pwdcontroller = new TextEditingController();

  final FocusNode _focusNode = FocusNode();

  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
//    return WillPopScope(child:
    return Scaffold(
        appBar: AppBar(
          title: new Text("登录${_loading ? '中…' : ''}"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
          color: Color(0xFFFFFFFF),
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                const SizedBox(height: 35.0),
                new Padding(
                    padding: new EdgeInsets.only(top: 60, bottom: 10.0),
                    child: Image.asset(
                      'images/logo.png',
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                    )),

                    Center(child: mobilelogindiv()),
                    Center(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => register(),
                                  ));
                            },
                            child: Text(
                              "新用户注册",
                            ))),

                    Center(child: _buideRegtxt()),

              ]),
        )));
  }

  bool _loading = false;
  // 显示加载进度条
  void showLoadingDialog() {
    setState(() {
      _loading = true;
    });
    DialogUtils.showLoadingDialog(context,text:"登录中");
  }

  // 隐藏加载进度条
  hideLoadingDialog() {
    if (_loading) {
      Navigator.of(context).pop();
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneState = null;
    _pwdState = null;
    _phonecontroller = null;
    _pwdcontroller = null;
  }

  void _login() async {
    _checkPhone();
    _checkPwd();
    if (_phoneState && _pwdState) {
      _checkStr = '';
    } else {
      if (!_phoneState) {
        _checkStr = '请输入11位手机号！';
      } else if (!_pwdState) {
        _checkStr = '请输入6-10位密码！';
      }
    }

    if (_checkStr.isNotEmpty) {
      _alertmag(_checkStr);
      return;
    }

    var _phone = _phonecontroller.text;
    var _pwd = _pwdcontroller.text;

    showLoadingDialog();
   if(await DataUtils().login(context, _phone, _pwd)){
     hideLoadingDialog();
     Navigator.of(context).pop(true);
   }else
     _alertmag("登录失败");
    hideLoadingDialog();

  }

  void _checkPhone() {
    if (_phonecontroller.text != null &&
        _phonecontroller.text.length == 11 &&
        ComFun.isChinaPhoneLegal(_phonecontroller.text)) {
      _phoneState = true;
    } else {
      _phoneState = false;
    }
  }

  void _checkPwd() {
    if (_pwdcontroller.text != null &&
        _pwdcontroller.text.length >= 6 &&
        _pwdcontroller.text.length <= 10) {
      _pwdState = true;
    } else {
      _pwdState = false;
    }
  }

  void _alertmag(String msg) async {
    await DialogUtils.showToastDialog(context, msg);
  }

  bool _termsChecked = true;
  Widget _buideRegtxt() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
//      width: 300,
        child: Center(
          child: CheckboxListTile(
            activeColor: KColorConstant.themeColor,
            title: Row(
              children: <Widget>[
                Text(
                  '同意${GlobalConfig.appName}',
                  style: TextStyle(fontSize: 12),
                ),
                GestureDetector(
                  onTap: () {
                    Application.goto(context, "/web",
                        url: '${GlobalConfig.sevdoc}',
                        title: '用户协议',
                        withToken: false);
                  },
                  child: new Text(
                    '《注册协议》',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: GestureDetector(
                    onTap: () {
                      Application.goto(context, "/web",
                          url: '${GlobalConfig.regdoc}',
                          title: '隐私政策',
                          withToken: false);
                    },
                    child: new Text(
                      '《隐私政策》',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                )
              ],
            ),
            controlAffinity: ListTileControlAffinity.leading,
            value: _termsChecked,
            onChanged: (bool value) => setState(() => _termsChecked = value),
          ),
        ),
      ),
    );
  }

  Widget mobilelogindiv() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
            child: new Stack(
              alignment: new Alignment(1.0, 1.0),
              //statck
              children: <Widget>[
                new Padding(
                    padding: new EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new Padding(
                              padding:
                                  new EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                              child: Icon(Icons.person,
                                  color: KColorConstant.mainColor)),
                          new Expanded(
                            child: new TextField(
                              controller: _phonecontroller,
                              cursorColor: KColorConstant.mainColor,
                              keyboardType: TextInputType.phone,
                              //光标切换到指定的输入框
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_focusNode),
                              decoration: new InputDecoration(
                                hintText: '请输入手机号码',
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                            ),
                          ),
                        ])),
              ],
            ),
          ),
          Padding(
            padding: new EdgeInsets.fromLTRB(20.0, 5.0, 40.0, 10.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Padding(
                      padding: new EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: IconButton(
                        icon: new Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                            color: KColorConstant.mainColor),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      )),
                  new Expanded(
                    child: TextField(
                      controller: _pwdcontroller,
                      // 光标颜色
                      cursorColor: KColorConstant.mainColor,
                      focusNode: _focusNode,
                      decoration: new InputDecoration(
                        hintText: '请输入密码',
                        contentPadding: EdgeInsets.all(10.0),
                        suffixIcon: Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FogetpwdPage(),
                                  ));
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "忘记密码",
                                style: new TextStyle(fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      obscureText: _obscure,
                    ),
                  ),
                ]),
          ),
          SizedBox(
            height: 16,
          ),
          Visibility(
              visible: _termsChecked,
              child: GestureDetector(
                onTap: _loading ? null : _login,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 40,
                  decoration: new BoxDecoration(
                    color: KColorConstant.themeColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(
                        width: 1.0, color: KColorConstant.themeColor),
                  ),
                  child: Center(
                    child: Text(
                      '登录',
                      style: new TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
              )),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
