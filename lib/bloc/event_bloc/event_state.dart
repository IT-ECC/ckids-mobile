part of 'event_bloc.dart';

@immutable
abstract class EventState {}

class EventStateInitial extends EventState {}

class EventStateLoading extends EventState {}

class EventStateGetList extends EventState {
  final List<EventResponse> listEventResponse;
  final List<EventResponse> listEventResponseBooked;

  EventStateGetList(this.listEventResponse, this.listEventResponseBooked);
}

class EventStateError extends EventState {
  final String message;

  EventStateError(this.message);
}

class EventStateJoinUpcomingSuccess extends EventState {
  final String message;

  EventStateJoinUpcomingSuccess(this.message);
}

class EventStateGetListPerson extends EventState {
  final List<ParticipantResponse> listParticipantsResponse;

  EventStateGetListPerson({required this.listParticipantsResponse});

  List<ParticipantResponse> get listCheckin => listParticipantsResponse.where((ParticipantResponse element) => element.checkinTime.isNotEmpty).toList();
  List<ParticipantResponse> get listCheckout => listParticipantsResponse.where((ParticipantResponse element) => element.checkoutTime.isNotEmpty).toList();
}

class EventStateScanQRUser extends EventState {
  final String message;

  EventStateScanQRUser(this.message);
}

class EventStateCreateSuccess extends EventState {
  final String message;

  EventStateCreateSuccess(this.message);
}