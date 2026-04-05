import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/enums.dart';
import '../../models/app_notification.dart';
import '../../repositories/app_event_bus.dart';
import '../../repositories/app_repository.dart';
import '../../services/notification/notification_service.dart';
import '../../services/notification/notification_socket_service.dart';
import 'app_notification_state.dart';

class AppNotificationCubit extends Cubit<AppNotificationState> {
  final AppRepository _repo;
  final NotificationSocketService _socketService;
  final NotificationService _notificationService;
  late final StreamSubscription _sub;

  AppNotificationCubit({
    required AppRepository repo,
    required NotificationSocketService socketService,
    required NotificationService notificationService,
  })  : _repo = repo,
        _socketService = socketService,
        _notificationService = notificationService,
        super(const AppNotificationState()) {

    _sub = AppEventBus().on<CreateNewReportEvent>().listen((event) {
      getUserNotifications();
    });
  }

  void connectSocket({required int userId, required String token}) {
    try{

      if (state.isSocketConnected) {
        debugPrint('Socket đã kết nối, bỏ qua...');
        return;
      }

      // Cập nhật userId cho service trước khi connect
      _socketService.updateUserId(userId: userId);

      // Setup callback handlers
      _socketService.onReportCreated = _handleIncomingNotification;
      _socketService.onReportApproved = _handleIncomingNotification;
      _socketService.onBinFull = _handleBinFull;

      _socketService.connect(token: token);
    }catch(e){
      debugPrint('Loi connect socket:${e.toString()}');
    }
  }

  void disconnectSocket() {
    _socketService.disconnect();
    emit(const AppNotificationState());
  }

  void _handleIncomingNotification(AppNotification notification) async{
    try{
      final updated = [notification, ...state.notifications];
      emit(state.copyWith(notifications: updated));

      // 2. Hiển thị push notification (Android + iOS)
      _notificationService.showAppNotification(notification);
    }catch(e){
      debugPrint('lỗi handle incoming notification:${e.toString()}');
    }
  }

  void _handleBinFull(int binId, double fillLevel) {
    final notification = AppNotification(
      userId: _socketService.userId,
      title: 'Thùng rác sắp đầy',
      description:
          'Thùng rác #$binId đã đầy ${fillLevel.toStringAsFixed(0)}%. Cần xử lý ngay.',
      type: NotificationType.BinFullAlert,
      binId: binId,
      createdAt: DateTime.now(),
    );

    _handleIncomingNotification(notification);
  }

  Future<void> getUserNotifications() async {
    emit(state.copyWith(status: AppNotificationStatus.loading));
    try {
      final notifications =
          await _repo.appNotification.getUserAppNotifications();

      emit(state.copyWith(
        notifications: notifications,
        status: AppNotificationStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AppNotificationStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void markAsRead(int notificationId) async {
    try {
      await _repo.appNotification.markAsRead(notificationId: notificationId);
      final updatedNotifications = state.notifications.map((n) {
        return n.id == notificationId ? n.copyWith(isRead: true) : n;
      }).toList();
      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(
        status: AppNotificationStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void markAllAsRead() async {
    try {
      await _repo.appNotification.markAsAllRead();
      final updated =
          state.notifications.map((n) => n.copyWith(isRead: true)).toList();
      emit(state.copyWith(notifications: updated));
    } catch (e) {
      emit(state.copyWith(
        status: AppNotificationStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void deleteNotification(int notificationId) async{
    try{
      await _repo.appNotification.deleteUserNotificationById(id: notificationId);
      final updated =
      state.notifications.where((n) => n.id != notificationId).toList();
      emit(state.copyWith(notifications: updated));
    }catch(e){
      emit(state.copyWith(
        status: AppNotificationStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearAllNotifications() async{
    try{
      await _repo.appNotification.deleteUserNotifications();
      emit(state.copyWith(notifications: []));

    }catch(e){
      emit(state.copyWith(
        status: AppNotificationStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _sub.cancel();
    _socketService.disconnect();
    return super.close();
  }
}
