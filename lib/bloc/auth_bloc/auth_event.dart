part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthEventLogin extends AuthEvent {
  final String username;
  final String password;

  AuthEventLogin({required this.username, required this.password});
}

class AuthEventRegistration extends AuthEvent {
  final RegisterBody registerBody;

  AuthEventRegistration({required this.registerBody});
}

class AuthEventLogout extends AuthEvent {}

class AuthEventGetProfile extends AuthEvent {
  AuthEventGetProfile();
}