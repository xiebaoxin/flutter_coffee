import 'package:flutter/material.dart';
import 'color.dart';

class KfontConstant {

  static TextStyle defaultStyle = TextStyle(
    fontSize: 14,
    color: KColorConstant.txtFontColor,
  );

  static TextStyle subStyleWhite = TextStyle(
    fontSize:14,
    color: Colors.white,
  );



  static TextStyle defaultAppbarTitleStyle = TextStyle(
  color: Color(0xFFFFFFFF),
  fontSize: 18,
//  fontWeight: FontWeight.w600
  );

  static TextStyle defaultBonStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: KColorConstant.txtFontColor,
  );

  static TextStyle bigfontStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF888888),
    decoration: TextDecoration.none,
  );


  static TextStyle bigfontBonStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF888888),
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w500,
  );

  static TextStyle subStyle = TextStyle(
    fontSize:12,
    color: Colors.black87,
  );

  static TextStyle subWhiteStyle = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 12,
//  fontWeight: FontWeight.w600
  );
  static TextStyle subBonStyle = TextStyle(
    fontSize:12,
      fontWeight: FontWeight.w500,
    letterSpacing: 2
  );

  static TextStyle littleStyle = TextStyle(
    fontSize:10,
    color: KColorConstant.txtFontColor,
  );


  static TextStyle littleselectedStyle = TextStyle(
    fontSize:10,
    color: KColorConstant.mainColor,
  );

  static TextStyle littleBonStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize:10,
    color: Color(0xFF2f2f2f),
  );

  static TextStyle listTitleStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color:  Color(0xFF2f2f2f),
  );


  static TextStyle priceStyle = TextStyle(
    fontSize:12,
    color: Colors.deepOrangeAccent,
    decoration: TextDecoration.none,
  );

                          
}
