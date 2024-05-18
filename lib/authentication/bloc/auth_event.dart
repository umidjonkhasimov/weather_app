part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class _AuthEventAuthStatusChange extends AuthEvent {
  final AuthenticationStatus authStatus;

  _AuthEventAuthStatusChange({required this.authStatus});
}

final class AuthEventSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthEventSignIn({required this.email, required this.password});
}

final class AuthEventSignUp extends AuthEvent {
  final String email;
  final String password;

  AuthEventSignUp({required this.email, required this.password});
}

final class AuthEventSignOut extends AuthEvent {}
