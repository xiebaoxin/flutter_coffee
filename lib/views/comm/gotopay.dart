import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:tobias/tobias.dart';
import 'package:flutter_coffee/globleConfig.dart';
import 'package:flutter_coffee/utils/comUtil.dart';
import 'package:flutter_coffee/utils/dataUtils.dart';
import 'package:flutter_coffee/utils/DialogUtils.dart';
import 'package:flutter_coffee/routers/application.dart';

class GoToPayPage extends StatefulWidget {
  final String order_sn;
  final double money;
  final String scean;
  final Map<String, dynamic> data;
  GoToPayPage(this.order_sn, {this.scean = "CF", this.money = 0.0, this.data});
  @override
  GoToPayPageState createState() => GoToPayPageState();
}

class GoToPayPageState extends State<GoToPayPage>
    with SingleTickerProviderStateMixin {
  String _ordersn = "";
  int _objtype = 1;
  String _payInfo = "";
  double _money = 0.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: SafeArea(
          bottom: false,
          child: Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: new BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  border:
                      null // Border.all(   width: 1.0, color: Colors.green),
                  ),
              height: 480,
              child: _ordersn.isEmpty
                  ? Center(
                      child: Text(
                        '正在加载……',
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  : payselect(),
            ),
          )),
    );
  }

  Widget payselect() {
    return Container(
        width: MediaQuery.of(context).size.width,
//        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    Text(
                      "确认付款",
                    ),
                    Icon(Icons.error_outline)
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: Container(
                    child: ListView(children: <Widget>[
                /*  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "订单号：",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_ordersn),
                      ],
                    ),
                  ),*/
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "￥：",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          "${_money.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*     Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("支付剩余时间：",style: TextStyle(fontSize: 10),),
                    CountDownTimer(_payinfo['account'], type: 1),
                  ],
                ),
              ),*/
                  Visibility(
                      visible: widget.scean == "OTO",
                      child: Center(
                        child: Text(
                          "支付成功两小时后备发货，过期无法取消订单",
                          style: TextStyle(fontSize: 12),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                "选择支付方式：",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 45,
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 12.0,
                                  backgroundImage: AssetImage(
                                    "images/alipay.png",
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    "支付宝",
                                    style: KfontConstant.subBonStyle,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Radio(
                              value: 2,
                              groupValue: _objtype,
                              activeColor: Colors.blue,
                              onChanged: (v) {
                                setState(() {
                                  _objtype = v;
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                _objtype = 2;
                              });
                            },
                          ),
                        ),
                        Divider(),
                        Container(
                          height: 45,
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 12.0,
                                  backgroundImage:
                                      AssetImage("images/weixpay.png"),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    "微信",
                                    style: KfontConstant.subBonStyle,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Radio(
                              value: 1,
                              groupValue: _objtype,
                              activeColor: Colors.blue,
                              onChanged: (v) {
                                setState(() {
                                  _objtype = v;
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                _objtype = 1;
                              });
                            },
                          ),
                        ),
                        Divider(),
                        Container(
                          height: 45,
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 12.0,
                                  backgroundImage:
                                      AssetImage("images/unionpay.png"),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    "银联支付",
                                    style: KfontConstant.subBonStyle,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Radio(
                              value: 3,
                              groupValue: _objtype,
                              activeColor: Colors.blue,
                              onChanged: (v) {
                                setState(() {
                                  _objtype = v;
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                _objtype = 3;
                              });
                            },
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ComFun().buildMyButton(
                              context,
                              '确认支付',
                              () {
//                                Application().checklogin(context, () {
                                if (_objtype == 1)
                                  wxpayto();
                                else if (_objtype == 2)
                                  alipayto();
                                else {
                                  ;
                                }
//                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
                  )
                ])),
              ),
            ]));
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _money = widget.money;
      if (widget.order_sn.isEmpty) {
        _ordersn = ComFun.timestamp;
      } else
        _ordersn = widget.order_sn;
    });

    fluwx.weChatResponseEventHandler.listen((data) async {
      if (data is fluwx.WeChatPaymentResponse) {
        if (data.errCode == 0) {
         await paysuccess();
//          Navigator.of(context).pop();
        } else {
          await DialogUtils.showToastDialog(context, "微信支付失败");
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

   Future paysuccess()async{
    if(widget.scean=="CF")
     await DialogUtils.showToastDialog(context, "购买成功，请及时取货");
    else
      await DialogUtils.showToastDialog(context, "支付成功");
   }
  Future getcomparams() async {
    var response;
    if (widget.scean == 'RECHARGE') {
      response = await DataUtils.RechargePay(context, widget.data['id'],_objtype);
    } else if (widget.scean == "CF") {
      Map<String, String> params = {
        "drinkId": widget.data['drinkId'],
        "sugarRule": widget.data['sugarRule'],
        "deviceId": widget.data['deviceId'],
      };
      params.putIfAbsent("isConsumerCoupon", () => "0");
      params.putIfAbsent("type", () => _objtype.toString());

      response = await DataUtils.addCoffeeOrder(context, params);
    } else
      return widget.data;

    if (response == null) {
      await DialogUtils.showToastDialog(context, "生成订单失败");
      return null;
    }
    print(response['transId']);
    var result;

    if (_objtype == 1) {
      result = response['transId'];
      result = jsonDecode(result);
    }
    if (_objtype == 2) {
      result = response['transId'];
    }

    return result;
  }

  Future wxpayto() async {
    if (await fluwx.isWeChatInstalled) {
      Map<String, dynamic> paydata = await getcomparams();
      print("=--------wxpayto-------");
    
      if (paydata == null) return;
      await fluwx
          .payWithWeChat(
              appId: paydata['appid'].toString(),
              partnerId: paydata['partnerid'].toString(),
              prepayId: paydata['prepayid'].toString(),
              packageValue: paydata['package'].toString(),
              nonceStr: paydata['noncestr'].toString(),
              timeStamp: int.tryParse(paydata['timestamp'].toString()),
              sign: paydata['sign'].toString(),
              extData: "咖啡app商品消费")
          .then((data) async {
        print("--payWithWeChat--return：》$data");
        return data;
//    await DataUtils.freshUserinfo(context);
      });
    }
  }

  Future alipayto() async {
    var paydata = await getcomparams();
    print("----------alipayto--------");
    if (paydata == null) return;
    _payInfo = paydata;
    Map payResult;
    try {
      if (_payInfo.isNotEmpty) {
        payResult = await aliPay(_payInfo);

        if (payResult != null && payResult['resultStatus'].toString() == "9000") {
          print("------payResult['resultStatus'] == 9000---");
          await paysuccess();
        } else {
          await DialogUtils.showToastDialog(context, "支付宝支付失败");
        }
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      payResult = {};
    }
  }
}
