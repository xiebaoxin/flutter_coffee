class SubCategoryItemModel {
  String name;
  String icon;
  int ucid;
  SubCategoryItemModel({this.name, this.icon, this.ucid});
  SubCategoryItemModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        icon = "",
        ucid = json['id'];
}

class SubCategoryListModel {
  List<Map<String, dynamic>> list;
  int ucid;
  String name;
  SubCategoryListModel({this.list,this.ucid,this.name});
  factory SubCategoryListModel.fromJson(Map<String, dynamic> json) {
    var items = json['drinkList'] as List;
    List<Map<String, dynamic>> mlist=List();
     items.map((item) {
      return mlist.add(item);
    }).toList();
    return SubCategoryListModel(list: mlist,ucid: json['id'],name: json['name']);
  }
}