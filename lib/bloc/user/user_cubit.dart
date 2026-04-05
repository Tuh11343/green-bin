import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/services/app_secure_storage.dart';

import '../../models/user.dart';
import '../../repositories/app_event_bus.dart';
import '../../repositories/app_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AppRepository _repo;
  final List<StreamSubscription> _subscriptions = [];

  UserCubit(this._repo) : super(const UserState()) {

    _subscriptions.add(
      AppEventBus().on<UserUpdatedEvent>().listen((event) {
        emit(state.copyWith(user: event.user, status: UserStatus.success));
      }),
    );

    _subscriptions.add(
      AppEventBus().on<RedeemSuccessEvent>().listen((event) {
        loadUser();
      }),
    );

  }

  @override
  Future<void> close() {
    // Rất quan trọng: Tắt loa khi không dùng Cubit này nữa để tránh Memory Leak
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    return super.close();
  }

  Future<void> loadUser() async {
    try {
      emit(state.copyWith(status: UserStatus.loading));

      final user = await _repo.user.getCurrentUser(forceRefresh: true);
      final token=await AppStorage.getToken();

      emit(state.copyWith(
        status: UserStatus.success,
        user: user,
        token: token,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserStatus.failure,
        message: e.toString(),
      ));
    }
  }

  Future<void> logOut() async{
    try{
      await _repo.user.logOut();
      emit(state.copyWith(user: null));
    }catch(e){
      emit(state.copyWith(
        status: UserStatus.failure,
        message: e.toString(),
      ));
    }
  }

}
