import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eccmobile/screens/example/holiday_screen.dart';
import 'package:meta/meta.dart';
import 'package:eccmobile/data/models/holiday_model.dart';
import 'package:eccmobile/data/repository/holiday_repository.dart';

part 'holiday_event.dart';
part 'holiday_state.dart';

class HolidayBloc extends Bloc<HolidayEvent, HolidayState> {
  final HolidayRepository holidayRepository;

  HolidayBloc(this.holidayRepository) : super(HolidayInitial()) {
    on<HolidayEvent>((event, emit) async {
      if (event is HolidayInitialEvent) {
        emit(HolidayLoading());

        List<HolidayModel> list = await holidayRepository.getHoliday() ?? [];

        if (list.isEmpty) {
          emit(HolidayEmpty());
        } else {
          emit(HolidayLoaded(list));
        }
      }
    });
  }
}
