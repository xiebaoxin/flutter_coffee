// Stub for jpush_flutter
class JPush {
  Future<bool> isNotificationEnabled() async => false;
  void openSettingsForNotification() {}
  void addEventHandler({
    Function(Map<String, dynamic>)? onReceiveNotification,
    Function(Map<String, dynamic>)? onOpenNotification,
    Function(Map<String, dynamic>)? onReceiveMessage,
    Function(Map<String, dynamic>)? onReceiveNotificationAuthorization,
  }) {}
  void setup({String? appKey, String? channel, bool? production, bool? debug}) {}
  void applyPushAuthority(NotificationSettingsIOS settings) {}
  Future<String> getRegistrationID() async => '';
}

class NotificationSettingsIOS {
  final bool sound;
  final bool alert;
  final bool badge;
  NotificationSettingsIOS({this.sound = false, this.alert = false, this.badge = false});
}
