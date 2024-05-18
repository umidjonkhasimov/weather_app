part of 'auth_bloc.dart';

@immutable
final class AuthState {
  final bool isLoading;
  final UserData? userData;
  final Exception? exception;
  final AuthenticationStatus authStatus;

  const AuthState._({
    required this.authStatus,
    required this.isLoading,
    this.exception,
    this.userData,
  });

  const AuthState.unknown({required bool isLoading})
      : this._(
          isLoading: isLoading,
          authStatus: AuthenticationStatus.unknown,
        );

  const AuthState.authenticated({required bool isLoading, UserData? userData})
      : this._(
          isLoading: isLoading,
          authStatus: AuthenticationStatus.authenticated,
          userData: userData,
        );

  const AuthState.unAuthenticated({required bool isLoading, Exception? exception})
      : this._(
          isLoading: isLoading,
          authStatus: AuthenticationStatus.unAuthenticated,
          exception: exception,
        );
}
