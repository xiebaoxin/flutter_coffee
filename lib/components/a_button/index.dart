/*
 * @Author: meetqy
 * @since: 2019-09-02 10:52:36
 * @lastTime: 2019-11-18 17:29:02
 * @LastEditors: meetqy
 */
import 'package:flutter/material.dart';

import 'custom_button.dart';


class AButton {
  static Widget normal({
    double? width,
    double height = 44,
    String type = 'default',
    Color? color,
    Color? bgColor,
    Color? borderColor,
    bool plain = false,
    VoidCallback? onPressed,
    Widget? child,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius
  }) {
    return CustomButton.normal(
      width: width,
      height: height,
      type: type,
      color: color,
      bgColor: bgColor,
      borderColor: borderColor,
      plain: plain,
      onPressed: onPressed,
      child: child,
      padding: padding,
      borderRadius: borderRadius
    ).widget;
  }

  static Widget icon({
    double? width,
    double height = 44,
    String type = 'default',
    Color? color,
    Color? bgColor,
    Color? borderColor,
    bool plain = false,
    VoidCallback? onPressed,
    Widget? textChild,
    Widget? icon,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius
  }) {
    return CustomButton.icon(
      width: width,
      height: height,
      type: type,
      color: color,
      bgColor: bgColor,
      borderColor: borderColor,
      plain: plain,
      onPressed: onPressed,
      textChild: textChild,
      icon: icon,
      padding: padding,
      borderRadius: borderRadius
    ).widget;
  }

  static Widget loading({
    double? width,
    double height = 44,
    String type = 'default',
    Color? color,
    Color? bgColor,
    Color? borderColor,
    bool plain = false,
    VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Widget? loadingChild,
  }) {
    return CustomButton.loading(
      width: width,
      height: height,
      type: type,
      color: color,
      bgColor: bgColor,
      borderColor: borderColor,
      plain: plain,
      onPressed: onPressed,
      padding: padding,
      borderRadius: borderRadius,
      loadingChild: loadingChild,
    ).widget;
  }
}
