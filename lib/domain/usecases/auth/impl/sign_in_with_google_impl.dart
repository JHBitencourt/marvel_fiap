import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marvel/domain/exceptions/firebase_exception.dart';
import 'package:marvel/domain/usecases/auth/sign_in_with_google.dart';

class SignInWithGoogleImpl implements SignInWithGoogle {
  final _firebaseAuth = GetIt.I.get<FirebaseAuth>();
  final _googleSignIn = GetIt.I.get<GoogleSignIn>();

  @override
  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e, s) {
      _handleFirebaseSignInGoogleException(e, s);
    } catch (e) {
      throw const LogInWithGoogleFailure();
    }
  }

  void _handleFirebaseSignInGoogleException(
      FirebaseAuthException e, StackTrace s) {
    if (e.code == 'account-exists-with-different-credential') {
      throw const LogInWithGoogleFailure(
        message: 'Você já está cadastrado com o e-mail informado nesta conta.',
      );
    } else {
      throw const LogInWithGoogleFailure(
        message: 'Ocorreu um erro ao se cadastrar.',
      );
    }
  }
}
