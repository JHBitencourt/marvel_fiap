import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:marvel/presentation/bloc/auth/authentication_bloc.dart';
import 'package:marvel/presentation/bloc/auth/sign_up_cubit.dart';
import 'package:marvel/ui/utils/colors.dart';
import 'package:marvel/ui/widgets/elevated_button_marvel.dart';
import 'package:marvel/ui/widgets/label_link.dart';
import 'package:marvel/ui/widgets/limit_width.dart';
import 'package:marvel/ui/widgets/snack_bar.dart';
import 'package:marvel/ui/widgets/text.dart';
import 'package:marvel/ui/widgets/text_input.dart';

part 'mail_input.dart';

part 'name_input.dart';

part 'password_input.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage();

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
        left: 24,
        right: 24,
      ),
      child: LimitWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Expanded(child: _SignUpForm()),
            _CreateButton(),
            _CancelButton(),
          ],
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: MarvelColors.background,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: body,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) {
    final form = BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const PageName(text: 'Crie seu perfil'),
            const SizedBox(height: 22),
            ..._buildMailInput(),
            ..._buildPasswordInput(),
            ..._buildNameInput(),
          ],
        );
      },
    );

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          showSnackBar(context,
              type: SnackBarType.error, text: state.message ?? 'null');
        }

        if (state.status.isSubmissionSuccess) {
          context.read<AuthenticationBloc>().add(const SignUpCompleted());
        }
      },
      child: form,
    );
  }
}

class _CreateButton extends StatefulWidget {
  const _CreateButton();

  @override
  _CreateButtonState createState() => _CreateButtonState();
}

class _CreateButtonState extends State<_CreateButton> {
  late ButtonLabAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ButtonLabAnimationController();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<SignUpCubit, SignUpState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == FormzStatus.submissionFailure) {
            _controller.reset();
          }

          return ElevatedButtonMarvel.normal(
            controller: _controller,
            brightness: Brightness.light,
            text: 'Criar perfil',
            onTap: state.status == FormzStatus.valid ||
                    state.status == FormzStatus.submissionFailure
                ? () {
                    context.read<SignUpCubit>().signUpFormSubmitted();
                  }
                : null,
          );
        },
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton();

  @override
  Widget build(BuildContext context) {
    return LabelLink(
      alignment: MainAxisAlignment.center,
      label: 'Cancelar',
      onTap: () {
        context.read<AuthenticationBloc>().add(const LogoutRequest());
      },
    );
  }
}
