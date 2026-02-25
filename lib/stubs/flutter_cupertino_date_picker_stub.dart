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
    return showDatePickerDialog(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  static Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    return await showDialog<DateTime>(
      context: context,
      builder: (BuildContext ctx) {
        DateTime selected = initialDate;
        return AlertDialog(
          title: const Text('选择日期'),
          content: SizedBox(
            height: 200,
            child: CalendarDatePicker(
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
              onDateChanged: (date) => selected = date,
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
            TextButton(onPressed: () => Navigator.pop(ctx, selected), child: const Text('确定')),
          ],
        );
      },
    );
  }
}
