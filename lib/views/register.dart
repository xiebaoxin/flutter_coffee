import 'dart:async'; //timer
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/dataUtils.dart';
import '../utils/DialogUtils.dart';
import '../utils/comUtil.dart';
import '../routers/application.dart';
import '../globleConfig.dart';

class register extends StatefulWidget {
  @override
  registerState createState() => new registerState();
}

class registerState extends State<register> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _userNameCtrl = TextEditingController();
//  TextEditingController _userRealNameCtrl = TextEditingController();

  TextEditingController _phoneNoCtrl = TextEditingController();
  TextEditingController _PasswordCtrl = TextEditingController();
  TextEditingController _pyPasswordCtrl = TextEditingController();
  TextEditingController _varCodeCtrl = TextEditingController();

  String _phoneNo,_uName,_userName;
  String _password = '';
  String _inviteCode;
  bool _termsChecked = true;

  bool _obscureText = true;
  bool _pobscureText = true;

  int _seconds = 0;
  String _verifyStr = '获取验证码';
  String _verifyCode;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('注册'),
      ),
      body: new Center(
        child: Container(
            margin: EdgeInsets.all(20.0),
            color: Colors.white,
            child: Form(
              //绑定状态属性
              key: _formKey,
//              autovalidate: true,
              child: Padding(
                padding: new EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                child: ListView(
                  children: [
//                    _buildUsernameText(),
//                    _buildUserRealnameText(),
                    _buildPhoneText(),
                    _buildVerifyCodeEdit(),
                    _buidPassword(),
                    _buidRePassword(),
//                    _buidPayPassword(),
//                    _buildFromCodeText(),
                    SizedBox(
                      height: 15,
                    ),
                    _buideRegtxt(),

                    GestureDetector(
                      onTap:  _forSubmitted,
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: new BoxDecoration(
                          color: KColorConstant.themeColor,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(
                              width: 1.0, color: KColorConstant.themeColor),
                        ),
                        child: Center(
                          child: Text(
                            '注册',
                            style: new TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                    )
                  ],

                ),
              ),
            )),
      ),
    );
  }

  void _getsmsCode() async {
    setState(() {
      _seconds = 1;
      _verifyStr = '正在请求…';
    });
    _phoneNo = _phoneNoCtrl.text;
    if (_phoneNo == null ||
        _phoneNo == '' ||
        !ComFun.isChinaPhoneLegal(_phoneNo)) {
      DialogUtils.showToastDialog(context, '手机号不合法');
      return;
    }
if(await DataUtils().captcha(context, _phoneNo))
  {
        _seconds=60;
        setState(() {
          _verifyStr = '${_seconds.toString()}(s)重新发送';
        });

        _startTimer();
      }else{
        setState(() {
          _seconds=0;
        });
      }
  }

  _startTimer() {
    _seconds = 120;
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }
      setState(() {
        _seconds--;
        _verifyStr = "$_seconds(s)";
        if (_seconds == 0) {
          _verifyStr = '重新发送';
        }
      });
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void _forSubmitted() async {
    final form = _formKey.currentState;
    if(!_termsChecked){
      DialogUtils.showToastDialog(context, '同意协议才能注册');
      return;
    }

    _phoneNo = _phoneNoCtrl.text;
    if (_phoneNo.isEmpty ||
        !ComFun.isChinaPhoneLegal(_phoneNo)) {
      DialogUtils.showToastDialog(context, '手机号不合法');
      return;
    }
    _password = _PasswordCtrl.text.trim();
    if (_password.isEmpty ) {
      DialogUtils.showToastDialog(context, '密码必须填写');
      return;
    }
    /*   _uName=_userNameCtrl.text;
    if (_uName.isEmpty ) {
      DialogUtils.showToastDialog(context, '用户名必须填写');
      return;
    }
   _userName=_userRealNameCtrl.text;
    if (_userName.isEmpty ) {
      DialogUtils.showToastDialog(context, '真实姓名必须填写');
      return;
    }*/
    _verifyCode=_varCodeCtrl.text;
    if (_verifyCode.isEmpty ) {
      DialogUtils.showToastDialog(context, '验证码必须填写');
      return;
    }
    if (form.validate()) {
      form.save();

   if(await DataUtils().register(context, _phoneNo, _password,_verifyCode))
          Navigator.of(context).pop();
//          Navigator.of(context).pushReplacementNamed("/login");
//           Application.goto(context, "/login");
//        关闭当前页面并返回添加成功通知

    }
  }

  Widget _buideRegtxt() {
    return CheckboxListTile(
        activeColor: KColorConstant.themeColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '注册表示同意',
                  style: TextStyle(fontSize: 12),
                ),
                GestureDetector(
                  onTap: () {
                    Application.goto(context, "/web",
                        url: '${GlobalConfig.sevdoc}',
                        title: '注册协议',
                        withToken: false);
                  },
                  child: new Text(
                    '注册协议',
                    style: TextStyle(
                        fontSize: 12, color: KColorConstant.mainColor),
                  ),
                )
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: GestureDetector(
                  onTap: () {
                    Application.goto(context, "/web",
                        url: '${GlobalConfig.regdoc}',
                        title: '隐私政策',
                        withToken: false);
                  },
                  child: new Text(
                    '隐私政策',
                    style: TextStyle(
                        fontSize: 12, color: KColorConstant.mainColor),
                  ),
                ),
              ),
            )
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: _termsChecked,
        onChanged: (bool value) => setState(() => _termsChecked = value));
  }

  Widget _buidPayPassword() {
    return TextFormField(
      controller: _pyPasswordCtrl,
      obscureText: _pobscureText,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return '请输入6位支付密码';
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        filled: true,
        hintText: "请输入6位支付密码",
        icon: Icon(Icons.lock, color: KColorConstant.mainColor),
        fillColor: Colors.white,
        errorStyle: TextStyle(fontSize: 8),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _pobscureText = !_pobscureText;
            });
          },
          child: Icon(_pobscureText ? Icons.visibility : Icons.visibility_off,
              semanticLabel: _pobscureText ? 'show password' : 'hide password',
              color: KColorConstant.mainColor),
        ),
      ),
    );
  }

  Widget _buidPassword() {
    return TextFormField(
      controller: _PasswordCtrl,
      obscureText: _obscureText,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return '密码过短';
        }
        _password = value;
      },
      onFieldSubmitted: (String value) {
        _password = value;
      },
      onSaved: (String value) {
        _password = value;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        filled: true,
        hintText: "请输入至少6位密码",
        icon: Icon(Icons.lock, color: KColorConstant.mainColor),
        fillColor: Colors.white,
        errorStyle: TextStyle(fontSize: 8),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
              semanticLabel: _obscureText ? 'show password' : 'hide password',
              color: KColorConstant.mainColor),
        ),
      ),
    );
  }

  Widget _buidRePassword() {
    return TextFormField(
//      enabled: _password != '' && _password.isNotEmpty,
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        hintText: "请再输入一次密码",

        icon: Icon(Icons.lock_outline, color: KColorConstant.mainColor),
//        filled: true,
        fillColor: Colors.white,
        errorStyle: TextStyle(fontSize: 8),
      ),
      validator: (String value) {
        _password = _PasswordCtrl.text.trim();
        if (_password == '') return "请先输入密码";
        if (_password != value) return "密码不一致";
      },
    );
  }

  Widget _buildFromCodeText() {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        helperText: '必填',
//        hintText: ComFunUtil.checkIosOpen(context)?"邀请码(邀请者手机号或ID）":"来源(手机号或ID）",
        filled: true,
        icon: Icon(Icons.camera_front, color: KColorConstant.mainColor),
        fillColor: Colors.white,
        errorStyle: TextStyle(fontSize: 8),
      ),
      autovalidate: true,
      validator: (String value) {
        if (value == '') return "请输入";
      },
      onSaved: (String value) {
        _inviteCode = value;
      },
    );
  }

  Widget _buildUsernameText() {
    return TextFormField(
      controller: _userNameCtrl,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        icon: Icon(
          Icons.person,
          color: KColorConstant.mainColor,
        ),
        hintText: "请输入用户名",
        filled: true,
        fillColor: Colors.white,
//        errorStyle: TextStyle(fontSize: 8),
      ),
      onSaved: (String value) {
        _uName = value;
      },
    );
  }


