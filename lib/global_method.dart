import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class GlobalMethod {
  //
  static MaterialColor from(Color color) {
    return MaterialColor(color.value, {
      500: color,
    });
  }

  //
  static String formatMoney(dynamic number) {
    return NumberFormat(
      ',###',
      'en_US',
    ).format(number);
  }
}
