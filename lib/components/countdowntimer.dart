import 'package:flutter/material.dart';
import 'dart:async';

class CountDownTimer extends StatefulWidget {
  final int futime;
  final int type;
  CountDownTimer(this.futime,{this.type=0});

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Timer _countdownTimer;
  String _codeCountdownStr = '';

  @override
  Widget build(BuildContext context) {
    reGetCountdown();
    return Text(
      _codeCountdownStr,
      style: TextStyle(
          fontSize: 12, color: widget.type==0?Colors.redAccent:Colors.white),
    );
  }


  void reGetCountdown() {

    var newDate = DateTime.now();
    const period = const Duration(seconds: 1);

    if(widget.futime>newDate.millisecondsSinceEpoch){
      var diffDate =DateTime.fromMillisecondsSinceEpoch(widget.futime);
//      print('====${widget.futime}======　${newDate.millisecondsSinceEpoch}=========');
      _countdownTimer = Timer.periodic(period, (timer) {
        //到时回调
        diffDate =  diffDate.subtract(Duration(seconds: 1));
        // count++;
        if (diffDate.difference(newDate).inSeconds <= 0) {
          //取消定时器，避免无限回调
          timer.cancel();
          timer = null;
          if(mounted)
          setState(() {
            _codeCountdownStr = "";
          });
        }
        // print();
        var _surplus = diffDate.difference(newDate);

//        int day = (_surplus.inSeconds ~/ 3600) ~/ 24;
        int hour = (_surplus.inSeconds ~/ 3600) % 24;
        int minute = _surplus.inSeconds % 3600 ~/ 60;
        int second = _surplus.inSeconds % 60;
        // formatTime(hour) + ":" + formatTime(minute) + ":" + formatTime(second);
        if(mounted)
        setState(() {
          if(minute==0 && second==0)
            _codeCountdownStr="";
          else{

            _codeCountdownStr = widget.type==0?
            "${hour.toString().padLeft(2, '0')}时${minute
                .toString().padLeft(2, '0')}分${second.toString().padLeft(2, '0')}秒":
            "${minute
                .toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
          }

//          print(_codeCountdownStr);


        });

      });
    }

  }

  // 不要忘记在这里释放掉Timer
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _codeCountdownStr=null;
    super.dispose();
  }


}
