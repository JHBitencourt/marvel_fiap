import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:marvel/domain/entities/current_user.dart';
import 'package:marvel/domain/extensions/user_extension.dart';
import 'package:marvel/domain/usecases/user/updated_user_state.dart';

class UpdatedUserStateImpl implements UpdatedUserState {
  final _firebaseAuth = GetIt.I.get<FirebaseAuth>();

  @override
  Stream<CurrentUser> updatedUserState() =>
      _firebaseAuth.userChanges().map((User? event) {
        if (event == null) return CurrentUser.empty;
        return event.toCurrentUser;
      });
}