/*
  Widget _buildUserRealnameText() {
    return TextFormField(
      controller: _userRealNameCtrl,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        icon: Icon(
          Icons.person_outline,
          color: KColorConstant.mainColor,
        ),
        hintText: "请输入真实姓名",
        filled: true,
        fillColor: Colors.white,
//        errorStyle: TextStyle(fontSize: 8),
      ),
      onSaved: (String value) {
        _userName = value;
      },
    );
  }
*/


  Widget _buildPhoneText() {
    var node = new FocusNode();
    return TextFormField(
      controller: _phoneNoCtrl,
//      autovalidate: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        icon: Icon(
          Icons.phone,
          color: KColorConstant.mainColor,
        ),
        hintText: "请输入手机号码",
//        hintStyle: TextStyle(fontSize: 10),
        filled: true,
        fillColor: Colors.white,
//        errorStyle: TextStyle(fontSize: 8),
      ),
//      style: Theme.of(context).textTheme.headline,
      maxLines: 1,
      maxLength: 11,
      //键盘展示为号码
      keyboardType: TextInputType.phone,
      //只能输入数字
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      validator: (String value) {
        if (value.isEmpty) {
          return '请填写手机号码';
        } else {
          if (!ComFun.isChinaPhoneLegal(value.trim())) return '号码有误';
        }
      },
      onSaved: (String value) {
        _phoneNo = value;
      },
    );
  }

  Widget _buildVerifyCodeEdit() {
    var node = new FocusNode();
    Widget verifyCodeEdit = new TextFormField(
      controller: _varCodeCtrl,
//      autovalidate: true,
//      style: KfontConstant.defaultSubStyle,
      decoration: new InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        icon: Icon(Icons.assignment_late, color: KColorConstant.mainColor),
        hintText: "请输入验证码",
//        hintStyle: TextStyle(fontSize: 10),
        filled: true,
        fillColor: Colors.white,
        errorStyle: TextStyle(fontSize: 8),
      ),
      maxLines: 1,
      maxLength: 6,
      //键盘展示为数字
      keyboardType: TextInputType.number,
      //只能输入数字
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],

      validator: (String value) {
        if (value.isEmpty) {
          return '';
        }
      },
      onSaved: (String value) {
        _verifyCode = value.trim();
      },
    );
    Widget verifyCodeBtn = new GestureDetector(
      onTap: (_seconds == 0) ? _getsmsCode : null,
      child: new Container(
        alignment: Alignment.center,
        width: 80.0,
        height: 26.0,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        decoration: BoxDecoration(
            border: new Border.all(
              width: 1.0,
              color: Colors.grey,
            )),
        child: Text(
          _verifyStr,
          style: new TextStyle(fontSize: 11),
        ),
      ),
    );

    return new Padding(
      padding: const EdgeInsets.only(
        left: 0,
        right: 0,
        top: 5.0,
      ),
      child: new Stack(
        children: <Widget>[
          verifyCodeEdit,
          new Align(
            alignment: Alignment.topRight,
            child: verifyCodeBtn,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(mounted){
      _cancelTimer();
      _timer=null;
    }
  }

  @override
  void didUpdateWidget(register oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
