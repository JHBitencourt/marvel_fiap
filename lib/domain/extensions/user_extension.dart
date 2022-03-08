import 'package:firebase_auth/firebase_auth.dart';
import 'package:marvel/domain/entities/current_user.dart';

const providerGoogleId = 'google.com';

extension UserExtension on User {
  CurrentUser get toCurrentUser {
    Provider provider = Provider.google;
    for (final info in providerData) {
      if (info.providerId == providerGoogleId) {
        provider = Provider.google;
      } else {
        provider = Provider.email;
      }
    }

    return CurrentUser(
      id: uid,
      email: email,
      name: displayName,
      provider: provider,
      user: this,
    );
  }
}
