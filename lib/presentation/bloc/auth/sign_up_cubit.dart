import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:marvel/domain/exceptions/firebase_exception.dart';
import 'package:marvel/domain/usecases/auth/sign_up_with_email.dart';
import 'package:marvel/presentation/bloc/formz/email_formz.dart';
import 'package:marvel/presentation/bloc/formz/name_formz.dart';
import 'package:marvel/presentation/bloc/formz/password_formz.dart';

part 'event/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required SignUpWithEmailAndPassword signUpEmail,
  })  : _signUpEmail = signUpEmail,
        super(const SignUpState());

  final SignUpWithEmailAndPassword _signUpEmail;

  void nameChanged(String value) {
    final name = Name.dirty(value);

    emit(state.copyWith(
      name: name,
      status: Formz.validate([
        name,
        state.email,
        state.password,
        state.confirmedPassword,
      ]),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        state.name,
        email,
        state.password,
        state.confirmedPassword,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      status: Formz.validate([
        state.name,
        state.email,
        password,
        confirmedPassword,
      ]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      status: Formz.validate([
        state.name,
        state.email,
        state.password,
        confirmedPassword,
      ]),
    ));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      await _signUpEmail.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
        name: state.name.value,
      );

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on SignUpFailure catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        message: 'Ocorreu um erro ao se comunicar com o servidor.',
      ));
    }
  }
}
