import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_coffee/constants/color.dart';
import 'package:provider/provider.dart';
import 'sub_category.dart';
import '../../routers/application.dart';
import '../../utils/utils.dart';
import '../../model/carts_provider.dart';
import '../../model/cart.dart';
import '../../constants/color.dart';
import '../../components/showimage.dart';
import '../../views/cart/cartItem.dart';

class SecondryCategory extends StatelessWidget {
  final SubCategoryListModel data;
  final Map<String, dynamic> info;
  SecondryCategory({Key key, this.data,this.info}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double bannerWidth = 250;
    double bannerHeight = 90;
    double pimageIwidth = 65 * deviceWidth / 360;

    List<Map<String, dynamic>> items = data.list;
    print("------list_view_item page --------");
print(items);

 /*   List<CartItemModel>  cartitems=List();
    items.forEach((element) {
      var jsonvalue={
        'goods_name':element['coffeeName'],
      'goods_id':element['id'],
      'store_id':info['deviceId'],
      'cart_id':data.ucid,
      'price':element['money'],
      'count':0,
      'goods_img':element['image'],
      'attr':"${element['type']}${element['idSugar']}",
      'limit':100

      };
      CartItemModel item=CartItemModel.fromJson((jsonvalue));
      cartitems.add(item);
    });*/


    return Consumer<CartsProvider>(
        builder: (context, CartsProvider model, _) {
          return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SizedBox(height: 10,),
            Container(
                child:  ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return coffeeItemBuild(context, items[index]);
                    }
/*
              itemBuilder: (BuildContext context, int index) {
            CartItemModel item = cartitems[index];
            return coffeeItemBuild(context, items[index]);
          }*/
                    )
            ),
            /*ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: items.map((i) {
              return InkWell(
                onTap: () {
                  Application.coffeeDetail(context, i);
                },
                child: Container(
                    margin: EdgeInsets.only(top: 3),
                    child: ListTile(
                      leading: ,
                      title: Text(i['coffeeName']),)),
              );
            }).toList(),
          ),*/
            Positioned(
                top: -20,
                left: 5,
                child:  Container(
                  margin: EdgeInsets.all(0),
                  alignment: Alignment.centerLeft,
                  width: deviceWidth,
                  decoration: BoxDecoration(
                      color: Color(0x2FFFFFFF),
                      border: Border(
                          bottom: BorderSide(color: KColorConstant.backgroundColor,
                              width: 1))
                  ),
                  child:  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(data.name,style: TextStyle(fontWeight:FontWeight.bold),) ,

                  ),
                ))

          ],
        ),
      );
        }) ;
  }

  Widget coffeeItemBuild(BuildContext context,Map<String, dynamic> it){
    return  GestureDetector(
      onTap: () {
        Application.coffeeDetail(context, it,info);
      },
      child: Container(
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
          )),
    );
  }

}

class SubCategoryList extends StatefulWidget {
  final double height;
  final Map<String, dynamic> info;
  final SubCategoryListModel data;
  final void Function(String) goPage;
  SubCategoryList({Key key, this.height, this.goPage, this.data,this.info})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => SubCategoryListState();
}

class SubCategoryListState extends State<SubCategoryList> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: this.dragend,
      child: Container(
        height: widget.height,
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 13, bottom: 40),
            controller: controller,
            //  physics: NeverScrollableScrollPhysics(),
            child: Container(
              child: widget.data != null
                  ? SecondryCategory(
                      data: widget.data,
                      info: widget.info,
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              constraints: BoxConstraints(minHeight: widget.height + 5),
            )),
      ),
    );
  }

  dragend(e) {
    double offset = controller.offset;
    double maxExtentLenght = controller.position.maxScrollExtent;
    // print('offset' +
    //     offset.toString() +
    //     "     maxextentlength" +
    //     maxExtentLenght.toString());
    // print(widget.goPage);
    if (offset < -50) {
      widget.goPage('pre');
    }
    if (offset - maxExtentLenght > 50) {
      widget.goPage('next');
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   controller.addListener(() {
  //     print("extentBefore:" +
  //         controller.position.extentBefore.toString() +
  //         'extentAfter' +
  //         controller.position.extentAfter.toString()+'offset'+controller.offset.toString()+ "outOfRange"+controller.position.outOfRange.toString());
  //         print('viewportDimension'+controller.position.viewportDimension.toString()+'maxScrollExtent.'+ controller.position.maxScrollExtent.toString());

  //   });
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
