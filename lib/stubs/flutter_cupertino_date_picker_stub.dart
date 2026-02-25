// Stub for flutter_cupertino_date_picker
import 'package:flutter/material.dart';

enum DateTimePickerLocale { zh_cn, en_us }
enum DateTimePickerMode { date, time, datetime }

class DateTimePickerTheme {
  final bool showTitle;
  const DateTimePickerTheme({this.showTitle = true});
}

class DatePicker {
  static void showDatePicker(
    BuildContext context, {
    DateTime? minDateTime,
    DateTime? maxDateTime,
    DateTime? initialDateTime,
    String? dateFormat,
    DateTimePickerLocale? locale,
    DateTimePickerTheme? pickerTheme,
    DateTimePickerMode? pickerMode,
    Function()? onCancel,
    Function(DateTime, List<int>)? onChange,
    Function(DateTime, List<int>)? onConfirm,
  }) async {
    final picked = await showDatePicker2(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: minDateTime ?? DateTime(2020),
      lastDate: maxDateTime ?? DateTime(2030),
    );
    if (picked != null && onConfirm != null) {
      onConfirm(picked, []);
    }
  }

  static Future<DateTime?> showDatePicker2({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }
}
