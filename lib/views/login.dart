import 'dart:core'; //timer
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/globle_provider.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import '../utils/HttpUtils.dart';
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
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool _loginbywx = false;
  Map<String, dynamic> _wxuserInfo;
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
//    return WillPopScope(child:
    return Scaffold(
        appBar: AppBar(
          title: new Text("登录${_loading ? '中…' : ''}"),
          centerTitle: true,
        ),
        backgroundColor: Color(0xFFFFFFFF),
        body: SingleChildScrollView(
            child: Container(

          height: MediaQuery.of(context).size.height - 100,
          child:Form(
    //绑定状态属性
    key: _formKey,
    child:ListView(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                const SizedBox(height: 35.0),
                new Padding(
                    padding: new EdgeInsets.all(40),
                    child: Center(
                      child: Image.asset(
                        'images/logo.png',
                        width: 68,
                        height: 68,
                        fit: BoxFit.fill,
                      ),
                    )),
                Padding(
                  padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
                  child: ComFun.buideloginInput(
                      context, "手机号码", _phonecontroller,
                      textInputType: TextInputType.phone,
                      header:
                          Icon(Icons.person, color: KColorConstant.mainColor)
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 15.0),
                  child: ComFun.buideloginInput(
                    context,
                    "密码",
                    _pwdcontroller,
                    header: IconButton(
                      icon: new Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: KColorConstant.mainColor),
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    ),
                   /* suffix: Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FogetpwdPage(),
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "忘记密码",
                            style: new TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),*/
                    obscure: _obscure,
                  ),
                ),
                buidcommit(),

                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Center(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => register(),
                                ));
                          },
                          child: Text(
                            "注册",
                          )),
                    )),
                    Container(
                      width: 2,
                      color: KColorConstant.mainColor,
                    ),
                    Expanded(
                        child: Container(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FogetpwdPage(),
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "忘记密码",
                              style: new TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ),
                      ),
                    ))
                  ],
                )),
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Text(
                  "使用以下方式进行注册/登录",
                  style: TextStyle(fontSize: 16, color: Color(0xff9F9F9F)),
                )),
                Padding(
                  padding: const EdgeInsets.only(left:38.0,right: 38.0),
                  child: Divider(),
                ),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () async {
                            await fluwx.sendWeChatAuth(
                                scope: "snsapi_userinfo", state: "wechat_sdk_demo_test");
                          },
                          child:Image.asset(
                          'images/wechat.png',
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'images/QQ.png',
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                )
//                    Center(child: _buideRegtxt()),
              ]),
        )
            )));
  }

  bool _loading = false;
  // 显示加载进度条
  void showLoadingDialog() {
    setState(() {
      _loading = true;
    });
    DialogUtils.showLoadingDialog(context, text: "登录中");
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
    if (fluwx.isWeChatInstalled == false)
      setState(() {
        _loginbywx = false;
      });

    fluwx.weChatResponseEventHandler
        .distinct((a, b) => a == b)
        .listen((res) async {
      if (res is fluwx.WeChatAuthResponse) {
        if (res.errCode == 0) {
          print("-------微信---state :${res.state}  response.code:${res.code}");
          await _getUserWxInfo(res.code);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _phoneState = null;
    _pwdState = null;
    _phonecontroller = null;
    _pwdcontroller = null;
  }

/*
通过code传给服务器获取用户信息
 */
  Future _getUserWxInfo(String code) async {
    Map<String, String> params = {
      "code": code,
    };
    showLoadingDialog();
    await HttpUtils.get("WxAppAuth/userWxInfo", params)
        .then((response) async {
      if (response['data']['unionid'].isNotEmpty) {
        _wxuserInfo = response['data'];
        setState(() {});
        await _checkWxlogin();
      } else {
        _alertmag("微信认证失败!");
        hideLoadingDialog();
      }
    });
  }

  /**
   * 微信登录
   * 如果未认证则注册,注册成功后再返回登录信息
   * 如已认证则登录返回登录信息
   */
  Future _checkWxlogin() async {
    if (_wxuserInfo.isNotEmpty) {
      var pdata = {
        "unionid": "_unionId",
        "wxinfo": jsonEncode(_wxuserInfo),
      };

      var response =
          await HttpUtils.post("PublicContr/checkWx", pdata);
      if (response["code"] == 200) {
//        返回登录后的用户信息 response["userinfo"]
        if (await DataUtils().loginserv(context, response["userinfo"])) {
          hideLoadingDialog();
          Navigator.of(context).pop(true);
        } else
          _alertmag("登录失败");
      } else
        await _alertmag("微信登录失败:${response["message"]}");

      hideLoadingDialog();
    }
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
    if (await DataUtils().login(context, _phone, _pwd)) {
      hideLoadingDialog();
      Navigator.of(context).pop(true);
    } else {
      _alertmag("登录失败");
      hideLoadingDialog();
    }
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

  Widget buidcommit() {
    return Visibility(
        visible: _termsChecked,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: _loading ? null : _login,
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: new BoxDecoration(
                color: KColorConstant.mainColor,
                borderRadius: BorderRadius.all(Radius.circular(23.0)),
                border: Border.all(width: 1.0, color: KColorConstant.mainColor),
              ),
              child: Center(
                child: Text(
                  '登录',
                  style: new TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
          ),
        ));
  }

}
