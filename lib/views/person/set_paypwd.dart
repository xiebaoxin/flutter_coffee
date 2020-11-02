import 'dart:async'; //timer
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/dataUtils.dart';
import '../../utils/DialogUtils.dart';
import '../../utils/comUtil.dart';
import '../../routers/application.dart';
import '../../globleConfig.dart';

class SetPaywsdPage extends StatefulWidget {
  final bool edit;
  final String phone;
  SetPaywsdPage(this.phone, {this.edit = false});
  @override
  SetPaywsdPageState createState() => SetPaywsdPageState();
}

class SetPaywsdPageState extends State<SetPaywsdPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _varCodeCtrl = TextEditingController();
  TextEditingController _PasswordCtrl = TextEditingController();
  TextEditingController _oldPasswordCtrl = TextEditingController();
  TextEditingController _PassRewordCtrl = TextEditingController();

  String _password = '';
  String _oldpassword = "";
  bool _passwordre = false;
  bool _obscureText = true;

  int _seconds = 0;
  String _verifyStr = '获取验证码';
  String _verifyCode;
  Timer _timer;

  void _initdata() async {

  }

  @override
  void initState() {
    // TODO: implement initState
//    _initdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(

          centerTitle:true,
          title: Text(!widget.edit ? "设置支付密码" : "修改支付密码"),
        ),
        body: widget.phone.isEmpty
            ? Text("请先绑定手机号码")
            : Form(
                //绑定状态属性
                key: _formKey,
                autovalidate: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: false,
                            initialValue: widget.phone,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
//                                icon: Icon(Icons.phone)
                            ),
                          ),
                        ),
                        _buildVerifyCodeEdit(),
                        _buidPassword(),
                        _buidRePassword(),
                        const SizedBox(height: 10.0),
                        ComFun().buildMyButton(context, '确定', () {
                          submit();
                        },),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                )));
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

  Widget _buidRePassword() {
    return
      Padding(
        padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
        child: ComFun.buideloginInput(
          context,
          "请再输入一次密码",
          _PassRewordCtrl,
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

 dynamic submit() async {
    final form = _formKey.currentState;
    _verifyCode = _varCodeCtrl.text;
    if (_verifyCode.isEmpty) {
      await DialogUtils.showToastDialog(context, "验证码不能为空");
      return;
    }

    String dh = _PasswordCtrl.text;
    if (dh.isEmpty) {
      await DialogUtils.showToastDialog(context, "，密码不能为空");
      return;
    }

    _passwordre = false;
    _password = _PasswordCtrl.text.trim();
    if (_password == '') {
      await DialogUtils.showToastDialog(context, "请先输入密码");
      return;
    }

    if (_password != _PassRewordCtrl.text)
    {
      await DialogUtils.showToastDialog(context, "密码不一致");
      return;
    }

    _passwordre = true;

    if (!_passwordre) {
      await DialogUtils.showToastDialog(context, "，密码确认不一致");
      return;
    }

    if (form.validate()) {
      form.save();

   if(await DataUtils().setPayPassword(context, widget.phone, _PasswordCtrl.text.toString(), _verifyCode)) ;
//      DataUtils().freshlogin(context);
     await DialogUtils.showToastDialog(context, "支付密码设置成功");
      Navigator.of(context).pop();
    }
    ;
  }

  void _getsmsCode() async {
    if(!mounted) return;
    setState(() {
      _seconds = 1;
      _verifyStr = '正在请求…';
    });

    _verifyCode = "";
    if(await DataUtils().captcha(context, widget.phone))
    {
      _verifyCode = "1";
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(mounted){
      _cancelTimer();
      _timer=null;
    }
  }
}
