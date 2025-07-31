part of 'family_bloc.dart';

@immutable
abstract class FamilyEvent {}

class FamilyEventGetList extends FamilyEvent {
  final String? eventId;

  FamilyEventGetList({this.eventId});
}

class FamilyRoleEventGetList extends FamilyEvent {}

class FamilyEventAddMember extends FamilyEvent {
  final AddMemberBody addMemberBody;

  FamilyEventAddMember({required this.addMemberBody});
}

class FamilyEventUpdateMember extends FamilyEvent {
  final UpdateMemberBody updateMemberBody;

  FamilyEventUpdateMember({required this.updateMemberBody});
}