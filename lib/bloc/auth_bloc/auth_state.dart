part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthStateInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateError extends AuthState {
  final String message;

  AuthStateError(this.message);
}

class AuthStateSuccess extends AuthState {
  final LoginResponse loginResponse;

  AuthStateSuccess(this.loginResponse);
}

class AuthStateLogoutSuccess extends AuthState {
  final String message;

  AuthStateLogoutSuccess(this.message);
}

class AuthStateLogoutError extends AuthState {
  final String message;

  AuthStateLogoutError(this.message);
}

class AuthStateProfile extends AuthState {
  final ProfileResponse profileResponse;

  AuthStateProfile(this.profileResponse);
}