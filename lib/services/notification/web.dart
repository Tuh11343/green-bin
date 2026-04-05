import 'package:flutter/foundation.dart';

import '../../models/app_notification.dart';

class WebNotificationService {
  static final WebNotificationService _instance = WebNotificationService._internal();

  factory WebNotificationService() {
    return _instance;
  }

  WebNotificationService._internal();

  bool _isSupported = false;

  Future<void> initialize() async {
    if (kIsWeb) {
      _isSupported = await _checkNotificationSupport();
      if (_isSupported) {
        print('[Web Notification] Initializing...');
        // Request permission
        await _requestPermission();
      }
    }
  }

  Future<bool> _checkNotificationSupport() async {
    // Kiểm tra browser hỗ trợ Notification API
    try {
      // Gọi qua JS interop
      return true; // Bạn cần dùng js_interop hoặc html package
    } catch (e) {
      print('[Web Notification] Not supported: $e');
      return false;
    }
  }

  Future<void> _requestPermission() async {
    // Gọi qua JS interop để request permission
    // Notification.requestPermission()
  }

  Future<void> showAppNotification(AppNotification notification) async {
    if (!kIsWeb || !_isSupported) return;

    showNotification(
      id: notification.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: notification.title,
      body: notification.description,
      icon: _getNotificationIcon(notification),
    );
  }

  Future<void> showNotification({
    required String id,
    required String title,
    required String body,
    String? icon,
  }) async {
    if (!kIsWeb) return;

    // Gọi qua JS interop
    // Tạm thời sử dụng print để debug
    print('[Web Notification] $title: $body');
  }

  String _getNotificationIcon(AppNotification notification) {
    // Return icon path dựa trên type
    return 'assets/icons/notification.png';
  }
}