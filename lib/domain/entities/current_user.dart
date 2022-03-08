
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Provider { google, email }

class CurrentUser extends Equatable {
  const CurrentUser({
    required this.id,
    this.email,
    this.name,
    this.provider,
    this.user,
  });

  CurrentUser copyWith({
    String? id,
    String? name,
    String? email,
    Provider? provider,
    User? user,
  }) {
    return CurrentUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      provider: provider ?? this.provider,
      user: user ?? this.user,
    );
  }

  final String id;
  final String? email;
  final String? name;
  final Provider? provider;
  final User? user;

  /// Empty user which represents an unauthenticated user.
  static const empty = CurrentUser(
    email: '',
    id: '',
  );

  Future<String> token() async {
    if (user != null) return await user!.getIdToken();
    return '';
  }

  bool get isFromGoogleOrApple => provider == Provider.google;

  bool get isFromEmail => provider == Provider.email;

  bool get isEmpty => id.isEmpty;

  bool get hasName => name != null && name!.isNotEmpty;

  @override
  List<Object?> get props => [id, name, email, provider, user];
}
