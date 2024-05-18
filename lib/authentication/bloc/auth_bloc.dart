import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../models/result_model.dart';
import '../../models/user.dart';
import '../auth_repository/auth_repository.dart';
import '../auth_repository/auth_status.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<AuthenticationStatus> _streamController;

  AuthBloc({required AuthRepository repository})
      : _authRepository = repository,
        super(const AuthState.unknown(isLoading: false)) {
    on<_AuthEventAuthStatusChange>(
      (event, emit) {
        switch (event.authStatus) {
          case AuthenticationStatus.unknown:
            emit(const AuthState.unknown(isLoading: false));
          case AuthenticationStatus.authenticated:
            emit(const AuthState.authenticated(isLoading: false));
          case AuthenticationStatus.unAuthenticated:
            emit(const AuthState.unAuthenticated(isLoading: false));
        }
      },
    );

    on<AuthEventSignIn>(
      (event, emit) async {
        emit(const AuthState.unknown(isLoading: true));
        final result = await _authRepository.signIn(event.email, event.password);
        if (result is ResultSuccess) {
          emit(
            AuthState.authenticated(
              isLoading: false,
              userData: repository.currentUser,
            ),
          );
        } else if (result is ResultFailure) {
          emit(
            AuthState.unAuthenticated(
              isLoading: false,
              exception: result.exception,
            ),
          );
        }
      },
    );

    on<AuthEventSignUp>(
      (event, emit) async {
        emit(const AuthState.unknown(isLoading: true));
        final result = await _authRepository.signUp(event.email, event.password);
        if (result is ResultSuccess) {
          emit(
            AuthState.authenticated(
              isLoading: false,
              userData: repository.currentUser,
            ),
          );
        } else if (result is ResultFailure) {
          emit(
            AuthState.unAuthenticated(
              isLoading: false,
              exception: result.exception,
            ),
          );
        }
      },
    );

    on<AuthEventSignOut>(
      (event, emit) async {
        emit(const AuthState.unknown(isLoading: true));
        await _authRepository.signOut();
        emit(const AuthState.unAuthenticated(isLoading: false));
      },
    );

    _streamController = _authRepository.authState.listen(
      (authState) {
        add(_AuthEventAuthStatusChange(authStatus: authState));
      },
    );
  }

  @override
  Future<void> close() {
    _streamController.cancel();
    return super.close();
  }
}
