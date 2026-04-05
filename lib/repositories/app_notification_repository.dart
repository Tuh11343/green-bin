import '../../services/api/app_api.dart';
import '../configs/exception.dart';
import '../models/app_notification.dart';

abstract class IAppNotificationRepository {
  Future<List<AppNotification>> getUserAppNotifications();

  Future<void> markAsRead({required int notificationId});

  Future<void> markAsAllRead();

  Future<void> deleteUserNotificationById({required int id});

  Future<void> deleteUserNotifications();
}

class AppNotificationRepository implements IAppNotificationRepository {
  final _api = AppApi().appNotification;

  @override
  Future<List<AppNotification>> getUserAppNotifications() async {
    try {
      return await _api.getUserNotifications();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi lấy tất cả AppNotification");
    }
  }

  @override
  Future<void> markAsAllRead() async {
    try {
      await _api.markAsAllRead();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi mark as all read AppNotification");
    }
  }

  @override
  Future<void> markAsRead({required int notificationId}) async {
    try {
      await _api.markAsRead(notificationId: notificationId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi mark as read AppNotification");
    }
  }

  @override
  Future<void> deleteUserNotificationById({required int id}) async {
    try {
      await _api.deleteUserNotificationById(id: id);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi delete user notification by id");
    }
  }

  @override
  Future<void> deleteUserNotifications() async {
    try {
      await _api.deleteUserNotifications();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi delete user notifications");
    }
  }
}
