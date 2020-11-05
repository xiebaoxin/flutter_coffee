import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:color_dart/color_dart.dart';
import '../../../utils/utils.dart';
import '../../../utils/comUtil.dart';
import '../../../components/showimage.dart';
import 'package:provider/provider.dart';
import '../../../model/carts_provider.dart';
import '../../../model/globle_provider.dart';
import '../../../components/a_button/index.dart';
import '../../../globalutils/global.dart';
import '../../comm/gotopay.dart';
import '../../../utils/dataUtils.dart';
import '../../../utils/DialogUtils.dart';
import '../../../globleConfig.dart';
import 'select_row.dart';
import '../../../homepage.dart';

class CoffeeDetailDialog extends StatefulWidget {
  final Map<String, dynamic> coffee;
  final Map<String, dynamic> mach;
  CoffeeDetailDialog({
    Key key,
    this.coffee,
    this.mach
  }) : super(key: key);

  _GoodsDetailDialogState createState() => _GoodsDetailDialogState();
}

class _GoodsDetailDialogState extends State<CoffeeDetailDialog> {
  /// 当前选中规格信息
 int _sgtype=2;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.zero,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              color: Colors.transparent,
              elevation: 24.0,
              shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
              type: MaterialType.card,
              child:
    Consumer<GlobleProvider>(
    builder: (context, GlobleProvider provider, _) =>
              _initContent(provider),)
            ),
          ),
        ),
      ),
    );
  }

  _initContent(GlobleProvider provider) {

    return Container(
      width: 335,
      height: 580,
      child: Column(
        children: <Widget>[
          _initHeader(),
          Expanded(
            child: Container(
              color: hex('#fff'),
              padding: EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Visibility(
                        visible: widget.coffee['idSugar'],
                        child: _initOption())
                    ,
                    _line(),
                    cofeeitem(),
                    _initGoodsDesc()
                  ],
                )
              ),
            ),
          ),
          payoption(provider),
//          _initAccount(),
          _initFooter()
        ],
      ),
    );
  }

  /// 分隔线
  _line() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: G.borderBottom()
        ),
      ),
    );
  }

  /// 选项
  _initOption() {
    List<Widget> widgets = [];
    var dtpropoty= {
        "childs": [
          {
            "value": 0,
            "name": "无",
          },
          {
           "value": 1,
            "name": "少",
          },
          {
            "value": 2,
            "name": "标准",
          },
          {
            "value": 3,
            "name": "多",
          }
        ],
        "dateAdd": "2019-08-21 16:52:44",
        "id": 1,
        "name": "糖",
        "paixu": 0,
      }
    ;

    return Column(
      children: <Widget>[
        Container(child: 
          Column(children: [
            SelectRow(
              initv: _sgtype,
              data: dtpropoty,
              onChange: (Map type) {
                print(type);
                setState(() {
                  _sgtype=type['value'];
                });

              },
            )
          ],),
        ),
      ],
    );
  }

  Widget cofeeitem(){
    var it=widget.coffee;
    return Container(
        margin: EdgeInsets.only(top: 3),
        child: ListTile(
          leading: ShowNetImage(
            servpic(it['image']),
            height:60,
            width: 60,
            tapnull: true,
          ),
          title: Text(it['coffeeName']),
          subtitle: Row(
            children: [
              Text(
                '￥',
                style: TextStyle(
                    fontSize: 12,
                    color: KColorConstant.themeColor),
              ),
              Text(
                "${it['money'].toStringAsFixed(2)}",
                style: TextStyle(
                    fontSize: 16,
                    color: KColorConstant.themeColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
  /// 商品描述
  Widget _initGoodsDesc() {
    if(widget.coffee==null || widget.coffee['coffeeName']==null)
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child:null);
    String desc = widget.coffee['coffeeName'];//data.content.replaceAll(RegExp("<.*?p>"), "").replaceAll(RegExp('\\\\n'), '\n');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Expanded(child: 
              Text('商品描述',style: TextStyle(color: rgba(56, 56, 56, 1),fontSize: 13),),
            )
          ],),
          
          Row(children: <Widget>[
            Expanded(child: 
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Text(desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: rgba(128, 128, 128, 1)
                  ),
                )
              )
            ,)
          ],)
      ],),
    );
  }

