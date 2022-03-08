import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:marvel/domain/entities/current_user.dart';
import 'package:marvel/domain/usecases/auth/current_user_state.dart';
import 'package:marvel/domain/usecases/auth/logout.dart';

part 'event/authentication_event.dart';
part 'event/authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required CurrentUserState currentUserState,
    required Logout logout,
  })  : _currentUserState = currentUserState,
        _logout = logout,
        super(const UnknownState()) {
    _init();
    on<AuthenticationUserChanged>(_onAuthenticationUserChanged);
    on<SignUpCompleted>(_onSignUpCompleted);
    on<LogoutRequest>(_onLogout);
  }

  void _init() {
    _userSubscription = _currentUserState.currentUserState().listen(
      (CurrentUser user) {
        add(AuthenticationUserChanged(user));
      },
    );
  }

  final CurrentUserState _currentUserState;

  final Logout _logout;

  late StreamSubscription<CurrentUser> _userSubscription;

  Future<void> _onAuthenticationUserChanged(AuthenticationUserChanged event,
      Emitter<AuthenticationState> emit) async {
    final currentUser = event.user;

    if (currentUser.isEmpty) {
      await Future.delayed(const Duration(seconds: 4));
      _unregisterAuthenticatedUser();
      emit(const UnauthenticatedState());
      return;
    }

    if (!GetIt.I.isRegistered<CurrentUser>()) {
      GetIt.I.registerSingleton<CurrentUser>(currentUser);
    }
    emit(const AuthenticatedState());
  }

  void _onSignUpCompleted(
      SignUpCompleted event, Emitter<AuthenticationState> emit) {
    emit(const AuthenticatedState());
  }

  void _onLogout(LogoutRequest event, Emitter<AuthenticationState> emit) {
    _unregisterAuthenticatedUser();
    _logout.logout();
  }

  void _unregisterAuthenticatedUser() {
    if (GetIt.I.isRegistered<CurrentUser>()) {
      GetIt.I.unregister(instance: GetIt.I.get<CurrentUser>());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
