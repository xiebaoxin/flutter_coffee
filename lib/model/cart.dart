class CartItemModel {
  int cartId;
  String productName;
  int goodsId;
  int storeId;
  int buyLimit;
  int count;
  String imageUrl;
  String attr;
  bool isSelected;
  bool isDeleted;
  double price;
  String extrinfo;
  CartItemModel(
      {this.productName,
      this.count=1,
      this.cartId,
      this.goodsId,
      this.storeId,
      this.buyLimit = 100,
      this.imageUrl,
      this.attr,
      this.price,
      this.isDeleted = false,
      this.isSelected = true,
      this.extrinfo=""});
  CartItemModel.fromJson(dynamic json)
      : productName = json['goods_name'],
        goodsId = json['goods_id'],
        storeId = json['store_id'],
        cartId = json['cart_id'],
        price = json['price'] ?? 0.0,
        isDeleted = false,
        count = json['count'],
        isSelected = true, // (json['selected'] as int) == 1 ? true : false,
        imageUrl = json['goods_img'] ?? '',
        attr = json['attr'] ?? "",
        buyLimit = json['limit']??100,
        extrinfo="";
}
