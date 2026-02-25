/*
 * @Author: meetqy
 * @since: 2019-08-30 14:34:02
 * @lastTime: 2019-09-23 16:19:54
 * @LastEditors: meetqy
 */
import 'package:flutter_coffee/stubs/color_dart.dart';
import 'package:flutter/material.dart';

class CustomButton {  
  static final Map _buttonTypeConfig= {
    "warning": {"color": hex('#fff'),"bgColor": hex('#ff976a'),"borderColor": hex('#ff976a'),},
    "danger": {"color": hex('#fff'),"bgColor": hex('#f44'),"borderColor": hex('#f44'),},
    "info": {"color": hex('#fff'),"bgColor": hex('#1989fa'),"borderColor": hex('#1989fa'),},
    "primary": {"color": hex('#fff'),"bgColor": hex('#07c160'),"borderColor": hex('#07c160'),},
    "default": {"color": hex('#323233'),"bgColor": hex('#fff'),"borderColor": hex('#ebedf0'),},
  };

  late Widget widget;

  static Color _bgColor = Colors.white;
  static Color _color = Colors.black;
  static Color _borderColor = Colors.grey;

  final String? type; 
  final Color? color;
  final Color? bgColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final bool plain;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  CustomButton.normal({
    this.width,
    this.height,
    this.type,
    this.color,
    this.bgColor,
    this.borderColor,
    this.plain = false,
    this.onPressed,
    this.padding,
    this.borderRadius,
    Widget? child
  }) {
    _setColor();

    widget = _init(child ?? Container());
  }

  CustomButton.icon({
    this.width,
    this.height,
    this.type,
    this.color,
    this.bgColor,
    this.borderColor,
    this.plain = false,
    this.onPressed,
    this.padding,
    this.borderRadius,
    Widget? textChild,
    Widget? icon,
  }) {

    _setColor();

    widget = _initIcon(textChild, icon ?? Container());
  }

  CustomButton.loading({
    this.width,
    this.height,
    this.type,
    this.color,
    this.bgColor,
    this.borderColor,
    this.plain = false,
    this.onPressed,
    this.padding,
    this.borderRadius,
    Widget? textChild,
    Widget? loadingChild,
  }) {   
    _setColor();

    Widget defaultLoading = Transform.scale(
      scale: 0.7,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(_color),
      ),
    );

    widget = _initIcon(textChild, defaultLoading);
  }

  _init(Widget child) {
    return Container(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: padding ?? EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(4),
            side: BorderSide(width: 1, color: !plain ? Colors.transparent : _borderColor)
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: _color,
          backgroundColor: _bgColor,
        ),
        child: child,
        onPressed: onPressed ?? (){},
      ),
    );
  }

  _initIcon(Widget? textChild, Widget icon) {
    Widget iconChild = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(child: icon,),
        Container(
          margin: EdgeInsets.only(left: textChild == null ? 0 : 5),
          child: textChild,
        )
      ],
    );

    return _init(iconChild);
  }

  _getType() {
    var buttonColor = _buttonTypeConfig["$type"];

    if(buttonColor == null) buttonColor = _buttonTypeConfig['default'];

    return buttonColor;
  }

  _setColor(){
    Map buttonColor = _getType();

    Color effectiveColor = color ?? buttonColor['color'];
    Color effectiveBgColor = bgColor ?? buttonColor['bgColor'];
    Color effectiveBorderColor = borderColor ?? buttonColor['borderColor'];

    if(plain) { 
      if(color == null) {
        _color = onPressed == null ? effectiveBgColor.withOpacity(.5): effectiveBgColor;
      } else {
        _color = onPressed == null ? effectiveColor.withOpacity(.5): effectiveColor;
      }
      
      if(borderColor == null) {
        _borderColor = onPressed == null ? effectiveBgColor.withOpacity(.5): effectiveBgColor;
      } else {
        _borderColor = onPressed == null ? effectiveBorderColor.withOpacity(.5): effectiveBorderColor;
      }

      _bgColor = bgColor ?? hex('#fff');
    } else {
      _color = onPressed == null ? effectiveColor.withOpacity(.5): effectiveColor;
      _bgColor = onPressed == null ? effectiveBgColor.withOpacity(.5): effectiveBgColor;
      _borderColor = onPressed == null ? effectiveBorderColor.withOpacity(.5): effectiveBorderColor;
    }
  }
}
