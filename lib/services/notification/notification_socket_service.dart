import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../models/enums.dart';
import '../../models/app_notification.dart';

typedef NotificationCallback = void Function(AppNotification notification);
typedef BinFullCallback = void Function(int binId, double fillLevel);

class NotificationSocketService {
  Socket? _socket;
  final String _baseUrl;
  late int userId;
  bool _isConnected = false;

  NotificationCallback? onReportCreated;
  NotificationCallback? onReportApproved;
  BinFullCallback? onBinFull;

  NotificationSocketService({
    required String baseUrl,
  }) : _baseUrl = baseUrl;

  void updateUserId({required int userId}) {
    this.userId = userId;
  }

  void connect({required String token}) {
    if (_isConnected || _socket?.connected == true) {
      debugPrint('⚠️ Socket already connected or connecting');
      return;
    }

    debugPrint('Đăng ký socket');

    _socket = io(
      _baseUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket!.onConnect((_) {
      _isConnected = true;
      debugPrint('[Socket] Connected — userId: $userId');
      _socket!.emit('join_room', userId);
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      debugPrint('[Socket] Disconnected');
    });

    _socket!.onConnectError((err) {
      debugPrint('[Socket] Connect error: $err');
    });

    _registerEvents();
  }

  void _registerEvents() {
    _socket!.onAny((event, data) {
      debugPrint('===> [SOCKET DEBUG] Event: $event, Data: $data');
    });

    _socket!.on('report:created', (data) {
      debugPrint('[Socket] report:created → $data');

      final notification = AppNotification(
        userId: userId,
        title: data['title'] as String? ?? 'Tạo báo cáo thành công',
        description: data['description'] as String? ?? '',
        type: NotificationType.ReportUpdate,
        reportId: data['reportId'] as int?,
        id: data['id'] as int?,
        createdAt: data['createdAt'] != null
            ? DateTime.tryParse(data['createdAt'])
            : DateTime.now(),
      );

      onReportCreated?.call(notification);
    });

    _socket!.on('report:approved', (data) {
      debugPrint('[Socket] report:approved → $data');

      final notification = AppNotification(
        userId: userId,
        title: 'Báo cáo đã được duyệt',
        description: 'Báo cáo #${data['reportId']} của bạn đã được xử lý.',
        type: NotificationType.ReportUpdate,
        reportId: data['reportId'] as int?,
        createdAt: DateTime.now(),
      );

      onReportApproved?.call(notification);
    });

    _socket!.on('bin:full', (data) {
      debugPrint('[Socket] bin:full → $data');

      final binId = data['binId'] as int?;
      final fillLevel = (data['fillLevel'] as num?)?.toDouble() ?? 0.0;

      if (binId != null) {
        onBinFull?.call(binId, fillLevel);
      }
    });
  }

  Future<void> disconnect() async {
    if (_socket != null) {
      // Remove all listeners
      _socket!.clearListeners();

      // Disconnect
      _socket!.disconnect();

      // Dispose
      _socket!.dispose();

      _socket = null;
      _isConnected = false;

      debugPrint('[Socket] Properly disconnected & disposed');
    }
  }

  void clearCallbacks() {
    onReportCreated = null;
    onReportApproved = null;
    onBinFull = null;
  }

  bool get isConnected => _isConnected && _socket?.connected == true;
}