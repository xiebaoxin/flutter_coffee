import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:r_upgrade/r_upgrade.dart';

const mainTextColor = Color.fromRGBO(115, 115, 115, 1.0);

Future<void> updateAlert(BuildContext context, Map data) async {
  bool isForceUpdate = data['isForceUpdate']; // 从数据拿到是否强制更新字段
  String url = data['url'];
  if (Platform.isIOS) {
    url = data['iosurl'];
  }

  new Future.delayed(Duration(seconds: 1)).then((value) {
    showDialog(
      // 显示对话框
      context: context,
      barrierDismissible: false, // 点击空白区域不结束对话框
      builder: (_) => new WillPopScope(
        // 拦截返回键
        child: new UpgradeDialog(data, isForceUpdate, updateUrl: url),
        // 有状态类对话框
        onWillPop: () {
          return; // 检测到返回键直接返回
        },
      ),
    );
  });
}

class UpgradeDialog extends StatefulWidget {
  final Map data; // 数据
  final bool isForceUpdate; // 是否强制更新
  final String updateUrl; // 更新的url（安装包下载地址）

  UpgradeDialog(this.data, this.isForceUpdate, {this.updateUrl});

  @override
  _UpgradeDialogState createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<UpgradeDialog> {
  int _downloadProgress = 0; // 进度初始化为0

  CancelToken token;
  UploadingFlag uploadingFlag = UploadingFlag.idle;
  String _adfileName = "/wangpei-iot.apk";
  @override
  void initState() {
    super.initState();
    token = new CancelToken(); // token初始化
  }

  @override
  Widget build(BuildContext context) {
    String info = widget.data['content']; // 更新内容
    return new Center(
      // 剧中组件
      child: new Material(
        type: MaterialType.transparency,
        textStyle: new TextStyle(color: const Color(0xFF212121)),
        child: new Container(
          width: MediaQuery.of(context).size.width * 0.8, // 宽度是整宽的百分之80
          decoration: BoxDecoration(
            color: Colors.white, // 背景白色
            borderRadius: BorderRadius.all(Radius.circular(4.0)), // 圆角
          ),
          child: new Wrap(
            children: <Widget>[
              new SizedBox(height: 10.0, width: 10.0),
              new Align(
                alignment: Alignment.topRight,
                child: widget.isForceUpdate
                    ? new Container()
                    : new InkWell(
                  // 不强制更新才显示这个
                  child: new Padding(
                    padding: EdgeInsets.only(
                      top: 5.0,
                      right: 15.0,
                      bottom: 5.0,
                      left: 5.0,
                    ),
                    child: new Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),

              new Container(
                height: 30.0,
                width: double.infinity,
                alignment: Alignment.center,
                child: new Text('升级到最新版本',
                    style: new TextStyle(
                        color: const Color(0xff343243),
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold)),
              ),
              new Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: new Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    child: new Text('',
                        style: new TextStyle(color: Color(0xff7A7A7A)))),
              ),
//              getLoadingWidget(),

   /*       CheckboxListTile(
            value: isAutoRequestInstall,
            onChanged: (bool value) {
              setState(() {
                isAutoRequestInstall = value;
              });
            },
            title: Text('下载完进行安装'),),
              */
              !_updown?
                Container(
                  height: 80.0,
                  width: double.infinity,
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0)),
                  ),
                  child: new MaterialButton(
                    color: Colors.orange,
                    child: new Text('开始升级'),
                    onPressed: () =>rdownloadapp(),// upgradeHandle(),
                  ),
                ):
              _buildDownloadWindow(),
             /* Visibility(
                  visible: _downloadProgress > 0 && _downloadProgress < 100,
                  child: Container(
                    height: 80.0,
                    width: double.infinity,
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0)),
                    ),
                    child: new MaterialButton(
                      color: Colors.grey,
                      child: new Text('安装'),
                      onPressed: null,
                    ),
                  ))*/
            ],
          ),
        ),
      ),
    );
  }

  /*
  * Android更新处理
  * */
  void _androidUpdate() async {
    final apkPath = await FileUtil.getInstance().getSavePath();
    _adfileName = apkPath + _adfileName;
    try {
      await Dio().download(
        widget.updateUrl,
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
          sendTimeout: 15 * 1000,
          receiveTimeout: 360 * 1000,
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

  /*
  * 进度显示的组件
  * */
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

    /*
    * 如果是在进行中并且进度为0则显示
    * */
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
          borderRadius: new BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0)),
        ),
        child: new MaterialButton(
          color: Colors.orange,
          child: new Text('安装'),
          onPressed: () => onClickInstallApk(_adfileName),
        ),
      );
    }

    /*
    * 如果下载失败则显示
    * */
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

  /*
  * IOS更新处理，直接打开AppStore链接
  * */
  void _iosUpdate() {
    launch(widget.updateUrl);
  }

  /*
  * 更新处理事件
  * */
  upgradeHandle() {
    if (uploadingFlag == UploadingFlag.uploading) return;
    uploadingFlag = UploadingFlag.uploading;
    // 必须保证当前状态安全，才能进行状态刷新
    if (mounted) setState(() {});
    // 进行平台判断
    if (Platform.isAndroid) {
      _androidUpdate();
    } else if (Platform.isIOS) {
      _iosUpdate();
    }
  }

  ///跳转本地浏览器
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    if (!token.isCancelled) token?.cancel();
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
        ClipboardData(text: await prefs.getString("ClipboardDataString")));

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    InstallPlugin.installApk(apkFilePath, 'com.netpei.home').then((result) {
      print('install apk $result');
    }).catchError((error) {
      print('install apk error: $error');
    });
  }


  int id;
  bool isAutoRequestInstall = false;

  GlobalKey<ScaffoldState> _state = GlobalKey();

  String iosVersion = "";
  int lastId;

  DownloadStatus lastStatus;

  Widget _buildDownloadWindow() => Container(
    height: 250,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
    ),
    child: id != null
        ? StreamBuilder(
      stream: RUpgrade.stream,
      builder: (BuildContext context,
          AsyncSnapshot<DownloadInfo> snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
             GestureDetector(
               child: SizedBox(
                 height: 150,
                 width: 150,
                 child: CircleDownloadWidget(
                   backgroundColor: snapshot.data.status ==
                       DownloadStatus.STATUS_SUCCESSFUL
                       ? Colors.green
                       : null,
                   progress: snapshot.data.percent / 100,
                   child: Center(
                     child: Text(
                       snapshot.data.status ==
                           DownloadStatus.STATUS_RUNNING
                           ? getSpeech(snapshot.data.speed)
                           : getStatus(snapshot.data.status),
                       style: TextStyle(
                         color: Colors.white,
                       ),
                     ),
                   ),
                 ),
               ),
               onTap: () async {
               if( snapshot.data.status ==
                   DownloadStatus.STATUS_SUCCESSFUL) {
                 if (id == null) {
                   _state.currentState
                       .showSnackBar(SnackBar(content: Text('当前没有ID可升级')));
                   return;
                 }
                 await RUpgrade.upgradeWithId(id);
                 setState(() {});
               }

               },
             )
                  ,


              SizedBox(
                height: 30,
              ),
              Text(
        snapshot.data.status ==
        DownloadStatus.STATUS_SUCCESSFUL ? '下载完成':'${snapshot.data.planTime.toStringAsFixed(0)}s后下载完成'),
            ],
          );
        } else {
          return SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }
      },
    )
        : Text('等待下载'),
  );

  String getStatus(DownloadStatus status) {
    if (status == DownloadStatus.STATUS_FAILED) {
      id = null;
      return "下载失败";
    } else if (status == DownloadStatus.STATUS_PAUSED) {
      return "下载暂停";
    } else if (status == DownloadStatus.STATUS_PENDING) {
      return "获取资源中";
    } else if (status == DownloadStatus.STATUS_RUNNING) {
      return "下载中";
    } else if (status == DownloadStatus.STATUS_SUCCESSFUL) {
      return "点击安装";
    } else if (status == DownloadStatus.STATUS_CANCEL) {
      id = null;
      return "下载取消";
    } else {
      id = null;
      return "未知";
    }
  }

  String getSpeech(double speech) {
    String unit = 'kb/s';
    String result = speech.toStringAsFixed(2);
    if (speech > 1024 * 1024) {
      unit = 'gb/s';
      result = (speech / (1024 * 1024)).toStringAsFixed(2);
    } else if (speech > 1024) {
      unit = 'mb/s';
      result = (speech / 1024).toStringAsFixed(2);
    }
    return '$result$unit';
  }

  bool _updown=false;
  void rdownloadapp() async{
    setState(() {
      _updown=true;
    });
   id = await RUpgrade.upgrade(
     widget.updateUrl,
        fileName: 'wangpei-aiot.apk',
        isAutoRequestInstall: isAutoRequestInstall,
        notificationStyle: NotificationStyle.speechAndPlanTime,
        useDownloadManager: false);
    setState(() {});
  }

  void rinstallapp()async{
    final status = await RUpgrade.getDownloadStatus(id);

    if (status == DownloadStatus.STATUS_SUCCESSFUL) {
      bool isSuccess = await RUpgrade.install(id);
      if (isSuccess) {
        _state.currentState
            .showSnackBar(SnackBar(content: Text('请求成功')));
      }
    } else {
      _state.currentState
          .showSnackBar(SnackBar(content: Text('当前ID未完成下载')));
    }
  }

}

enum UploadingFlag { uploading, idle, uploaded, uploadingFailed }

// 文件工具类
class FileUtil {
  static FileUtil _instance;

  static FileUtil getInstance() {
    if (_instance == null) {
      _instance = FileUtil._internal();
    }
    return _instance;
  }

  FileUtil._internal();

  /*
  * 保存路径
  * */
  Future<String> getSavePath() async {
    final directory = await getExternalStorageDirectory();
//        : await getApplicationDocumentsDirectory();
    return directory.path;
/*//    Directory tempDir = await getApplicationDocumentsDirectory();
    String path ="/sdcard/download/";// tempDir.absolute.path;
    Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return path;*/
  }
}


class CircleDownloadWidget extends StatelessWidget {
  final double progress;
  final Widget child;
  final Color backgroundColor;

  const CircleDownloadWidget(
      {Key key, this.progress, this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: CircleDownloadCustomPainter(
          backgroundColor ?? Colors.grey[400],
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

  Paint mPaint;

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

    canvas.drawRect(widgetRect, mPaint..color = backgroundColor);
    canvas.drawRect(progressRect, mPaint..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}