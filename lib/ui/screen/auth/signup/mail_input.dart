part of 'sign_up_page.dart';

List<Widget> _buildMailInput() {
  return const <Widget>[
    SizedBox(height: 10.0),
    Label(name: 'E-mail'),
    SizedBox(height: 4.0),
    _EmailInput(),
  ];
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          current.status == FormzStatus.submissionInProgress ||
          current.status == FormzStatus.submissionFailure,
      builder: (context, state) {
        return TextInputLab(
          enabled: state.status != FormzStatus.submissionInProgress,
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          hintText: 'nome@email.com',
          errorText: state.email.invalid ? state.email.error : null,
        );
      },
    );
  }
}