/*
  /// 结算总价
  Widget _initAccount() {
    if(data!=null && data.basicInfo!=null)
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: rgba(242, 242, 242, 1), width: 1),
          bottom:  BorderSide(color: rgba(242, 242, 242, 1), width: 1),
        ),
        color: hex('#fff'),
      ),
      height: 60,
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text('￥${defaultValue["price"]*defaultValue["num"]}', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: rgba(56, 56, 56, 1)),
              ),
            ),

            AStepper(
              value: defaultValue['num'],
              min: 1,
              onChange: (num val) {
                setState(() {
                  defaultValue['num'] = val;
                });
              },
            )
        ],),
        Container(
          alignment: Alignment.centerLeft,
          child:  Text('${data.basicInfo.name??"dd"} ${G.handleGoodsDesc(defaultValue['specName'])}',
                style: TextStyle(
                    color: rgba(80, 80, 80, 1),
                    fontSize: 10
                ),
               )

        )
      ],),
    );
    else
      return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
      );
  }
*/

  /// 底部
  Widget _initFooter() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        color: hex('#fff'),
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AButton.icon(
            icon: Icon(Icons.accessibility_new),
            textChild: Text('立即购买', style: TextStyle(fontSize: 12),),
            color: hex('#fff'),
            bgColor: rgba(255, 129, 2, 1),
            height: 32,
            onPressed: gotopay
          ),

          AButton.icon(
            height: 32,
            icon: Icon(Icons.add_shopping_cart),
            bgColor: rgba(136, 175, 213, 1),
            color: hex('#fff'),
            textChild: Text('加入购物车', style: TextStyle(fontSize: 12),),
            onPressed: () async {

              if(mounted) {
                final model =  Provider.of<CartsProvider>(context);

                Map<String, dynamic> coffeeparams={
                  "goods_name": widget.coffee['coffeeName'],
                  'goods_id': widget.coffee['id'],
                  'cart_id': widget.mach['id'],
                  "price": widget.coffee['money'],
                  'count': 1,
                  'goods_img': widget.coffee['image'],
                  'attr':_sgtype.toString() //'大/热/无糖'
                };

                  await  model.addtocart(context,coffeeparams);

              }

              await DialogUtils.showToastDialog(context, '加入购物车成功');
              Navigator.pop(context);
              Navigator.pushReplacement(Constants.navigatorKey.currentContext, MaterialPageRoute(
                builder: (context) => HomePage(tabindex:3,),//CartsBuyPage(),
              ));

            }
          )
        ],
      ),
    );
  }

  /// 收藏
  Widget _circelIcon({Icon icon, Function onPress, Color bgColor}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor == null ? rgba(0, 0, 0, 0.3) : bgColor,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: icon
      ),
      onTap: () {
        if(onPress!=null) {
          onPress();
        }
      },
    );
  }

  /// 关闭弹窗
  Widget _initClose() {
    // 关闭
    return Positioned(
      right: 10,
      top: 10,
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: rgba(0, 0, 0, 0.3),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Icon(Icons.clear),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      )
    );
  }

  /// 头部
  Widget _initHeader() {
    return Stack(children: <Widget>[
      Container(
        width: 335,
        height: 150,
        child:
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            ShowNetImage(
              servpic(widget.coffee['image']),
              height:80,
              width: 80,
              tapnull: true,
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Image.asset('images/dialog1.jpg', height: 150, fit: BoxFit.cover,),
            ),
          ],
        )

      ),

      _initClose(),

      // 收藏
      Positioned(
        left: 10,
        top: 10,
        child: _circelIcon(
          icon: Icon(Icons.favorite),
        )
      ),

      // 标题
      Positioned(
        left: 15,
        bottom: 15,
        child: Column(children: <Widget>[
          Text(widget.coffee['coffeeName'],
            style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: hex('#fff')),
          ),
          Text("${widget.coffee['type']==0?"小杯":"大杯"}[${ widget.coffee['idSugar'].toString()==true?"含糖":"不含糖"}]",
            style: TextStyle(fontSize: 14,color: hex('#fff')),
          )
        ],),
      )
    ],);
  }

  bool _switchValueye=false;
  bool _switchjifen=false;
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
                            Icon(Icons.monetization_on,color: Colors.green,),
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
                        trailing:
                        Switch(
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
       /*   Divider(
            height: 3,
          ),
          Visibility(
              visible: _userinfo.point > 0,
              child: Semantics(
                container: true,
                child: Container(
                    color: Color(0xFFFFFFFF),
                    padding: const EdgeInsets.all(0),
//                    child: Card(
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Image.asset(
                            "images/logo.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.fill,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "可用TML${_userinfo.point.toStringAsFixed(4)}抵扣 ${(_userinfo.point / _point_rate).floor().toStringAsFixed(0)}元",
                              style: KfontConstant.defaultSubStyle,
                            ),
                          ),
                        ],
                      ),
                      trailing:
                      */
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
       /*
                      Switch(
                        value: _switchjifen,
                        activeColor: Colors.deepOrange,
                        onChanged: (bool value) {
                          setState(() {
                            _switchjifen = value;
                          });
                        },
                      ),
                    )
//    ),
                ),
              )),*/

        ],
      ),
    );
  }

  String _pwd="";
  Future gotopay() async{
    List<Map<String, dynamic>>  coffeedata = [{
      "drinkId":widget.coffee['id'].toString(),
      "sugarRule":_sgtype.toString(),//糖规则（0=无糖，1=少糖，2=标准，3=多糖）
      "deviceId":widget.mach['id'].toString(),//设备id
      "count":"1"
    }];

    if ( _switchValueye ) {
      if (_pwd.isEmpty)
        await ComFun.getPassword(context, (String pwd) async{
          setState(() {
            _pwd = pwd;
          });
            DialogUtils.showLoadingDialog(context);
            Map<String, String> paydata = {
              "isConsumerCoupon":"0",
              "type":"4",
              "password":_pwd,
              "orderData":json.encode(coffeedata)
            };
         /*   paydata.putIfAbsent("isConsumerCoupon", () => "0");
            paydata.putIfAbsent("type", () => "4");
            paydata.putIfAbsent("password", () => _pwd);*/

            var response = await DataUtils.addCoffeeOrder(context, paydata);
            Navigator.of(context).pop();
            if(response!=null){
              await DataUtils().freshlogin(context);
            }
              setState(() {
                _pwd="";
              });
          Navigator.of(context).pop();

        });
    }
    else
      {
        Map<String, String> paydata = {
          "isConsumerCoupon":"0",
          "orderData":json.encode(coffeedata)
        };
        Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) {
              return GoToPayPage("",data: paydata,money: widget.coffee['money'],);
            })).then((value) => Navigator.of(context).pop());

      }

  }
}

  