// Stub for fluwx (WeChat SDK)
Future<void> registerWxApi({
  String? appId,
  bool? doOnAndroid,
  bool? doOnIOS,
  String? universalLink,
}) async {}

Future<bool> get isWeChatInstalled async => false;

Future<dynamic> sendWeChatAuth({String? scope, String? state}) async => null;

Stream<dynamic> get weChatResponseEventHandler => const Stream.empty();

class WeChatPayModel {
  final String? appId;
  final String? partnerId;
  final String? prepayId;
  final String? packageValue;
  final String? nonceStr;
  final String? timeStamp;
  final String? sign;
  WeChatPayModel({
    this.appId,
    this.partnerId,
    this.prepayId,
    this.packageValue,
    this.nonceStr,
    this.timeStamp,
    this.sign,
  });
}

Future<bool> payWithWeChat(WeChatPayModel model) async => false;

class WeChatPaymentResponse {
  final int errCode;
  WeChatPaymentResponse({this.errCode = -1});
}

class WeChatAuthResponse {
  final int errCode;
  final String? code;
  final String? state;
  WeChatAuthResponse({this.errCode = -1, this.code, this.state});
}
