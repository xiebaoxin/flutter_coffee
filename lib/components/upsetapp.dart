import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_coffee/stubs/install_plugin_stub.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

const mainTextColor = Color.fromRGBO(115, 115, 115, 1.0);

Future<void> updateAlert(BuildContext context, Map data) async {
  bool isForceUpdate = data['isForceUpdate'];
  String url = data['url'];
  if (Platform.isIOS) {
    url = data['iosurl'];
  }

  Future.delayed(Duration(seconds: 1)).then((value) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        child: UpgradeDialog(data, isForceUpdate, updateUrl: url),
        canPop: false,
      ),
    );
  });
}

class UpgradeDialog extends StatefulWidget {
  final Map data;
  final bool isForceUpdate;
  final String? updateUrl;

  UpgradeDialog(this.data, this.isForceUpdate, {this.updateUrl});

  @override
  _UpgradeDialogState createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<UpgradeDialog> {
  int _downloadProgress = 0;

  CancelToken? token;
  UploadingFlag uploadingFlag = UploadingFlag.idle;
  String _adfileName = "/wangpei-iot.apk";

  @override
  void initState() {
    super.initState();
    token = CancelToken();
  }

  @override
  Widget build(BuildContext context) {
    String info = widget.data['content'];
    return Center(
      child: Material(
        type: MaterialType.transparency,
        textStyle: TextStyle(color: const Color(0xFF212121)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Wrap(
            children: <Widget>[
              SizedBox(height: 10.0, width: 10.0),
              Align(
                alignment: Alignment.topRight,
                child: widget.isForceUpdate
                    ? Container()
                    : InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 5.0,
                      right: 15.0,
                      bottom: 5.0,
                      left: 5.0,
                    ),
                    child: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),

              Container(
                height: 30.0,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text('升级到最新版本',
                    style: TextStyle(
                        color: const Color(0xff343243),
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    child: Text('',
                        style: TextStyle(color: Color(0xff7A7A7A)))),
              ),

              !_updown?
                Container(
                  height: 80.0,
                  width: double.infinity,
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0)),
                  ),
                  child: MaterialButton(
                    color: Colors.orange,
                    child: Text('开始升级'),
                    onPressed: () => rdownloadapp(),
                  ),
                ):
              _buildDownloadWindow(),
            ],
          ),
        ),
      ),
    );
  }

  void _androidUpdate() async {
    final apkPath = await FileUtil.getInstance().getSavePath();
    _adfileName = apkPath + _adfileName;
    try {
      await Dio().download(
        widget.updateUrl!,
        _adfileName,
        cancelToken: token,
        onReceiveProgress: (int count, int total) {
          if (mounted) {
            setState(() {
              _downloadProgress = ((count / total) * 100).toInt();
            });
            if (_downloadProgress == 100) {
              setState(() {
                uploadingFlag = UploadingFlag.uploaded;
              });

              debugPrint("读取的目录:$apkPath");
            }
          }
        },
        options: Options(
          contentType: "STREAM",
          responseType: ResponseType.bytes,
          followRedirects: false,
          sendTimeout: Duration(seconds: 15),
          receiveTimeout: Duration(seconds: 360),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          uploadingFlag = UploadingFlag.uploadingFailed;
        });
      }
    }
  }

  Widget getLoadingWidget() {
    if (_downloadProgress != 0 && uploadingFlag == UploadingFlag.uploading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          width: double.infinity * 80,
          height: 40,
          alignment: Alignment.center,
          child: LinearProgressIndicator(
            valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            backgroundColor: Colors.grey[300],
            value: _downloadProgress / 100,
          ),
        ),
      );
    }

    if (uploadingFlag == UploadingFlag.uploading && _downloadProgress == 0) {
      return Container(
        alignment: Alignment.center,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(mainTextColor)),
            SizedBox(width: 5),
            Material(
              child: Text(
                '等待',
                style: TextStyle(color: mainTextColor),
              ),
              color: Colors.transparent,
            )
          ],
        ),
      );
    }

    if (uploadingFlag == UploadingFlag.uploaded && _downloadProgress == 100) {
      return Container(
        height: 80.0,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0)),
        ),
        child: MaterialButton(
          color: Colors.orange,
          child: Text('安装'),
          onPressed: () => onClickInstallApk(_adfileName),
        ),
      );
    }

    if (uploadingFlag == UploadingFlag.uploadingFailed) {
      return Container(
        alignment: Alignment.center,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.clear, color: Colors.redAccent),
            SizedBox(width: 5),
            Material(
              child: Text(
                '下载超时',
                style: TextStyle(color: mainTextColor),
              ),
              color: Colors.transparent,
            )
          ],
        ),
      );
    }
    return Container();
  }

  void _iosUpdate() {
    launchUrl(Uri.parse(widget.updateUrl!));
  }

  upgradeHandle() {
    if (uploadingFlag == UploadingFlag.uploading) return;
    uploadingFlag = UploadingFlag.uploading;
    if (mounted) setState(() {});
    if (Platform.isAndroid) {
      _androidUpdate();
    } else if (Platform.isIOS) {
      _iosUpdate();
    }
  }

  launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    if (token != null && !token!.isCancelled) token?.cancel();
    super.dispose();
    debugPrint("升级销毁");
  }

  void onClickInstallApk(String apkFilePath) async {
    if (apkFilePath.isEmpty) {
      print('make sure the apk file is set');
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Clipboard.setData(
        ClipboardData(text: prefs.getString("ClipboardDataString") ?? ''));

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    InstallPlugin.installApk(apkFilePath, 'com.netpei.home').then((result) {
      print('install apk $result');
    }).catchError((error) {
      print('install apk error: $error');
    });
  }

  int? id;
  bool isAutoRequestInstall = false;
  GlobalKey<ScaffoldState> _state = GlobalKey();

  Widget _buildDownloadWindow() => Container(
    height: 250,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
    ),
    child: _downloadProgress < 100
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: _downloadProgress > 0 ? _downloadProgress / 100.0 : null,
            strokeWidth: 8,
          ),
        ),
        SizedBox(height: 16),
        Text(_downloadProgress > 0 ? '$_downloadProgress%' : '准备下载中...'),
      ],
    )
        : Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 80),
        SizedBox(height: 16),
        Text('下载完成'),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => onClickInstallApk(_adfileName),
          child: Text('点击安装'),
        ),
      ],
    ),
  );

  bool _updown = false;

  void rdownloadapp() async {
    setState(() {
      _updown = true;
    });
    uploadingFlag = UploadingFlag.uploading;
    _androidUpdate();
  }
}

