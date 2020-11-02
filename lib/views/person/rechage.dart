import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/dataUtils.dart';
import '../../utils/comUtil.dart';
import '../../utils/DialogUtils.dart';
import '../../routers/application.dart';
import '../../globleConfig.dart';
import '../comm/gotopay.dart';

class Recharge extends StatefulWidget {
  final int type;
  Recharge({this.type = 0});
  @override
  _MobileRechargeState createState() => _MobileRechargeState();
}

class _MobileRechargeState extends State<Recharge> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _mbcountCtrl = new TextEditingController();
  TextEditingController _cardidCtroller = new TextEditingController();

  double _money = 0.0;
  int _nowTime = 0;
  Map<String, String> _params = {};
  int _mindex;
  Map<String, dynamic> _oilitem = {};
  List<Map<String, dynamic>> _CardItems = [
    {'id': 1, 'money': 10.0, 'giveMoney': 0.0}, {'id': 2, 'money': 20.0, 'giveMoney': 0.0},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(widget.type == 0 ? "余额充值" : "手机卡充值"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.history),
                tooltip: '历史',
                onPressed: () {
               /*   Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => JuheLogPage(
                              typeid: widget.type,
                            )),
                  );*/
                },
              ),
            ]),
        body: Form(
            //绑定状态属性
            key: _formKey,
            autovalidate: true,
            child: Container(
                color: Color(0xFFFFFFFF),
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[

                    Visibility(
                      visible: widget.type == 0,
                      child:   moneyitemlist(),
                    ),
                    payto(),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ));
  }

  Widget moneyitemlist() {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 340,
          child: GridView.count(
            semanticChildCount: _CardItems.length,
            padding: EdgeInsets.all(5),
            crossAxisSpacing: 2,
            mainAxisSpacing: 5,
            childAspectRatio: 1.2,
            crossAxisCount: 3,
            children: _CardItems.map((it) {
              return Container(
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _mindex=it['id'];
                          _money = it['money'];
                          _oilitem = it;
                          _nowTime = new DateTime.now().microsecondsSinceEpoch;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: new BoxDecoration(
                            color: _mindex != it['id']
                                ? Color(0xFFFFFFFF)
                                : KColorConstant.mainColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(1.0)),
                            border: Border.all(
                                width: 1.0,
                                color: _mindex == it['id']
                                    ? Color(0xFFeeeeee)
                                    : KColorConstant.mainColor),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "充${it['money']} ${it['giveMoney']==0.0?'':("送${it['giveMoney']}")}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: _mindex == it['id']
                                        ? Color(0xFFFFFFFF)
                                        : KColorConstant.mainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ))
//
                  ));
            }).toList(),
          )),
    );
  }
Widget payto(){
    return   Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
  ComFun().buildMyButton(
  context,
  '确认支付',
  () {

    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return GoToPayPage("",data: _oilitem,money: _money,scean: "RECHARGE",);
        })).then((value) => Navigator.of(context).pop());

  }
  ),
  ],
  );
}

  submit() async {
    final form = _formKey.currentState;
    if (_money==0.0) {
      DialogUtils.showToastDialog(context, "请选择充值金额");
      return;
    }

    String mobile = _mbcountCtrl.text.toString();
    if (mobile.isEmpty) {
      DialogUtils.showToastDialog(context, "电话不能为空");
      return;
    }


    if (form.validate()) {
      form.save();

      Application().checklogin(context, () async {


        if (await DialogUtils()
            .showMyDialog(context, '是否确定给$mobile充值$_money元?')) {
          setState(() {
            if (widget.type == 1)
              _params = {
                "time": _nowTime.toString(),
                "order_amount": _money.toString(),
                "mobile": _mbcountCtrl.text.toString(),
                'type': '1',
                'game_userid': _cardidCtroller.text.toString(),
              };


          });


        }
      });
    }
  }

  void getmoneylist()async{
    _CardItems= await DataUtils.getRechargeConfig(context);
setState(() {

});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmoneylist();
  }

}
