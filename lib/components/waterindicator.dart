import 'package:flutter/material.dart';

class WaterIndicator extends StatefulWidget {
  final int amount;
  final int maxamount;
  final int type;
  WaterIndicator(this.amount,this.maxamount,{this.type=0});

  @override
  _WaterIndicatorState createState() => _WaterIndicatorState();
}

class _WaterIndicatorState extends State<WaterIndicator> with TickerProviderStateMixin{
  /// 当前的进度。
  double _currentProgress = 0.0;
  // 动画相关控制器与补间。
  AnimationController animation;
  Tween<double> tween;

  @override
  Widget build(BuildContext context) {

    if(widget.maxamount==0)
        _currentProgress=1;
    else
        _currentProgress=widget.amount/widget.maxamount;

    tween = Tween<double>(
      begin: 0.0,
      end: _currentProgress,
    );


    return Container(
          width: 154.0,
          height: 18.0,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            color: Color(0x0fffffff),
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
            image: new DecorationImage(
                image: AssetImage("images/farm/shuicao.png"),

                fit: BoxFit.fill),
            border: null,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                height: 14.0,
                width: 150.0,
                // 圆角矩形剪裁（`ClipRRect`）组件，使用圆角矩形剪辑其子项的组件。
                child: ClipRRect(
                  // 边界半径（`borderRadius`）属性，圆角的边界半径。
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  child: LinearProgressIndicator(
                    value: 1-_currentProgress,//tween.animate(animation).value,
                    backgroundColor:Color(0x0fffffff), //  Color(0x8F33d6c3),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF04d1f8)),
                  ),
                ),
              ),
              Container(
                height: 14.0,
                width: 150.0,
                padding: EdgeInsets.only(left: 7.0),
                alignment: Alignment.center,
                child: Text(
                  '总浇水量:${(widget.maxamount-widget.amount).toString()}g',
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 10.0,
                    fontFamily: 'PingFangRegular',
                  ),
                ),
              ),
            ],
          ),
        )
;
  }


  @override
  void initState() {
    // AnimationController({
    //   double value,
    //   Duration duration,
    //   String debugLabel,
    //   double lowerBound: 0.0,
    //   double upperBound: 1.0,
    //   TickerProvider vsync
    // })


    // 创建动画控制器
    animation = AnimationController(
      // 这个动画应该持续的时间长短。
      duration: const Duration(milliseconds: 900),
      vsync: this,
      // void addListener(
      //   VoidCallback listener
      // )
      // 每次动画值更改时调用监听器
      // 可以使用removeListener删除监听器
    )..addListener(() {
      setState(() {});
    });
    // Tween({T begin, T end })：创建tween（补间）

    // 开始向前运行这个动画（朝向最后）
    animation.forward();
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

}
