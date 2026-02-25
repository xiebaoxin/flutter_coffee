import 'dart:ui';

Color rgba(int r, int g, int b, double a) {
  return Color.fromRGBO(r, g, b, a);
}

Color hex(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 3) {
    hexColor = hexColor.split('').map((c) => '$c$c').join();
  }
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }
  return Color(int.parse(hexColor, radix: 16));
}
