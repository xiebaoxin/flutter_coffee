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
        title: new Text('忘记密码'),
      ),
      body: new Center(
        child: Container(
            margin: EdgeInsets.all(20.0),
            color: Colors.white,
            child: Form(
              //绑定状态属性
              key: _formKey,
              child: Padding(
                padding: new EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                child: ListView(
                  children: [
                    _buildPhoneText(),
                    _buildVerifyCodeEdit(),
                    _buidPassword(),
                    const SizedBox(height: 24.0),
                    GestureDetector(
                      onTap: _forSubmitted,
                      child: Container(
                        width: 80,
                        height: 40,
                        decoration: new BoxDecoration(
                          color: KColorConstant.themeColor,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                    )


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

    form.save();
//    && _verifyCode != ''
    if (_phoneNo!='' && _password!='' ) {

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
    return TextFormField(
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
    return TextFormField(
      controller: _phoneNoCtrl,
//      autovalidate: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        icon: Icon(Icons.phone,color: KColorConstant.themeColor,) ,
        hintText:  "请输入手机号码",
        filled: true,
        fillColor: Colors.white,
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
          return '';
        } else {
          if (!ComFun.isChinaPhoneLegal(value.trim())) return '号码有误';
        }
      },
      onSaved: (String value) {
        _phoneNo = value.trim();
      },

    );
  }

  Widget _buildVerifyCodeEdit() {
    var node = new FocusNode();
    Widget verifyCodeEdit = new TextFormField(
      controller: _verifyCodeCtrl,
//      autovalidate: true,
       decoration: new InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        icon: Icon(Icons.assignment_late,color: KColorConstant.themeColor,) ,
        hintText:  "请输入验证码",
        filled: true,
        fillColor: Colors.white,
        errorStyle: TextStyle(fontSize: 8),
      ),
      maxLines: 1,
      maxLength: 4,
      //键盘展示为数字
      keyboardType: TextInputType.number,
      //只能输入数字
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],

      validator: (String value) {
        if (value.isEmpty) {
          return '请填写验证码';
        }
      },
      onSaved: (String value) {
//        _verifyCode = value.trim();
      },

    );
    Widget verifyCodeBtn = new InkWell(
      onTap: (_seconds == 0) ? _getsmsCode : null,
      child: new Container(
//        alignment: Alignment.bottomRight,
        width: 80.0,
        height: 26.0,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        decoration: BoxDecoration(
            border: new Border.all(
              width: 1.0,
              color: Colors.grey,
            )
        ),
        child: Text(
          '$_verifyStr',
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
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
