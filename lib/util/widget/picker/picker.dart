import 'package:eccmobile/component/app_colors.dart';
import 'package:eccmobile/util/helper.dart';
import 'package:flutter/material.dart';

class Picker {
  Future<void> selectDate(BuildContext context, {required DateTime initialDate, required final ValueChanged<DateTime> onChanged, bool isBirthDay = false, bool isEventDay = false}) async {
    final DateTime dateTime = DateTime.now();
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: (isEventDay) ? dateTime : DateTime(1900, 1),
      lastDate: (isBirthDay) ? dateTime : DateTime(dateTime.year+2),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.cadmiumOrange),
            buttonTheme:
            const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != initialDate) {
      onChanged(picked);
    }
  }

  Future<void> selectTime(BuildContext context, {required TimeOfDay initialTime, required final ValueChanged<TimeOfDay> onChanged}) async {
    final TimeOfDay? picked = await showTimePicker(
      initialTime: initialTime,
      context: context,
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.cadmiumOrange),
          buttonTheme:
          const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      )),
    );

    if (picked != null) {
      onChanged(picked);
    }
  }
}