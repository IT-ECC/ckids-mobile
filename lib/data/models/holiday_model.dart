class HolidayModel {
  HolidayModel({
    required this.holidayDate,
    required this.holidayName,
    required this.isNationalHoliday,
  });
  late final String holidayDate;
  late final String holidayName;
  late final bool isNationalHoliday;

  HolidayModel.fromJson(Map<String, dynamic> json){
    holidayDate = json['holiday_date'];
    holidayName = json['holiday_name'];
    isNationalHoliday = json['is_national_holiday'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['holiday_date'] = holidayDate;
    _data['holiday_name'] = holidayName;
    _data['is_national_holiday'] = isNationalHoliday;
    return _data;
  }
}