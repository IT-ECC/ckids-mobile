part of 'family_bloc.dart';

@immutable
abstract class FamilyState {}

class FamilyStateInitial extends FamilyState {}

class FamilyStateLoading extends FamilyState {}

class FamilyStateGetList extends FamilyState {
  final List<FamilyResponse> listFamilyResponse;

  FamilyStateGetList(this.listFamilyResponse);
}

class FamilyStateError extends FamilyState {
  final String message;

  FamilyStateError(this.message);
}

class FamilyStateAddorUpdateMemberSuccess extends FamilyState {
  final String message;

  FamilyStateAddorUpdateMemberSuccess(this.message);
}

class FamilyStateGetListRole extends FamilyState {
  final List<FamilyRoleResponse> listFamilyRoleResponse;

  FamilyStateGetListRole(this.listFamilyRoleResponse);
}