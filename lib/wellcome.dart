import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routers/application.dart';
import './utils/DialogUtils.dart';
import './utils/dataUtils.dart';
import './components/upgradeApp.dart';

class WellCome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<WellCome>{
  static const  int TIMERWELL=5;
  //按钮点击变色--设置一个state值，按下的时候和抬起改变（跟react的state一样）
  bool isClicking1 = false;

  //屏幕的宽高
  double width;
  double height;

  //状态栏的高度
  double statebar_height;
  int pageViewIndex = 0;
  Timer timer;
  bool _isupdate = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    ///设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
   /* ScreenUtil.instance =
        ScreenUtil(width: Klength.designWidth, height: Klength.designHeight)
          ..init(context);*/

    // TODO: implement build
    //获取屏幕的尺寸信息：注意  只能写在这个方法，不能写在initstate
    //需要导入的包  import 'dart:ui';
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    statebar_height = MediaQuery.of(context).padding.top;

    //stack布局:后进后显示原则。设置绝对定位使用Positined left top bottom right实现上下左右间距，可以只设置一个
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        new Positioned(
          child: getPageView(),
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
        ),
        new Positioned(
          //给view添加点击事件，使用GestureDetector便签包裹
          child: new GestureDetector(
            child: new Container(
              padding:
                  const EdgeInsets.only(left: 10, top: 2, right: 10, bottom: 2),
              decoration: new ShapeDecoration(
                color: !isClicking1 ? Colors.green : Color(0xff898989),
                shape: StadiumBorder(
                    side: BorderSide(
                        color: Color(0xff898989),
                        style: BorderStyle.solid,
                        width: 1)),
              ),
              child: _tims <= 10
                  ? Text('跳过${_tims.toString()}s')
                  : Text('${_tims.toString()}s后开启'),
            ),
            onTap: () {
//              print('触发跳过');
              gohome();
            },
            onTapUp: (TapUpDetails) {
//              print('触发onTapUp');
              upDataButtonState(false);
            },
            onTapDown: (TapUpDetails) {
//              print('触发onTapDown');
              upDataButtonState(true);
            },
            onTapCancel: () {
//              print('触发onTapCancel');
              upDataButtonState(false);
            },
          ),
          top: 10 + statebar_height,
          right: 10,
        ),
        new Positioned(
          child: _tims <= 10
              ? FlatButton(
                  color: Colors.green,
                  onPressed: () {
//                    print('点击了立即开启');
                    gohome();
                  },
                  child: Text("立即开启"))
              : Text("系统调试升级中，${_tims.toString()}秒之后恢复正常！"),
          height: pageViewIndex == 2 ? width / 10 : 0,
          bottom: width / 10 - 2,
          right: 20,
        )
      ],
    ));
  }

  //Pageview的使用
  PageView getPageView() {
    PageView pageView;
    PageController pageController;
    var images;
    pageController = new PageController();
    images = ["assets/page1.png", "assets/page2.jpeg", "assets/page3.png"];
    //加载asset目录下的图片===在项目中新建一个images文件夹，然后把文件放进去，在pubspec.yaml里面配置如下
    //  assets:
    //  - images/welcome1.png
    //调用使用 Image.Asset('images/a.png')或者下面的new AssetImage('images/a.png')
    pageView = new PageView.builder(
      itemBuilder: (context, index) {
        return new ConstrainedBox(
          child: new Image(
            image: new AssetImage(images[index]),
            fit: BoxFit.fill,
          ),
          constraints: new BoxConstraints.expand(),
        );
      },
      itemCount: images.length,
      scrollDirection: Axis.horizontal,
      reverse: false,
      //是右侧下一个还是左侧下一个
      controller: pageController,

      onPageChanged: (index) {
//        print('点击滚动到的位置' + index.toString());
        setState(() {
          pageViewIndex = index;
        });
      },
      physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
    );
    return pageView;
  }

//  String _packageInfoversion, _packageInfobuildNumber;
  void getNowVersion() async {
    // 获取此时版本
    var packageInfo = await PackageInfo.fromPlatform();
//    setState(() {
//      _packageInfoversion = packageInfo.version;
//      _packageInfobuildNumber = packageInfo.buildNumber;
//    });

  }

  void _checkUpdateApp() async {
    SharedPreferences prefs = await _prefs;
    String isupdate = prefs.getString('update') ?? ''; //暂时每次更新

    if (isupdate == '') {
      if (await DataUtils().checkDownloadApp(context)) {
        _isupdate = await DialogUtils().showMyDialog(context, '有更新版本，是否马上更新?');
        if (!_isupdate) {
          prefs.setString("update", 'yes');
        } else {
          prefs.remove('update');
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpgGradePage(),
            ),
          );
        }
      }
    }
     prefs.setBool('wellcomeok',true);

  }

  int _tims = 0;
  _startTimer() {
    timer = new Timer.periodic(new Duration(seconds: 1), (timer) async {
      if (_tims == 1) {
        gohome();
      } else if (_tims <= 0) {
        _cancelTimer();
      } else{
        _tims--;
        if(mounted)
          setState(() {});
      }

    });
  }

  _cancelTimer() {
    timer?.cancel();
  }

  bool _iswellcomepage = false;
  void checkwellcome() async {
    SharedPreferences prefs = await _prefs;
//    setState(() {
      _iswellcomepage = prefs.getBool('wellcomeok') ?? false; //已经观看过
//    });
    if(_iswellcomepage)
     {
       if (timer != null) {
         _cancelTimer();
       }
       Application.goto(context, "/home");
     }else
       {
         //    getNowVersion();

         if(mounted){
           setState(() {
             _tims = TIMERWELL;
           });
//           await _checkUpdateApp();
           await _startTimer();
         }

       }
  }

  void gohome() async {
    if (timer != null) {
      _cancelTimer();
        Application.goto(context, "/home");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkwellcome();

    super.initState();

  }

  @override
  void dispose() {
    // 前后台切换3：销毁的注销他
    if (mounted) {
      if (timer != null) timer.cancel();
    }

    // TODO: implement dispose
    super.dispose();
  }

  //StateFulWidget更新state，从而更新UI
  void upDataButtonState(bool clicked) {
    setState(() {
      isClicking1 = clicked;
    });
  }
}
