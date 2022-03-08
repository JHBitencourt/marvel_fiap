import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:marvel/domain/exceptions/firebase_exception.dart';
import 'package:marvel/domain/usecases/auth/sign_up_with_email.dart';

class SignUpWithEmailAndPasswordImpl implements SignUpWithEmailAndPassword {
  final _firebaseAuth = GetIt.I.get<FirebaseAuth>();

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credentials.user?.updateDisplayName(name);
    } on FirebaseAuthException catch (e, s) {
      _handleFirebaseSignUpException(e, s);
    } on Exception catch (_) {
      throw const SignUpFailure(
        message: 'Ocorreu um erro ao se cadastrar.',
      );
    }
  }

  void _handleFirebaseSignUpException(FirebaseAuthException e, StackTrace s) {
    if (e.code == 'weak-password') {
      throw const SignUpFailure(message: 'A senha informada é muito fraca.');
    } else if (e.code == 'email-already-in-use') {
      throw const SignUpFailure(
          message: 'O e-mail informado já está cadastrado.');
    } else if (e.code == 'invalid-email') {
      throw const SignUpFailure(
          message: 'O domínio do e-mail informado é inválido.');
    } else {
      throw const SignUpFailure(
        message: 'Ocorreu um erro ao se cadastrar.',
      );
    }
  }
}
