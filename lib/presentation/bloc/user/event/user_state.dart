part of '../user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UnknownUser extends UserState {
  const UnknownUser();
}

class LoggedUserState extends UserState {
  const LoggedUserState({
    required this.user,
  });

  final CurrentUser user;

  @override
  List<Object?> get props => [user];
}
