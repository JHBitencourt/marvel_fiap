part of '../authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  const AuthenticationUserChanged(this.user);

  final CurrentUser user;

  @override
  List<Object?> get props => [user];
}

class LogoutRequest extends AuthenticationEvent {
  const LogoutRequest();
}

class SignUpCompleted extends AuthenticationEvent {
  const SignUpCompleted();
}
