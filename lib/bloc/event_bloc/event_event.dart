part of 'event_bloc.dart';

@immutable
abstract class EventEvent {}

class EventGetUpcoming extends EventEvent {
  final bool isAdmin;

  EventGetUpcoming({required this.isAdmin});
}

class EventGetBooked extends EventEvent {}

class EventScanQUser extends EventEvent {
  final String personId;
  final String eventId;
  final List<ParticipantResponse> listParticipantsResponse;

  EventScanQUser({
    required this.eventId,
    required this.personId,
    required this.listParticipantsResponse
   });
}

class EventGetListPerson extends EventEvent {
  final String eventId;

  EventGetListPerson({required this.eventId});
}

class EventCreate extends EventEvent {
  final AddEventBody addEventBody;

  EventCreate(this.addEventBody);
}