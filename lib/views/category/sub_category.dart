class SubCategoryItemModel {
  String name;
  String icon;
  int ucid;
  SubCategoryItemModel({this.name, this.icon, this.ucid});
  SubCategoryItemModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        icon = json['icon'],
        ucid = json['ucid'];
}

class SubCategoryListModel {
  List<Map<String, dynamic>> list;
  int ucid;
  SubCategoryListModel({this.list,this.ucid});
  factory SubCategoryListModel.fromJson(Map<String, dynamic> json) {
    var items = json['data'] as List;
    List<Map<String, String>> mlist=List();
     items.map((item) {
      return mlist.add(item);
    }).toList();
    return SubCategoryListModel(list: mlist,ucid: int.parse(json['ucid']));
  }
}