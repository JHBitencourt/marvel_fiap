import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:marvel/domain/exceptions/firebase_exception.dart';
import 'package:marvel/domain/usecases/auth/sign_in_with_email.dart';

class SignInWithEmailAndPasswordImpl extends SignInWithEmailAndPassword {
  final _firebaseAuth = GetIt.I.get<FirebaseAuth>();

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e, s) {
      _handleFirebaseLoginWithCredentialsException(e, s);
    } on Exception catch (_) {
      throw const LogInWithEmailAndPasswordFailure(
        message: 'Ocorreu um erro ao realizar o login.',
      );
    }
  }

  void _handleFirebaseLoginWithCredentialsException(
      FirebaseAuthException e, StackTrace s) {
    if (e.code == 'user-disabled') {
      throw const LogInWithEmailAndPasswordFailure(
          message: 'O usuário informado está desabilitado.');
    } else if (e.code == 'user-not-found') {
      throw const LogInWithEmailAndPasswordFailure(
          message: 'O usuário informado não está cadastrado.');
    } else if (e.code == 'invalid-email') {
      throw const LogInWithEmailAndPasswordFailure(
          message: 'O domínio do e-mail informado é inválido.');
    } else if (e.code == 'wrong-password') {
      throw const LogInWithEmailAndPasswordFailure(
          message: 'A senha informada está incorreta.');
    } else {
      throw const LogInWithEmailAndPasswordFailure(
        message: 'Ocorreu um erro ao realizar o login.',
      );
    }
  }
}
