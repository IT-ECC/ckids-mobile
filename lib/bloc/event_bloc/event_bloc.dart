import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eccmobile/bloc/auth_bloc/auth_bloc.dart';
import 'package:eccmobile/data/models/body/add_event_body.dart';
import 'package:eccmobile/data/models/response/participant_response.dart';
import 'package:eccmobile/data/models/response/participant_response.dart';
import 'package:eccmobile/data/models/response/person_event_response.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:meta/meta.dart';
import 'package:eccmobile/data/repository/event_repository.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc(this.eventRepository) : super(EventStateInitial()) {
    on<EventGetUpcoming>((event, emit) async {
      List<EventResponse> listEventResponse = [];
      List<EventResponse> listEventResponseBooked = [];

      emit(EventStateLoading());
      final ApiResponse apiResponse = (event.isAdmin) ? await eventRepository.getListEvent() : await eventRepository.getUpcomingEvent();
      final String messageError = apiResponse.error.toString();

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          try {
            listEventResponse = List.from(apiResponse.response!.data['data']).map((e) {
              return EventResponse.fromJson(e);
            }).toList();
          } catch (e) {
            emit(EventStateError(e.toString()));
          }
        } else {
          emit(EventStateError(messageError));
        }
      } else {
        emit(EventStateError(messageError));
      }

      if (!event.isAdmin) {
        final ApiResponse apiResponseBooked = await await eventRepository.getBookedEvent();
        final String messageBookedError = apiResponseBooked.error.toString();

        if (apiResponseBooked.response != null) {
          if (apiResponseBooked.response!.statusCode == 200) {
            try {
              listEventResponseBooked = List.from(apiResponseBooked.response!.data['data']).map((e) {
                return EventResponse.fromJson(e);
              }).toList();
            } catch (e) {
              emit(EventStateError(e.toString()));
            }
          } else {
            emit(EventStateError(messageBookedError));
          }
        } else {
          emit(EventStateError(messageBookedError));
        }
      }

      emit(EventStateGetList(listEventResponse, listEventResponseBooked));
    });

    on<EventGetListPerson>((event, emit) async {
      emit(EventStateLoading());

      final ApiResponse apiResponse = await eventRepository.getListPerson(eventId: event.eventId);
      final String messageError = apiResponse.error.toString();
      List<ParticipantResponse> listParticipantResponse = [];

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          try {
            listParticipantResponse.addAll(List.from(apiResponse.response!.data['data']).map((e) {
              return ParticipantResponse.fromJson(e);
            }).toList());

            emit(EventStateGetListPerson(
              listParticipantsResponse: listParticipantResponse,
            ));

          } catch (e) {
            emit(EventStateError(e.toString()));
          }
        } else {
          emit(EventStateError(messageError));
        }
      } else {
        emit(EventStateError(messageError));
      }
    });

    on<EventScanQUser>((event, emit) async {
      emit(EventStateLoading());

      final ApiResponse apiResponse = await eventRepository.scanQUser(eventId: event.eventId, personId: event.personId);
      final String messageError = apiResponse.error.toString();

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          emit(EventStateScanQRUser(apiResponse.response!.data['message'] ?? ""));

        } else {
          emit(EventStateError(messageError));
          emit(EventStateGetListPerson(
            listParticipantsResponse: event.listParticipantsResponse,
          ));
        }
      } else {
        emit(EventStateError(messageError));
        emit(EventStateGetListPerson(
          listParticipantsResponse: event.listParticipantsResponse,
        ));
      }
    });

    on<EventCreate>((event, emit) async {
      emit(EventStateLoading());

      final ApiResponse apiResponse = await eventRepository.create(addEventBody: event.addEventBody);
      final String messageError = apiResponse.error.toString();

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          emit(EventStateCreateSuccess(apiResponse.response!.data['message'] ?? ""));
        } else {
          emit(EventStateError(messageError));
        }
      } else {
        emit(EventStateError(messageError));
      }
    });
  }
}
