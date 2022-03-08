part of '../login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.isEmailProvider = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.message,
  });

  final bool isEmailProvider;
  final Email email;
  final Password password;
  final FormzStatus status;
  final String? message;

  LoginState copyWith({
    bool? isEmailProvider,
    Email? email,
    Password? password,
    FormzStatus? status,
    String? message,
  }) {
    return LoginState(
      isEmailProvider: isEmailProvider ?? this.isEmailProvider,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message,
    );
  }

  bool get hasMessage => message != null && message!.isNotEmpty;

  @override
  List<Object?> get props => [email, password, status, message];
}
