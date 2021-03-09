import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/dataUtils.dart';
import '../../globleConfig.dart';
import '../../utils/DialogUtils.dart';
import 'package:provider/provider.dart';
import '../../model/carts_provider.dart';
import '../../model/globle_provider.dart';
import '../../model/cart.dart';
import '../../utils/comUtil.dart';
import '../cart/cartItem.dart';
import 'gotopay.dart';
import '../../model/userinfo.dart';
import 'package:color_dart/color_dart.dart';

class CoffeeCartsBuy extends StatefulWidget {
  @override
  GoodsBuyState createState() => new GoodsBuyState();
}

class GoodsBuyState extends State<CoffeeCartsBuy> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _usernoteCtrl = TextEditingController();
  double _point_rate = 1.0;
  int _count = 0;
  double _money = 0.0;
  List<CartItemModel> _cartlist = List();

  bool _switchValue = false; //jif
  bool _switchValueye = false; //余额

  String _pwd = '';
  bool _ispayed = false;
  String _address = "";
  Userinfo _userinfo;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color(0xFFFFFFFF),
        child: SafeArea(
            bottom: true,
            top: false,
            child: Consumer<CartsProvider>(
                builder: (context, CartsProvider cartsmodel, _) {
              return Scaffold(
                  appBar: new AppBar(
                    title: new Text('订单支付'),
                    centerTitle: true,
                  ),
                  body: Container(
                      padding: EdgeInsets.all(5),
                      child: Form(
                          //绑定状态属性
                          key: _formKey,
                          autovalidate: true,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: mainbody(cartsmodel))))),
                  bottomNavigationBar: buildbottomsheet(context, cartsmodel));
            })));
  }

  Widget mainbody(CartsProvider model) {
    return ListView(
      children: listviewchildren(model),
    );
  }

  List<Widget> listviewchildren(CartsProvider model) {
    final usmodel = Provider.of<GlobleProvider>(context);
    List<Widget> toplist = <Widget>[
      dizhi(usmodel),
      Divider(height: 5),
    ];
    List<CartItemModel> cartlist = model.cartitems;
    if (cartlist != null && cartlist.length > 0)
      cartlist.forEach((it) {
        if (it.isSelected) {
          Widget itemwgt = CartItemWidget(
            it,
            readonly: true,
            index: cartlist.indexOf(it),
            switchChaned: (i) {
              model.switchSelect(i);
            },
            addCount: (int i) {
              model.addCount(i);
            },
            downCount: (int i) {
              model.downCount(i);
            },
            showtype: 0,
          );
          toplist.add(itemwgt);
        }
      });

    toplist.addAll([
      Divider(height: 2),
      infoption(),
      Container(
        height: 5,
      ),
      payoption(usmodel),
      Divider(height: 5),
    ]);

    return toplist;
  }

  Widget dizhi(GlobleProvider usmodel) {
    _userinfo = usmodel.userinfo;
    return Container(
        color: Color(0xFFFFFFFF),
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.phone_iphone),
              title: Text(
                "${_userinfo.phone}",
                maxLines: 1,
                softWrap: true, //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                overflow: TextOverflow.ellipsis,
              ),
            ),
            /*          ListTile(
                leading: Icon(Icons.location_city),
                title: Text(
                  _adressid != ""
                      ? "${_address['consignee']}[${_address['mobile']}]"
                      : "请添加收获地址",
                  maxLines: 1,
                  softWrap: true, //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _adressid,
                  maxLines: 1,
                  softWrap: true, //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new AddressPage()),
                  ).then((v) {});
                }),*/
            Container(
              height: 5,
              decoration: new BoxDecoration(
                color: Colors.white,
                image: new DecorationImage(
                    image: new AssetImage('images/tt.png'),
                    fit: BoxFit.fitWidth),
                border: null,
              ),
            ),
          ],
        ));
  }

  Widget infoption() {
    return Container(
      color: Color(0xFFFFFFFF),
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            alignment: Alignment.center,
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                '暂无优惠券',
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                /*  Application().checklogin(context, () async {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new AddressPage()),
                      );
                    });*/
              },
            ),
          ),
          /*    Divider(
            height: 1,
          ),
          Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            alignment: Alignment.center,
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Row(
                children: <Widget>[
                  Text(
                    '物流配送',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Color(0x22e5f6ff),
                        borderRadius: BorderRadius.all(Radius.circular(210.0)),
//                                      borderRadius:   const BorderRadius.horizontal( left: Radius.circular(20)),
                        border: Border.all(width: 1.0, color: Colors.green),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Text(
                            '免运费',
                            style: TextStyle(fontSize: 10, color: Colors.green),
                          )),
                    ),
                  ),
                ],
              ),
              onTap: () {},
            ),
          ),*/
     /*     Divider(
            height: 1,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            height: 80,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "用户备注(50字)：",
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "(选填)",
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),*/
//                Divider(),
        ],
      ),
    );
  }

  Widget payoption(GlobleProvider myinfo) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Visibility(
              visible: myinfo.userinfo.money > 0,
              child: Semantics(
                  container: true,
                  child: Container(
                    color: Color(0xFFFFFFFF),
                    padding: const EdgeInsets.all(0),
//                    child: Card(
                    child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.monetization_on,
                              color: Colors.green,
                            ),
//                            Image.asset(
//                              "images/goldbi.png",
//                              width: 20,
//                              height: 20,
//                              fit: BoxFit.fill,
//                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "余额：${myinfo.userinfo.money}元",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: rgba(56, 56, 56, 1)),
                              ),
                            ),
                          ],
                        ),
                        trailing: Switch(
                          value: _switchValueye,
                          activeColor: Colors.deepOrange,
                          onChanged: (bool value) {
                            setState(() {
                              _switchValueye = value;
                            });
                          },
                        )),
