import 'package:marvel/domain/entities/current_user.dart';

abstract class UpdatedUserState {
  Stream<CurrentUser> updatedUserState();
}
