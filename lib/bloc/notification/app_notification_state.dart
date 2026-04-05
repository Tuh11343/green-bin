import 'package:equatable/equatable.dart';
import '../../models/app_notification.dart';

enum AppNotificationStatus { initial, loading, loaded, error }

class AppNotificationState extends Equatable {
  final List<AppNotification> notifications;
  final AppNotificationStatus status;
  final String? errorMessage;
  final bool isSocketConnected;

  const AppNotificationState({
    this.notifications = const [],
    this.status = AppNotificationStatus.initial,
    this.errorMessage,
    this.isSocketConnected = false,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  AppNotificationState copyWith({
    List<AppNotification>? notifications,
    AppNotificationStatus? status,
    String? errorMessage,
    bool? isSocketConnected,
  }) {
    return AppNotificationState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      errorMessage: errorMessage,
      isSocketConnected: isSocketConnected ?? this.isSocketConnected,
    );
  }

  @override
  List<Object?> get props => [notifications, status, errorMessage,isSocketConnected];
}