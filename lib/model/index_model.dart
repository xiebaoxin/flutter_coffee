
class MsgCell {
  String title;
  String id;
  String createtime;
  String content;
  String type;

  MsgCell({this.title, this.id, this.createtime, this.content, this.type});

  factory MsgCell.fromJson(Map<String, dynamic> json) {
    return MsgCell(
        title: json['title'] ?? '',
        createtime: json['create_time'] ?? '',
        id: json['id'] ?? '',
        content: json['content'] ?? '',
        type: json['type'] ?? '');
  }
}

class PicsCell {
  String title;
  String id;
  String imgurl;
  String url;
  String deft;
  String time;

  PicsCell({this.title, this.id, this.imgurl, this.url, this.time, this.deft});

  factory PicsCell.fromJson(Map<String, dynamic> json) {
    return PicsCell(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      id: json['id'] ?? '',
      imgurl: json['image_url'] ?? '',
      deft: json['default'] ?? '0',
      time: json['create_time'] ??
          '', // Util.getTimeDuration(json['create_time'])
    );
  }
}
