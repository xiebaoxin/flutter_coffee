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
  String _verifyCode0 = "";
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
        centerTitle: true,
        title: new Text('注册'),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: new Center(
        child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              //绑定状态属性
              key: _formKey,
//              autovalidate: true,
              child: Padding(
                padding: new EdgeInsets.all(0),
                child: ListView(
                  children: [
                    Padding(
                        padding: new EdgeInsets.all(40),
                        child: Center(
                          child: Image.asset(
                            'images/logo.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.fill,
                          ),
                        )),
                    _buildPhoneText(),
                    _buildVerifyCodeEdit(),
                    _buidPassword(),
                    SizedBox(
                      height: 15,
                    ),
                    _buideRegtxt(),

                Padding(
                  padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
                  child:GestureDetector(
                      onTap:  _forSubmitted,
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
                            '注册',
                            style: new TextStyle(
                                color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ),
                    ))
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
    _verifyCode0 = "";
if(await DataUtils().captcha(context, _phoneNo))
  {
    _verifyCode0 = "1";
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


    if (_verifyCode0.isEmpty) {
      await DialogUtils.showToastDialog(context, '请获取短信验证码');
      return;
    }
    
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
    return
      Padding(
        padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
        child: ComFun.buideloginInput(
          context,
          "至少6位密码",
          _PasswordCtrl,
          header: IconButton(
            icon: new Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: KColorConstant.mainColor),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          obscure: _obscureText,
        ),
      );

  }


  Widget _buildPhoneText() {
    var node = new FocusNode();
    return   Padding(
      padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
      child: ComFun.buideloginInput(
          context, "手机号码", _phoneNoCtrl,
          textInputType: TextInputType.phone,
          header:
          Icon(Icons.phone, color: KColorConstant.mainColor)
      ),
    );

  }

  Widget _buildVerifyCodeEdit() {
    var node = new FocusNode();
    Widget verifyCodeBtn = new GestureDetector(
      onTap: (_seconds == 0) ? _getsmsCode : null,
      child: new Container(
        alignment: Alignment.center,
        width: 80.0,
        height: 26.0,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1.0, color:KColorConstant.mainColor)),),
        child: Text(
          _verifyStr,
          style: new TextStyle(fontSize: 11,color: KColorConstant.mainColor),
        ),
      ),
    );

    return  Padding(
      padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
      child: ComFun.buideloginInput(
        context,
        "验证码",
        _varCodeCtrl,
        textInputType: TextInputType.number,
        header: Icon(
              Icons.assignment_late,
              color: KColorConstant.mainColor),
        suffix: Container(
          child: verifyCodeBtn,
        ),
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
