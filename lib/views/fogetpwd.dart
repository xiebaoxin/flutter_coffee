import 'dart:async'; //timer
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/HttpUtils.dart';
import '../utils/DialogUtils.dart';
import '../utils/comUtil.dart';
import '../globleConfig.dart';

class FogetpwdPage extends StatefulWidget {
  @override
  FogetpwdPageState createState() => new FogetpwdPageState();
}

class FogetpwdPageState extends State<FogetpwdPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _phoneNoCtrl = TextEditingController();
  TextEditingController _PasswordCtrl = TextEditingController();
  TextEditingController _verifyCodeCtrl = TextEditingController();


  String _phoneNo;
  String _password = '';
  bool _obscureText = true;

  int _seconds = 0;
  String _verifyStr = '获取验证码';
//  String _verifyCode;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('忘记密码'),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: new Center(
        child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              //绑定状态属性
              key: _formKey,
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
                    const SizedBox(height: 24.0),
              Padding(
                padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
                child:GestureDetector(
                      onTap: _forSubmitted,
                      child: Container(
                        width: double.infinity,
                        height: 46,
                        decoration: new BoxDecoration(
                          color: KColorConstant.themeColor,
                          borderRadius: BorderRadius.all(Radius.circular(23.0)),
                          border: Border.all(
                              width: 1.0, color: KColorConstant.themeColor),
                        ),
                        child: Center(
                          child: Text(
                            '确定',
                            style: new TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ))


                  ],
//                      child: RaisedButton(
//                          child: Text('添加'), onPressed: _forSubmitted),
//                    ),
                ),
              ),
            )),
      ),
    );
  }

  void _getsmsCode() async {
    _phoneNo= _phoneNoCtrl.text;
    if(_phoneNo.isEmpty ||  !ComFun.isChinaPhoneLegal(_phoneNo) ) {
      await DialogUtils.showToastDialog(context, '手机号必须填写');
      return;
    }

    /*  Map<String, String> params = {
        "phone": _phoneNo,
        "type": '2',
      };
   await HttpUtils.dioappi(
        "Api/smsSend", params,
        context: context).then((response) async {
      print(response);
      if (response['code'] == 1) {
        _seconds=int.tryParse(response['timeout'])??180;
        setState(() {
          _verifyStr = '${_seconds.toString()}(s)重新发送';
        });

        _startTimer();
      }else{
        setState(() {
          _seconds=0;
        });
      }
      await DialogUtils.showToastDialog(context, response['message']);
    });*/

  }

  _startTimer() {
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }
      setState(() {
      _seconds--;
      _verifyStr = '${_seconds.toString()}(s)重新发送';
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

  void _forSubmitted() async{
    final form = _formKey.currentState;
//    _verifyCode=_verifyCodeCtrl.text;
    _phoneNo= _phoneNoCtrl.text.trim();
_password=_PasswordCtrl.text;
    form.save();
//    && _verifyCode != ''
    if (_phoneNo.isNotEmpty && _password.isNotEmpty ) {

      String timestap = ComFun.timestamp;
      Map<String, String> params = {
        "MOBILE": _phoneNo,
        "NEWPASSWORD": _password,
        "TIMESTAMP": timestap,
        "TYPE": "A"

      };

      await HttpUtils.post( "owner/resetPassword", params, context: context).then((response) async{
        await  DialogUtils.showToastDialog(context, response['message']);
        if (response['code'] == '101')
          {
            Navigator.pop(context, "1");
          }
      });

    }else
      await  DialogUtils.showToastDialog(context, "请填写完整参数");
  }

  Widget _buidPassword() {
    return Padding(
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
     TextFormField(
      obscureText: _obscureText,
      validator: (String value) {
        if (value.isEmpty || value.trim().length <= 6) {
          return '密码过短';
        }
      },
      onFieldSubmitted: (String value) {
        setState(() {
          _password = value;
        });
      },
      onSaved: (String value) {
        setState(() {
          _password = value;
        });
      },

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        filled: true,
        hintText: "请输入密码",
        helperText: "请输入密码",
        icon: Icon(Icons.lock,color: KColorConstant.themeColor,) ,
        fillColor: Colors.white,
        errorStyle: TextStyle(fontSize: 8),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'show password' : 'hide password',
            color: KColorConstant.themeColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneText() {
    var node = new FocusNode();
    return  Padding(
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
        _verifyCodeCtrl,
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
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
