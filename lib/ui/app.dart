import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:marvel/domain/repository/character_repository.dart';
import 'package:marvel/domain/usecases/auth/current_user_state.dart';
import 'package:marvel/domain/usecases/auth/logout.dart';
import 'package:marvel/domain/usecases/auth/sign_in_with_email.dart';
import 'package:marvel/domain/usecases/auth/sign_in_with_google.dart';
import 'package:marvel/domain/usecases/auth/sign_up_with_email.dart';
import 'package:marvel/domain/usecases/user/updated_user_state.dart';
import 'package:marvel/presentation/bloc/auth/authentication_bloc.dart';
import 'package:marvel/presentation/bloc/auth/login_cubit.dart';
import 'package:marvel/presentation/bloc/auth/sign_up_cubit.dart';
import 'package:marvel/presentation/bloc/character/character_bloc.dart';
import 'package:marvel/presentation/bloc/user/user_cubit.dart';
import 'package:marvel/ui/screen/auth/home_page.dart';
import 'package:marvel/ui/screen/auth/login_page.dart';
import 'package:marvel/ui/screen/auth/signup/sign_up_page.dart';
import 'package:marvel/ui/screen/auth/splash_page.dart';
import 'package:marvel/ui/utils/routes.dart';
import 'package:marvel/ui/utils/theme.dart';

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc(
            currentUserState: GetIt.I.get<CurrentUserState>(),
            logout: GetIt.I.get<Logout>(),
          ),
        ),
        BlocProvider<LoginCubit>(
          create: (BuildContext context) => LoginCubit(
            signInEmail: GetIt.I.get<SignInWithEmailAndPassword>(),
            signInGoogle: GetIt.I.get<SignInWithGoogle>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'hellow',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        theme: MarvelTheme.applicationTheme(context),
        initialRoute: initialRoute,
        onGenerateRoute: _onGenerateRoutes,
      ),
    );
  }

  Route<dynamic>? _onGenerateRoutes(RouteSettings settings) {
    if (settings.name == initialRoute) return _initialRouteGenerator(settings);

    if (settings.name == signUpRoute) return _signUpRoute(settings);

    // if (settings.name == charactersRoute) return _activityRoute(settings);

    // if (settings.name == characterDetailsRoute) return _termsRoute(settings);

    return null;
  }

  Route _initialRouteGenerator(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      settings: const RouteSettings(name: initialRoute),
      builder: (BuildContext context) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticatedState) {
              schedulePopAll(context);

              return MultiBlocProvider(
                providers: [
                  BlocProvider<CharacterBloc>(
                    create: (BuildContext context) => CharacterBloc(
                      characterRepository: GetIt.I.get<CharacterRepository>(),
                    ),
                  ),
                  BlocProvider<UserCubit>(
                    create: (BuildContext context) => UserCubit(
                      updatedUserState: GetIt.I.get<UpdatedUserState>(),
                    ),
                  ),
                ],
                child: const HomePage(),
              );
            }

            if (state is UnauthenticatedState) {
              return const LoginPage();
            }

            return const SplashPage();
          },
        );
      },
    );
  }

  Route _signUpRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      settings: const RouteSettings(name: signUpRoute),
      builder: (BuildContext context) {
        return _signUpRouteBuilder(false);
      },
    );
  }

  Widget _signUpRouteBuilder(bool alreadyAuthenticated) {
    return BlocProvider<SignUpCubit>(
      create: (BuildContext context) {
        return SignUpCubit(
          signUpEmail: GetIt.I.get<SignUpWithEmailAndPassword>(),
        );
      },
      child: const SignUpPage(),
    );
  }
}
