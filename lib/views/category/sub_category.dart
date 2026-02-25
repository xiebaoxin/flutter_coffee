class SubCategoryItemModel {
  String name;
  String icon;
  int ucid;
  SubCategoryItemModel({this.name = '', this.icon = '', this.ucid = 0});
  SubCategoryItemModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        icon = "",
        ucid = json['id'] ?? 0;
}

class SubCategoryListModel {
  List<Map<String, dynamic>> list;
  int ucid;
  String name;
  SubCategoryListModel({this.list = const [], this.ucid = 0, this.name = ''});
  factory SubCategoryListModel.fromJson(Map<String, dynamic> json) {
    var items = json['drinkList'] as List;
    List<Map<String, dynamic>> mlist=[];
     items.map((item) {
      return mlist.add(item);
    }).toList();
    return SubCategoryListModel(list: mlist,ucid: json['id'],name: json['name']);
  }
}
