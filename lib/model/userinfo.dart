
class Userinfo {
  int id;
  String name;
  String avtar;
  String phone;
  Map<String, dynamic> json;

  Userinfo(
      {
        this.phone = '未注册',
      this.id =0,
      this.name = '未注册',
      this.avtar = "",
      this.json
      });

  factory Userinfo.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty)
      return Userinfo(
          phone: '未注册',
          name: '未注册',
          id: 0,
          avtar: '',
          json: {},
         );

    return Userinfo(
        phone: json['phone'] ?? '未绑定',
        id: json['id'] ??0,
        name: json['nickName'],
        avtar: json['avatar']??'',
        json: json
    );
  }
}
