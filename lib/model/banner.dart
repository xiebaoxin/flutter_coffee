

class BannerItem {
  int adid;
  String href;
  String picUrl;
  BannerItem({this.adid,this.href, this.picUrl});
  BannerItem.fromJson(Map<String, dynamic> json)
      : adid = json['ad_code'],
        href = json['ad_link'],
        picUrl = json['ad_link'];
}


class BannerList {
  List<BannerItem> items;
  BannerList({this.items});
  factory BannerList.fromJson(dynamic json) {
    List list = (json as List).map((i) {
      return BannerItem.fromJson(i);
    }).toList();
    return BannerList(items: list);
  }
}

