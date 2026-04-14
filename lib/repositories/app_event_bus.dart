import 'dart:async';

import '../models/user.dart';

sealed class AppEvent {}

class UserUpdatedEvent extends AppEvent {
  final User user;

  UserUpdatedEvent(this.user);
}

class RedeemSuccessEvent extends AppEvent {
  final int rewardId;

  RedeemSuccessEvent(this.rewardId);
}

class CreateNewReportEvent extends AppEvent {
  CreateNewReportEvent();
}

class UserLogoutEvent extends AppEvent {
  UserLogoutEvent();
}

class NavigateToNotificationEvent extends AppEvent {
  final String? type;
  final String? reportId;
  final String? binId;

  NavigateToNotificationEvent({
    this.type,
    this.reportId,
    this.binId,
  });
}

class AppEventBus {
  static final AppEventBus _instance = AppEventBus._internal();

  factory AppEventBus() => _instance;

  AppEventBus._internal();

  final _controller = StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get stream => _controller.stream;

  // Helper lắng nghe theo loại event cụ thể
  Stream<T> on<T extends AppEvent>() => stream.where((e) => e is T).cast<T>();

  void emit(AppEvent event) => _controller.add(event);

  void dispose() => _controller.close();
}