//                    ),
                  ))),

          /*   Radio(
                        value:1,
                        groupValue:_optionValue,
                        activeColor: Colors.blue,
                        onChanged:(v){
                          setState(() {
                            _optionValue = v;
                          });
                        },
                      )*/
        ],
      ),
    );
  }

  Widget buildbottomsheet(context, CartsProvider carts) {
    List<CartItemModel> cartlist = carts.cartitems;
    _money = 0.0;
    _count = 0;
    cartlist.forEach((item) {
      if (item.isSelected) {
        _count += item.count;
        _money += item.price * item.count;
      }
    });

    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      width: MediaQuery.of(context).size.width,
      height: 50,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
//            width:180,
            child: Align(
              alignment: Alignment.center,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "共",
                          style: KfontConstant.subBonStyle,
                        ),
                        Text(
                          _count.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFfe5400),
                          ),
                        ),
                        Text(
                          "件,",
                          style: KfontConstant.subBonStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "合计支付",
                          style: KfontConstant.subBonStyle,
                        ),
                        Text(
                          _money.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFfe5400),
                          ),
                        ),
                        Text(
                          "元",
                          style: KfontConstant.subBonStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 100,
            child: InkWell(
              onTap: () async {
                if (!_ispayed) await submit(carts);
              },
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 5),
                height: 38,
//                      width: 80,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Color(0xFFfe5400),
                  border: null,
                  gradient: const LinearGradient(
                      colors: [Colors.orange, Color(0xFFfe5400)]),
                  borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                ),
                child: Text(
                  '立即支付',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submit(CartsProvider carts) async {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      showLoadingDialog("订单提交中……");

      List<dynamic> coffeedata = List();

      List<CartItemModel> cartlist = carts.cartitems;
      cartlist.forEach((item) {
        if (item != null && item.isSelected) {
          var terrr = {
            "drinkId": item.goodsId,
            'sugarRule': int.parse(item.attr),
            'deviceId': item.cartId,
            'count': item.count
          };
          coffeedata.add(terrr);
        }
      });

      if (_switchValueye) {
        if (_pwd.isEmpty)
          await ComFun.getPassword(context, (String pwd) async {
            setState(() {
              _pwd = pwd;
            });
            DialogUtils.showLoadingDialog(context);
            Map<String, String> paydata = {
              "isConsumerCoupon": "0",
              "type": "4",
              "password": _pwd,
              "orderData": "${json.encode(coffeedata)}"
            };

            setState(() {
              _ispayed = true;
              _pwd = "";
            });
            var response = await DataUtils.addCoffeeOrder(context, paydata);

              await DataUtils().freshlogin(context);
              //清空购物
              _cartlist.forEach((e) async {
                if(e.isSelected)
                  await carts.removeItem(cartlist.indexOf(e));
              });


            hideLoadingDialog();
            Navigator.of(context).pop();

          });
      } else {
        Map<String, String> paydata = {
          "isConsumerCoupon": "0",
          "orderData": json.encode(coffeedata)
        };
        setState(() {
          _ispayed = true;
        });
        hideLoadingDialog();
        Navigator.of(context)
            .push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return GoToPayPage(
                    "",
                    data: paydata,
                    money: _money,
                  );
                }))
            .then((value) => Navigator.of(context).pop());
      }

//

    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
