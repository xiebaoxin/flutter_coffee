
/*
Future get categoryData async {
  List CategoryItems =[];
  Map<String, String> params = {'objfun':'getIndexCategory'};
  await HttpUtils.dioappi('Shop/getIndexData', params).then((response){
    var cateliest = response["items"];
    cateliest.forEach((ele) {
      if (ele.isNotEmpty) {
        CategoryItems.add(ele);
      }
    });
  });
  return CategoryItems;
}
*/

var  cartData = [
  {
    "goods_name": "卡布奇诺",
    'goods_id': 1,
    'cart_id': 1,
    "price": 25.0,
    'count': 2,
    'goods_img': "",
    'attr':'大/热/无糖'

  },
  {
    "goods_name": "拿铁",
    'goods_id': 2,
    'cart_id': 2,
    "price": 10.5,
    'count': 1,
    'goods_img': "",
    'attr':'大/热/糖'

  },
  {
    "goods_name": "意式黑咖",
    'goods_id': 3,
    'cart_id': 3,
    "price": 20.0,
    'count': 1,
    'goods_img': "",
    'attr':'小/热/无糖'

  },
];

