import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marvel/presentation/bloc/auth/login_cubit.dart';
import 'package:marvel/ui/utils/colors.dart';
import 'package:marvel/ui/utils/routes.dart';
import 'package:marvel/ui/widgets/elevated_button_marvel.dart';
import 'package:marvel/ui/widgets/label_link.dart';
import 'package:marvel/ui/widgets/limit_width.dart';
import 'package:marvel/ui/widgets/screen_block.dart';
import 'package:marvel/ui/widgets/snack_bar.dart';
import 'package:marvel/ui/widgets/text.dart';
import 'package:marvel/ui/widgets/text_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage();

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
          children: [
            const SizedBox(height: 12.0),
            Center(
              child: Text(
                'Marvel FIAP',
                style: GoogleFonts.bangers().copyWith(
                  color: MarvelColors.white,
                  fontSize: 38,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoogleSignIn(
                    onTap: () {
                      context.read<LoginCubit>().logInWithGoogle();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const _SignInForm(),
                  const _LoginButton(),
                  const SizedBox(height: 22),
                  LabelLink(
                    alignment: MainAxisAlignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    label: 'Criar uma nova conta',
                    onTap: () {
                      Navigator.of(context).pushNamed(signUpRoute);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final scaffoldBody = Scaffold(
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
    );

    final builder = BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final showOnlyBody = state.isEmailProvider ||
            (state.status != FormzStatus.submissionInProgress &&
                state.status != FormzStatus.submissionSuccess);

        if (showOnlyBody) return scaffoldBody;

        return ScreenBlock(child: scaffoldBody, loading: true);
      },
    );

    return SafeArea(
      child: Material(child: builder),
    );
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context) {
    final form = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(height: 10.0),
        Label(name: 'E-mail'),
        SizedBox(height: 4.0),
        _EmailInput(),
        SizedBox(height: 10.0),
        Label(name: 'Senha'),
        SizedBox(height: 4.0),
        _PasswordInput(),
        SizedBox(height: 16.0),
      ],
    );

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure && state.hasMessage) {
          showSnackBar(
            context,
            type: SnackBarType.error,
            text: state.message ?? 'null',
          );
        }
      },
      child: form,
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          current.status == FormzStatus.submissionInProgress ||
          current.status == FormzStatus.submissionFailure,
      builder: (context, state) {
        return TextInputLab(
          enabled: state.status != FormzStatus.submissionInProgress,
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          hintText: 'nome@email.com',
          errorText: state.email.invalid ? state.email.error : null,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          current.status == FormzStatus.submissionInProgress ||
          current.status == FormzStatus.submissionFailure,
      builder: (context, state) {
        return TextInputLab(
          enabled: state.status != FormzStatus.submissionInProgress,
          onChanged: (pass) => context.read<LoginCubit>().passwordChanged(pass),
          keyboardType: TextInputType.visiblePassword,
          isPassword: true,
          hintText: 'Digite uma senha de 8 dígitos',
          errorText: state.password.invalid ? state.password.error : null,
        );
      },
    );
  }
}

class _LoginButton extends StatefulWidget {
  const _LoginButton();

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  late ButtonLabAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ButtonLabAnimationController();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == FormzStatus.submissionFailure) {
            _controller.reset();
          }

          return ElevatedButtonMarvel.normal(
            controller: _controller,
            brightness: Brightness.light,
            text: 'Entrar',
            onTap: state.status == FormzStatus.valid ||
                    state.status == FormzStatus.submissionFailure
                ? () {
                    context.read<LoginCubit>().logInWithCredentials();
                  }
                : null,
          );
        },
      ),
    );
  }
}