enum UploadingFlag { uploading, idle, uploaded, uploadingFailed }

class FileUtil {
  static FileUtil? _instance;

  static FileUtil getInstance() {
    if (_instance == null) {
      _instance = FileUtil._internal();
    }
    return _instance!;
  }

  FileUtil._internal();

  Future<String> getSavePath() async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }
}

class CircleDownloadWidget extends StatelessWidget {
  final double progress;
  final Widget? child;
  final Color? backgroundColor;

  const CircleDownloadWidget(
      {Key? key, required this.progress, this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: CircleDownloadCustomPainter(
          backgroundColor ?? Colors.grey[400]!,
          Theme.of(context).primaryColor,
          progress,
        ),
        child: child,
      ),
    );
  }
}

class CircleDownloadCustomPainter extends CustomPainter {
  final Color backgroundColor;
  final Color color;
  final double progress;

  Paint? mPaint;

  CircleDownloadCustomPainter(this.backgroundColor, this.color, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (mPaint == null) mPaint = Paint();
    double width = size.width;
    double height = size.height;

    Rect progressRect =
    Rect.fromLTRB(0, height * (1 - progress), width, height);
    Rect widgetRect = Rect.fromLTWH(0, 0, width, height);
    canvas.clipPath(Path()..addOval(widgetRect));

    canvas.drawRect(widgetRect, mPaint!..color = backgroundColor);
    canvas.drawRect(progressRect, mPaint!..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
