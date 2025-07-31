import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Format {
  static String money(amount, {bool shorten = false, bool removeSimbol = false}) {
    if (shorten) {
      return 'Rp. ${NumberFormat.compact(locale: 'id').format(amount)}';
    }
    return NumberFormat.currency(
      locale: 'id',
      symbol: removeSimbol ? '' : 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }

  static String convertDate(DateTime date, String dateFormat)  {
    return DateFormat(dateFormat).format(date);
  }

  static DateTime convertTimeToDate(TimeOfDay time) {
    final _now = DateTime.now();
    return DateTime(_now.year,_now.month,_now.day,time.hour,time.minute);
  }

  static String compact(number){
    return NumberFormat.compact().format(number);
  }
}