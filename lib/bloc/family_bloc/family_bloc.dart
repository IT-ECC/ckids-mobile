import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eccmobile/data/models/body/add_member_body.dart';
import 'package:eccmobile/data/models/body/update_member_body.dart';
import 'package:eccmobile/data/models/response/family_role_response.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:meta/meta.dart';
import 'package:eccmobile/data/repository/family_repository.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final FamilyRepository familyRepository;

  FamilyBloc(this.familyRepository) : super(FamilyStateInitial()) {
    on<FamilyEventGetList>((event, emit) async {
      emit(FamilyStateLoading());
      final ApiResponse apiResponse = await familyRepository.getList(eventId: event.eventId);
      final String messageError = apiResponse.error.toString();

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          try {
            List<FamilyResponse> listFamilyResponse = List.from(apiResponse.response!.data['data']).map((e) {
              return FamilyResponse.fromJson(e);
            }).toList();

            emit(FamilyStateGetList(listFamilyResponse));
          } catch (e) {
            emit(FamilyStateError(e.toString()));
          }
        } else {
          emit(FamilyStateError(messageError));
        }
      } else {
        emit(FamilyStateError(messageError));
      }
    });

    on<FamilyEventAddMember>((event, emit) async {
      emit(FamilyStateLoading());
      final ApiResponse apiResponse = await familyRepository.addMember(addMemberBody: event.addMemberBody);
      final String messageError = apiResponse.error.toString();

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          emit(FamilyStateAddorUpdateMemberSuccess(apiResponse.response!.data['message']));
        } else {
          emit(FamilyStateError(messageError));
        }
      } else {
        emit(FamilyStateError(messageError));
      }
    });

    on<FamilyEventUpdateMember>((event, emit) async {
      emit(FamilyStateLoading());
      final ApiResponse apiResponse = await familyRepository.updateMember(updateMemberBody: event.updateMemberBody);
      final String messageError = apiResponse.error.toString();

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          emit(FamilyStateAddorUpdateMemberSuccess(apiResponse.response!.data['message']));
        } else {
          emit(FamilyStateError(messageError));
        }
      } else {
        emit(FamilyStateError(messageError));
      }
    });

    on<FamilyRoleEventGetList>((event, emit) async {
      emit(FamilyStateLoading());
      final ApiResponse apiResponse = await familyRepository.getListRole();
      final String messageError = apiResponse.error.toString();

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          try {
            List<FamilyRoleResponse> listFamilyRoleResponse = List.from(apiResponse.response!.data['data']).map((e) {
              return FamilyRoleResponse.fromJson(e);
            }).toList();

            emit(FamilyStateGetListRole(listFamilyRoleResponse));
          } catch (e) {
            emit(FamilyStateError(e.toString()));
          }
        } else {
          emit(FamilyStateError(messageError));
        }
      } else {
        emit(FamilyStateError(messageError));
      }
    });
  }
}
