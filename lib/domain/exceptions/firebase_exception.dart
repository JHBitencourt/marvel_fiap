/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {
  const LogInWithGoogleFailure({this.message = ''});

  final String message;
}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure({this.message = ''});

  final String message;
}

/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {
  const SignUpFailure({this.message = ''});

  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}