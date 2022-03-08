import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marvel/domain/exceptions/firebase_exception.dart';
import 'package:marvel/domain/usecases/auth/logout.dart';

class LogoutImpl implements Logout {
  final _firebaseAuth = GetIt.I.get<FirebaseAuth>();
  final _googleSignIn = GetIt.I.get<GoogleSignIn>();

  @override
  Future<void> logout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}
