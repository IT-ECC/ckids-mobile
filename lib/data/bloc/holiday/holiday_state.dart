part of 'holiday_bloc.dart';

@immutable
abstract class HolidayState {}

class HolidayInitial extends HolidayState {}

class HolidayLoading extends HolidayState {}

class HolidayLoaded extends HolidayState {
  final List<HolidayModel> listHoliday;

  HolidayLoaded(this.listHoliday);
}

class HolidayEmpty extends HolidayState {}