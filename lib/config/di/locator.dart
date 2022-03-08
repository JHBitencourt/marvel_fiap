import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marvel/data/api/character_api.dart';
import 'package:marvel/domain/repository/character_repository.dart';
import 'package:marvel/domain/usecases/auth/current_user_state.dart';
import 'package:marvel/domain/usecases/auth/impl/current_user_state_impl.dart';
import 'package:marvel/domain/usecases/auth/impl/logout_impl.dart';
import 'package:marvel/domain/usecases/auth/impl/sign_in_with_email_impl.dart';
import 'package:marvel/domain/usecases/auth/impl/sign_in_with_google_impl.dart';
import 'package:marvel/domain/usecases/auth/impl/sign_up_with_email_impl.dart';
import 'package:marvel/domain/usecases/character/find_characters.dart';
import 'package:marvel/domain/usecases/character/impl/find_characters_impl.dart';
import 'package:marvel/domain/usecases/user/impl/updated_user_state_impl.dart';
import 'package:marvel/domain/usecases/auth/logout.dart';
import 'package:marvel/domain/usecases/auth/sign_in_with_email.dart';
import 'package:marvel/domain/usecases/auth/sign_in_with_google.dart';
import 'package:marvel/domain/usecases/auth/sign_up_with_email.dart';
import 'package:marvel/domain/usecases/user/updated_user_state.dart';

final getIt = GetIt.instance;

void initializeDependencyInjection() {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn.standard());
  _registerRepositories();
  _registerUseCases();
}

void _registerRepositories() {
  getIt.registerLazySingleton<CharacterRepository>(() => CharacterApi());
}

void _registerUseCases() {
  getIt.registerLazySingleton<CurrentUserState>(() => CurrentUserStateImpl());
  getIt.registerLazySingleton<SignInWithEmailAndPassword>(
    () => SignInWithEmailAndPasswordImpl(),
  );
  getIt.registerLazySingleton<SignInWithGoogle>(
    () => SignInWithGoogleImpl(),
  );
  getIt.registerLazySingleton<SignUpWithEmailAndPassword>(
    () => SignUpWithEmailAndPasswordImpl(),
  );
  getIt.registerLazySingleton<Logout>(() => LogoutImpl());
  getIt.registerLazySingleton<UpdatedUserState>(() => UpdatedUserStateImpl());
  getIt.registerLazySingleton<FindCharacters>(() => FindCharactersImpl());
}
