import 'package:marvel/domain/entities/current_user.dart';

abstract class CurrentUserState {
  Stream<CurrentUser> currentUserState();
}
