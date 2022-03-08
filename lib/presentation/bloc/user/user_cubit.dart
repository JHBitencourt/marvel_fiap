import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:marvel/domain/entities/current_user.dart';
import 'package:marvel/domain/usecases/user/updated_user_state.dart';

part 'event/user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({
    required UpdatedUserState updatedUserState,
  })  : _updatedUserState = updatedUserState,
        super(const UnknownUser()) {
    _userUpdatesSubscription = _updatedUserState.updatedUserState().listen(
      (CurrentUser user) {
        if (!user.isEmpty) {
          _unregisterAuthenticatedUser();
          GetIt.I.registerSingleton<CurrentUser>(user);

          emit(LoggedUserState(user: user));
        }
      },
    );
  }

  final UpdatedUserState _updatedUserState;

  late StreamSubscription<CurrentUser> _userUpdatesSubscription;

  void _unregisterAuthenticatedUser() {
    if (GetIt.I.isRegistered<CurrentUser>()) {
      GetIt.I.unregister(instance: GetIt.I.get<CurrentUser>());
    }
  }

  @override
  Future<void> close() {
    _userUpdatesSubscription.cancel();
    return super.close();
  }
}
