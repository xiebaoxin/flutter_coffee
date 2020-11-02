import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/dataUtils.dart';
import '../../globleConfig.dart';
import '../../utils/DialogUtils.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';
import '../../model/carts_provider.dart';
import '../../model/cart.dart';
import '../../utils/comUtil.dart';
import '../../views/cart/cartItem.dart';
import '../../views/comm/gotopay.dart';
import '../../views/person/address.dart';
import '../../model/userinfo.dart';
import '../../routers/application.dart';

class GoodsBuyPage extends StatefulWidget {
  final int store_id;
  GoodsBuyPage({this.store_id = 0});

  @override
  GoodsBuyState createState() => new GoodsBuyState();
}

class GoodsBuyState extends State<GoodsBuyPage> {
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

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color(0xFFFFFFFF),
        child: SafeArea(
            bottom: true,
            top: false,
            child: Scaffold(
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
                                child: mainbody(_cartlist))))),
                bottomNavigationBar: buildbottomsheet(context))));
  }

  Widget mainbody(List<CartItemModel> cartlist) {
    return Consumer<CartsProvider>(
        builder: (context, CartsProvider model, _)
    {
      return ListView(
        children: listviewchildren(model,cartlist),
      );
    });

  }

  List<Widget> listviewchildren(CartsProvider model,List<CartItemModel> cartlist) {
    List<Widget> toplist = <Widget>[
      dizhi(),
      Divider(height: 5),
    ];

    if (cartlist != null && cartlist.length > 0)
      cartlist.forEach((it) {
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
        );
        toplist.add(itemwgt);
      });

    toplist.addAll([
      Divider(height: 2),
      infoption(),
      Container(
        height: 5,
      ),
      payoption(),
      Divider(height: 5),
    ]);

    return toplist;
  }


  Widget dizhi() {
   return Container(
        color: Color(0xFFFFFFFF),
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.phone_iphone),
              title: Text(
                "${_userinfo.name}[${_userinfo.phone}]",
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
          Divider(
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
          ),
//                Divider(),
        ],
      ),
    );
  }

  Widget payoption() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Visibility(
              visible: 1 > 0,
              child: Semantics(
                  container: true,
                  child: Container(
                    color: Color(0xFFFFFFFF),
                    padding: const EdgeInsets.all(0),
//                    child: Card(
                    child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.account_balance_wallet),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "余额0元",
                                style: KfontConstant.littleStyle,
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
          Divider(
            height: 3,
          ),
          Visibility(
              visible: 1 > 0,
              child: Semantics(
                container: true,
                child: Container(
                    color: Color(0xFFFFFFFF),
                    padding: const EdgeInsets.all(0),
//                    child: Card(
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.monetization_on),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "可用积分0",
                              style: KfontConstant.littleStyle,
                            ),
                          ),
                        ],
                      ),
                      trailing: Switch(
                        value: _switchValue,
                        activeColor: Colors.deepOrange,
                        onChanged: (bool value) {
                          setState(() {
                            _switchValue = value;
                          });
                        },
                      ),
                    )
//    ),
                    ),
              )),
          Divider(
            height: 3,
          ),
        ],
      ),
    );
  }

  Widget buildbottomsheet(context) {
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
                if (!_ispayed) await submit();
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

  void submit() async {

    final form = _formKey.currentState;
/*
    if (form.validate()) {
      if (_switchValue || _switchValueye) {
        if (_pwd.isEmpty)
          return getPassword(context, (String pwd) {
            setState(() {
//              print("=====vv=$pwd===========");
              _pwd = pwd;
              submit();
            });
          });
      }

      form.save();
      List<Map<String, String>> aparams = List();
      _cartlist.forEach((it) {
          Map<String, String> tdt = {
            "PRODID": it.goodsId.toString(),
            "PRICE": it.price.toString(),
            "FNLPRICE": it.price.toString(),
            "COUNT": it.count.toString(),
            "VAL": (it.price * it.count).toStringAsFixed(2),
            "REMARKS": it.productName
          };
          aparams.add(tdt);
      });

      Map<String, String> mparams = {
        "TOTALVAL": _money.toStringAsFixed(2),
        "TOTALNUM": _count.toString(),
        "CUSTOMNAME": _userinfo.name.toString(),
        "CUSTOMPHONE": _userinfo.phone.toString(),
        "ADDRESS": _address,
        "REMARKS": _usernoteCtrl.text,
      };
      showLoadingDialog("订单提交中……");
      Map<String, dynamic> v= await ShopUtils.addOrder(
              context, widget.store_id.toString(), aparams, mparams);

        hideLoadingDialog();
        if (v!= null && v['code'].toString() == '101') {
          await DialogUtils.showToastDialog(context, '订单提交成功');

          var retodr=v['data'][0];
          if(retodr!=null){
            //清空购物车
            final model =  Provider.of<CartsProvider>(context);
            List<CartItemModel> cartlist1 = model.cartitems;
            _cartlist.forEach((e)async{
              await  model.removeItem(cartlist1.indexOf(e));
            });

//            print(retodr['ORDERNUM']);
            await Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return GoToPayPage(retodr['ORDERNUM'],double.parse(retodr['TOTALVAL']),scean: "OTO",data: mparams,);
                }));
          }

        } else {
          await DialogUtils.showToastDialog(context, '提交失败${v['msg']}');
          _pwd = '';
        }

    }*/
  }

  Userinfo _userinfo = Userinfo.fromJson({});
  Future _initdata() async {
    final model =  Provider.of<CartsProvider>(context);

    _count = 0;
    _money = 0.0;
    List<CartItemModel> cartlist0 = model.cartitems;
    if (cartlist0 != null && cartlist0.length > 0)
      cartlist0.forEach((it) {
        if (widget.store_id == it.storeId) {
          _count += it.count;
          _money += it.price * it.count;
          _cartlist.add(it);
        }
      });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initdata();
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
