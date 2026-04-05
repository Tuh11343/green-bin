import 'package:equatable/equatable.dart';

import '../../models/app_tab.dart';

enum AppStatus { initial, loading, success, failure }

class AppState extends Equatable {
  // final int currentIndex;
  final List<AppTab> tabs;
  final bool showBottomBar;

  // final UserRole? role;
  final AppStatus status;
  final String? errorMessage;

  const AppState({
    // this.currentIndex = 0,
    this.tabs = const [],
    this.showBottomBar = true,
    // this.role,
    this.status = AppStatus.initial,
    this.errorMessage,
  });

  AppState copyWith({
    // int? currentIndex,
    List<AppTab>? tabs,
    bool? showBottomBar,
    // UserRole? role,
    AppStatus? status,
    String? errorMessage,
  }) {
    return AppState(
      // currentIndex: currentIndex ?? this.currentIndex,
      tabs: tabs ?? this.tabs,
      showBottomBar: showBottomBar ?? this.showBottomBar,
      // role: role ?? this.role,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [tabs, showBottomBar, status, errorMessage]; //role,index
}
