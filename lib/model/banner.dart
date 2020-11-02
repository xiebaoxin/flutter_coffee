

class BannerItem {
  int adid;
  int type;
  String href;
  String picUrl;
  BannerItem({this.adid,this.href, this.picUrl,this.type});
  BannerItem.fromJson(Map<String, dynamic> json)
      : adid = json['ad_code'],
        href = json['ad_href'],
        type = json['ad_type'],
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

