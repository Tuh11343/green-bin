import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../models/app_notification.dart';
import '../../repositories/app_event_bus.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Android setup
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS setup
    const DarwinInitializationSettings iOSSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request iOS permissions
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Request Android permissions (for Android 13+)
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isUrgent = false,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'notification_channel',
      'App Notifications',
      channelDescription: 'Thông báo từ ứng dụng',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> showAppNotification(AppNotification notification) async {

    final int safeId = notification.id ??
        (DateTime.now().millisecondsSinceEpoch % 1000000000);

    await showNotification(
      id: safeId,
      title: notification.title,
      body: notification.description,
      payload: _buildPayload(notification),
      isUrgent: _isUrgentNotification(notification),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'scheduled_notifications',
      'Scheduled Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  String _buildPayload(AppNotification notification) {
    return 'type:${notification.type}|'
        'reportId:${notification.reportId}|'
        'binId:${notification.binId}';
  }

  bool _isUrgentNotification(AppNotification notification) {
    return notification.type.toString().contains('BinFullAlert') ||
        notification.type.toString().contains('Urgent');
  }

  // Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      debugPrint('[Notification] Tapped with payload: $payload');
      // Tương lai sẽ xử lý notification navigation chỗ này mình nghĩ tạm thời nên để /home xong rồi chuyển tab sang notification

      final map = <String, String>{};
      for (final part in payload.split('|')) {
        final kv = part.split(':');
        if (kv.length == 2) map[kv[0]] = kv[1];
      }

      AppEventBus().emit(NavigateToNotificationEvent(
        type: map['type'],
        reportId: map['reportId'],
        binId: map['binId'],
      ));
    }
  }

  // iOS callback
  static void _onDidReceiveLocalNotification(
      int id,
      String? title,
      String? body,
      String? payload,
      ) {
    debugPrint('[iOS Notification] id: $id, title: $title, body: $body');
  }
}