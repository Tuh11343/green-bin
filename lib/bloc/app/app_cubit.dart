import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configs/exception.dart';
import '../../models/app_tab.dart';
import '../../models/enums.dart';
import '../../repositories/app_repository.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final AppRepository _repo;

  AppCubit(this._repo) : super(const AppState());

  void init() async {
    try {
      final user = await _repo.user.getCurrentUser(forceRefresh: true);

      if (user == null) {
        return;
      }

      final tabs = _getTabsByRole(user.role);

      emit(
        state.copyWith(
          // role: role,
          tabs: tabs,
          // currentIndex: 0,
          showBottomBar: true,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(
        status: AppStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // void changeTab(int index) {
  //   emit(state.copyWith(currentIndex: index));
  // }

  void toggleBottomBar(bool isVisible) {
    emit(state.copyWith(showBottomBar: isVisible));
  }

  // void reset() {
  //   emit(const AppState());
  // }

  List<AppTab> _getTabsByRole(UserRole role) {
    switch (role) {
      case UserRole.resident:
        return const [
          AppTab(label: 'Trang chủ', icon: Icons.home, route: '/home'),
          AppTab(label: 'Thông báo', icon: Icons.notifications, route: '/userNotification'),
          AppTab(label: 'Phần thưởng', icon: Icons.redeem, route: '/reportHistory'),
          AppTab(label: 'Cá nhân', icon: Icons.person, route: '/profile'),
        ];

      case UserRole.collector:
        return const [
          AppTab(
              label: 'Trang chủ', icon: Icons.home, route: '/collector-home'),
          AppTab(label: 'Nhiệm vụ', icon: Icons.task, route: '/tasks'),
          AppTab(label: 'Cá nhân', icon: Icons.person, route: '/profile'),
        ];

      case UserRole.admin:
        return const [
          AppTab(label: 'Dashboard', icon: Icons.dashboard, route: '/admin'),
          AppTab(label: 'Người dùng', icon: Icons.people, route: '/users'),
          AppTab(label: 'Báo cáo', icon: Icons.report, route: '/reports'),
        ];
    }
  }
}
