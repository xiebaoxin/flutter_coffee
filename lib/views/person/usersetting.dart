import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../../utils/DialogUtils.dart';
import '../../routers/application.dart';
import '../../utils/cache.dart';
import '../../components/ImageCropPage.dart';
import '../../model/globle_provider.dart';
import '../../globleConfig.dart';
import '../../components/upgradeApp.dart';
import '../../utils/dataUtils.dart';
import '../../utils/comUtil.dart';
import '../../utils/HttpUtils.dart';
import '../../model/userinfo.dart';
import 'set_paypwd.dart';

class SetUserinfo extends StatefulWidget {
  @override
  SetUserinfoState createState() => new SetUserinfoState();
}

class SetUserinfoState extends State<SetUserinfo> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _ncCtrl = TextEditingController();

  final Color _iconcolor = Colors.black26;
  Userinfo _userinfo = Userinfo.fromJson({});
  String _userAvatar;
  int _sex = 0;
  bool _isedit = false;
String _cache="";
  @override
  Widget build(BuildContext context) {
    final model =  Provider.of<GlobleProvider>(context);
    _userinfo = model.userinfo;
    _userAvatar = model.userinfo.avtar;
    _sex = _userinfo.json['sex'];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('账户设置'),
        centerTitle: true,
      ),
      body: Form(
          //绑定状态属性
          key: _formKey,
          autovalidate: true,
          child: SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Column(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 15.0, 10.0, 15.0),
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                      child: new Text(
                                    "头像",
                                    style: KfontConstant.defaultStyle,
                                  )),
                                  Container(
                                    width: 35.0,
                                    height: 35.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      image: new DecorationImage(
                                          image:  _userAvatar==null || _userAvatar.isEmpty
                                              ? AssetImage("images/logo.png")
                                              : NetworkImage(servpic(_userAvatar)),
                                          fit: BoxFit.cover),
                                      border: null,
                                    ),
                                  ),
//                                  GlobalConfig.rightArrowIcon
                                ],
                              ),
                            ),
                            Divider(
                              height: 1.0,
                            )
                          ],
                        ),
                        onTap: () {
                          Application().checklogin(context, () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => ImageCropperPage()),
                            );
                          }).then((v) {
                            initinfo();
                          });
                        },
                      ),
                    /*  renderRow(
                        Icon(Icons.play_for_work, color: _iconcolor),
                        "用户ID",
                        texti: "111",
                      ),*/
                      Column(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 15.0, 10.0, 15.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "用户",
                                    style: KfontConstant.defaultStyle,
                                  ),
                                  _isedit
                                      ? Container(
                                          width: 200,
                                          child: TextFormField(
                                            controller: _ncCtrl,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(left: 10.0),
//                                icon: Icon(Icons.phone)
                                            ),
                                          ))
                                      : Text(_userinfo.name??_userinfo.phone),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 1.0,
                          )
                        ],
                      ),
                 /*     Column(
                        children: [
                          new Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 15.0, 10.0, 15.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Text(
                                  "性别",
                                  style: KfontConstant.defaultStyle,
                                ),
                                !_isedit
                                    ? Text(
                                        _userinfo.json['sex'].toString() == '0'
                                            ? "男"
                                            : "女")
                                    : Row(
                                        children: [
                                          InkWell(
//                                        width: 45,
                                            child: Row(children: [
                                              Text("女"),
                                              Radio(
                                                value: 1,
                                                groupValue: _sex,
                                                activeColor: Colors.blue,
                                                onChanged: (v) {
                                                  setState(() {
                                                    _sex = v;
                                                  });
                                                },
                                              )
                                            ]),
                                            onTap: () {
                                              setState(() {
                                                _sex = 1;
                                              });
                                            },
                                          ),
                                          InkWell(
//          width: 45,
                                            child: Row(children: [
                                              Text("男"),
                                              Radio(
                                                value: 0,
                                                groupValue: _sex,
                                                activeColor: Colors.blue,
                                                onChanged: (v) {
                                                  setState(() {
                                                    _sex = v;
                                                  });
                                                },
                                              )
                                            ]),
                                            onTap: () {
                                              setState(() {
                                                _sex = 0;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1.0,
                          )
                        ],
                      ),*/
                      renderRow(
                          Icon(Icons.play_for_work, color: _iconcolor),
                          "手机",
                          texti: _userinfo.phone != ''
                              ? _userinfo.phone
                              : "未绑定",
                          index: 6),

                      renderRow(
                          Icon(Icons.payment, color: _iconcolor),
                          "支付密码",
                          texti: _userinfo.paypwd
                          ? "修改"
                          : "未设置",
                          index: 5),

                      renderRow(
                          Icon(Icons.play_for_work, color: _iconcolor), "版本",
                          index: 7),

                      renderRow(
                          Icon(Icons.cached, color: _iconcolor), "清理缓存",
                          index: 100,texti: _cache),
                    ],
                  ),
                ),
                Visibility(
                    visible: !_isedit,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        child: ComFun().buildMyButton(
                          context,
                          '退出登录',
                          () {
                            Navigator.of(context).pop();
                            DialogUtils.close2Logout(context, cancel: true);
                          },
                          width: 120,
                        ),
                      ),
                    )),
              ],
            ),
          ))),
    );
  }

  initinfo() async{
    _cache=await MyCache().getlocalCache();
    setState(() { });
  }

  @override
  void initState() {
    initinfo();
    super.initState();
  }

  renderRow(
    Icon icon,
    String txt, {
    int index = 0,
    String texti = '',
  }) {
    return new InkWell(
      child: Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                /*   Container(
                  child: icon,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                ),*/
                Expanded(
                    child: new Text(
                  txt,
                  style: KfontConstant.defaultStyle,
                )),
                Row(
                  children: <Widget>[
                    Text(texti),
                    index == 7 || index == 5
                        ? GlobalConfig.rightArrowIcon
                        :
                    SizedBox(
                            width: 1,
                          )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1.0,
          )
        ],
      ),
      onTap: () {
        _handleListItemClick(index);
      },
    );
  }

  _handleListItemClick(int index) async{
    if(index==100){
      showLoadingDialog("正在清理缓存……");
      await MyCache().clearCache(context).then((v){
        initinfo();
      });
      hideLoadingDialog();
      return;

    }


  await  Application().checklogin(context, () async{
      switch (index) {
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
        case 4:
          break;
        case 5:
          return await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetPaywsdPage(_userinfo.phone,edit: _userinfo.paypwd,),
            ),
          );
          break;
        case 6:
          break;
        case 7:
          return await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpgGradePage(),
            ),
          );
          break;

        case 9:
          DialogUtils.close2Logout(context, cancel: true);
          break;
      }
    });
  }

  void upSubmitted() async {
    final form = _formKey.currentState;
    form.save();

    if (_ncCtrl.text != '') {
      Map<String, String> params = {
        "nickname": _ncCtrl.text,
        "sex": _sex.toString(),
      };

      Application().checklogin(context, () async {
        await HttpUtils.post('User/upsetuserinfo', params)
            .then((response) async {
          await DialogUtils.showToastDialog(
              context, response['msg'].toString());
          if (response['status'].toString() == '1') {
            Navigator.of(context).pop(true);
          }
        });
      });
    }
  }


  bool _loading = false;
  // 显示加载进度条
  void showLoadingDialog(String msg) async {
    setState(() {
      _loading = true;
    });
    await DialogUtils.showLoadingDialog(context, text: msg);
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
}
