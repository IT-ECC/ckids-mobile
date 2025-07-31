import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eccmobile/data/models/body/body.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/data/shared_pref.dart';
import 'package:meta/meta.dart';
import 'package:eccmobile/data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final SharedPref sharedPref;

  AuthBloc(this.authRepository, this.sharedPref) : super(AuthStateInitial()) {

    on<AuthEventLogin>((event, emit) async {
      emit(AuthStateLoading());

      final ApiResponse apiResponse = await authRepository.login(username: event.username, password: event.password);

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          try {
            final LoginResponse loginResponse = LoginResponse.fromJson(apiResponse.response!.data);
            final String accessToken = loginResponse.accessToken;
            sharedPref.setValueLogin(token: accessToken, username: loginResponse.profileResponse.name, isAdmin: loginResponse.isAdmin, email: loginResponse.profileResponse.email, photoProfile: loginResponse.profileResponse.photo);

            authRepository.dioClient.token = accessToken;
            authRepository.dioClient.dio.options.headers = {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $accessToken'
            };

            emit(AuthStateSuccess(loginResponse));
          } catch (e) {
            emit(AuthStateError(e.toString()));
          }
        } else {
          emit(AuthStateError(apiResponse.response!.data['message']));
        }
      } else {
        emit(AuthStateError(apiResponse.error.toString()));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      final ApiResponse apiResponse = await authRepository.logout();

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          // clear only some key sharedPref
          sharedPref.logoutClear();
          emit(AuthStateLogoutSuccess(apiResponse.response!.data['message']));
        } else {
          emit(AuthStateLogoutError(apiResponse.response!.data['message']));
        }
      } else {
        emit(AuthStateLogoutError(apiResponse.error.toString()));
      }
    });

    on<AuthEventRegistration>((event, emit) async {
      emit(AuthStateLoading());

      final ApiResponse apiResponse = await authRepository.register(registerBody: event.registerBody);

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          try {
            final LoginResponse loginResponse = LoginResponse.fromJson(apiResponse.response!.data);
            final String accessToken = loginResponse.accessToken;
            sharedPref.setValueLogin(token: accessToken, username: loginResponse.profileResponse.name, isAdmin: loginResponse.isAdmin, email: loginResponse.profileResponse.email, photoProfile: loginResponse.profileResponse.photo);

            authRepository.dioClient.token = accessToken;
            authRepository.dioClient.dio.options.headers = {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $accessToken'
            };

            emit(AuthStateSuccess(loginResponse));
          } catch (e) {
            emit(AuthStateError(e.toString()));
          }
        } else {
          emit(AuthStateError(apiResponse.response!.data['message']));
        }
      } else {
        emit(AuthStateError(apiResponse.error.toString()));
      }
    });


    on<AuthEventGetProfile>((event, emit) async {
      emit(AuthStateLoading());

      final ApiResponse apiResponse = await authRepository.getProfile();

      if (apiResponse.response != null) {
        if (apiResponse.response!.statusCode == 200) {
          final ProfileResponse profileResponse = ProfileResponse.fromJson(apiResponse.response!.data['data']);

          emit(AuthStateProfile(profileResponse));
        } else {
          emit(AuthStateError(apiResponse.response!.data['message']));
        }
      } else {
        emit(AuthStateError(apiResponse.error.toString()));
      }
    });
  }
}
