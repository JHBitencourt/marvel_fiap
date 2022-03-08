part of 'sign_up_page.dart';

List<Widget> _buildPasswordInput() {
  return const <Widget>[
    SizedBox(height: 10.0),
    Label(name: 'Senha'),
    SizedBox(height: 4.0),
    _PasswordInput(),
    SizedBox(height: 10.0),
    _ConfirmedPasswordInput(),
  ];
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          current.status == FormzStatus.submissionInProgress ||
          current.status == FormzStatus.submissionFailure,
      builder: (context, state) {
        return TextInputLab(
          enabled: state.status != FormzStatus.submissionInProgress,
          onChanged: (pass) =>
              context.read<SignUpCubit>().passwordChanged(pass),
          keyboardType: TextInputType.visiblePassword,
          isPassword: true,
          hintText: 'Digite uma senha de 8 dígitos',
          errorText: state.password.invalid ? state.password.error : null,
        );
      },
    );
  }
}

class _ConfirmedPasswordInput extends StatelessWidget {
  const _ConfirmedPasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword ||
          current.status == FormzStatus.submissionInProgress ||
          current.status == FormzStatus.submissionFailure,
      builder: (context, state) {
        return TextInputLab(
          enabled: state.status != FormzStatus.submissionInProgress,
          onChanged: (pass) =>
              context.read<SignUpCubit>().confirmedPasswordChanged(pass),
          keyboardType: TextInputType.visiblePassword,
          isPassword: true,
          hintText: 'Confirme a senha',
          errorText: state.confirmedPassword.invalid
              ? state.confirmedPassword.error
              : null,
        );
      },
    );
  }
}
