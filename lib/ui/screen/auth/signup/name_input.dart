part of 'sign_up_page.dart';

List<Widget> _buildNameInput() {
  return const <Widget>[
    SizedBox(height: 10.0),
    Label(name: 'Nome'),
    SizedBox(height: 4.0),
    _NameInput(),
  ];
}

class _NameInput extends StatelessWidget {
  const _NameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.name != current.name ||
          current.status == FormzStatus.submissionInProgress ||
          current.status == FormzStatus.submissionFailure,
      builder: (context, state) {
        return TextInputLab(
          enabled: state.status != FormzStatus.submissionInProgress,
          onChanged: (name) => context.read<SignUpCubit>().nameChanged(name),
          keyboardType: TextInputType.text,
          errorText: state.name.invalid ? state.name.error : null,
          hintText: 'Seu nome',
        );
      },
    );
  }
}
