part of '../authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class UnknownState extends AuthenticationState {
  const UnknownState();
}

class UnavailableState extends AuthenticationState {
  const UnavailableState._({
    this.noConnection = false,
    this.hasError = false,
    this.message = '',
  });

  factory UnavailableState.noConnection(String message) => UnavailableState._(
        noConnection: true,
        message: message,
      );

  factory UnavailableState.withError({required String message}) =>
      UnavailableState._(
        hasError: true,
        message: message,
      );

  final bool noConnection;
  final bool hasError;
  final String message;

  @override
  List<Object?> get props => [noConnection, hasError, message];
}

class UnauthenticatedState extends AuthenticationState {
  const UnauthenticatedState({this.message});

  final String? message;

  bool get hasMessage => message != null && message!.isNotEmpty;

  @override
  List<Object?> get props => [message];
}

class AuthenticatedState extends AuthenticationState {
  const AuthenticatedState();
}
