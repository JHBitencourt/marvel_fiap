import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:marvel/domain/exceptions/firebase_exception.dart';
import 'package:marvel/domain/usecases/auth/sign_in_with_email.dart';
import 'package:marvel/domain/usecases/auth/sign_in_with_google.dart';
import 'package:marvel/presentation/bloc/formz/email_formz.dart';
import 'package:marvel/presentation/bloc/formz/password_formz.dart';

part 'event/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required SignInWithEmailAndPassword signInEmail,
    required SignInWithGoogle signInGoogle,
  })  : _signInEmail = signInEmail,
        _signInGoogle = signInGoogle,
        super(const LoginState());

  final SignInWithEmailAndPassword _signInEmail;
  final SignInWithGoogle _signInGoogle;

  void resetState() {
    emit(const LoginState());
  }

  void resetFormzStatusFailure() {
    emit(state.copyWith(status: FormzStatus.submissionFailure));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      isEmailProvider: false,
    ));
    try {
      await _signInGoogle.signInWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> logInWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
      isEmailProvider: true,
    ));
    try {
      await _signInEmail.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
