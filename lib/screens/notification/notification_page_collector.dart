// lib/screens/notification/notification_page_collector.dart
import 'package:flutter/material.dart';

import '../../configs/font_size.dart';
import '../../models/app_notification.dart';
import '../../models/enums.dart';
import '../../widgets/custom_text.dart';

class NotificationPageCollector extends StatefulWidget {
  const NotificationPageCollector({Key? key}) : super(key: key);

  @override
  State<NotificationPageCollector> createState() =>
      _NotificationPageCollectorState();
}

class _NotificationPageCollectorState extends State<NotificationPageCollector> {
  int _selectedTab = 0; // 0: Tất cả, 1: Nhiệm vụ, 2: Báo cáo, 3: Thông báo

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Sử dụng AppNotification để tránh nhầm lẫn với class mặc định của Flutter
    final List<AppNotification> notifications = [
      AppNotification(
        id: 1,
        userId: 2,
        title: 'Nhiệm vụ mới: Thu gom tại Quận 1',
        description: 'Có 5 điểm tập kết rác chứa chất thải tại Quận 1 cần thu gom',
        type: NotificationType.NewAssignment,
        isRead: false,
        createdAt: DateTime.now(),
      ),
      AppNotification(
        id: 2,
        userId: 2,
        title: 'Báo cáo mới từ cộng đồng',
        description: 'Thùng rác tại 123 Nguyễn Huệ đầy, cần xử lý ngay',
        type: NotificationType.ReportUpdate,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: 3,
        userId: 2,
        title: 'Cập nhật lịch làm việc',
        description: 'Ca sáng: 07:00 - 12:00. Ca chiều: 13:00 - 18:00',
        type: NotificationType.SystemAlert,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AppNotification(
        id: 4,
        userId: 2,
        title: 'Thành tích tháng này',
        description: 'Bạn đã hoàn thành 120 ca thu gom. Bạn là nhân viên xuất sắc!',
        type: NotificationType.ReportUpdate,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];

    final tabs = ['Tất cả', 'Nhiệm vụ', 'Báo cáo', 'Thông báo'];
    final filteredNotifications = _getFilteredNotifications(notifications);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.notifications_active, size: 24, color: Colors.white),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'Thông Báo',
                  fontSize: AppFontSize.displaySmall,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                CustomText(
                  '${notifications.where((n) => !n.isRead).length} việc cần xử lý',
                  fontSize: AppFontSize.labelMedium,
                  color: Colors.white70,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.white),
            onPressed: () {
              // Xử lý đánh dấu tất cả đã đọc
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ==================== TAB SELECTION ====================
          _buildTabSelector(tabs, isDarkMode),

          // ==================== LIST CONTENT ====================
          Expanded(
            child: filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: filteredNotifications.length,
              itemBuilder: (context, index) => _buildNotificationCard(
                context,
                filteredNotifications[index],
                isDarkMode,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector(List<String> tabs, bool isDarkMode) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          children: List.generate(
            tabs.length,
                (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: CustomText(
                  tabs[index],
                  fontSize: AppFontSize.labelLarge,
                  fontWeight: _selectedTab == index ? FontWeight.bold : FontWeight.normal,
                  color: _selectedTab == index
                      ? Colors.white
                      : (isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                ),
                selected: _selectedTab == index,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedTab = index);
                },
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                // checkmarkColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 70, color: Colors.grey[400]),
          const SizedBox(height: 16),
          CustomText(
            'Hộp thư trống',
            fontSize: AppFontSize.bodyLarge,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  /// ==================== NOTIFICATION CARD ====================
  Widget _buildNotificationCard(
      BuildContext context,
      AppNotification notification,
      bool isDarkMode,
      ) {
    // Xác định màu sắc và ưu tiên dựa trên loại nhiệm vụ
    Color getCategoryColor() {
      switch (notification.type) {
        case NotificationType.NewAssignment: return Colors.purple;
        case NotificationType.ReportUpdate: return Colors.orange;
        case NotificationType.SystemAlert: return Colors.blueGrey;
        default: return Colors.blue;
      }
    }

    String getPriorityLabel() {
      switch (notification.type) {
        case NotificationType.NewAssignment: return 'NHIỆM VỤ';
        case NotificationType.ReportUpdate: return 'KHẨN CẤP';
        default: return 'THÔNG TIN';
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: notification.isRead ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: notification.isRead
              ? (isDarkMode ? Colors.grey[800]! : Colors.grey[200]!)
              : getCategoryColor().withOpacity(0.3),
        ),
      ),
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Xử lý khi nhấn vào thông báo (mở chi tiết nhiệm vụ)
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trạng thái Icon
              _buildLeadingIcon(notification, getCategoryColor()),
              const SizedBox(width: 12),

              // Nội dung văn bản
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: getCategoryColor().withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomText(
                            getPriorityLabel(),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: getCategoryColor(),
                          ),
                        ),
                        if (!notification.isRead)
                          const CircleAvatar(radius: 4, backgroundColor: Colors.red),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      notification.title,
                      fontSize: AppFontSize.bodyMedium, // 14.0
                      fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      notification.description,
                      fontSize: AppFontSize.bodySmall, // 12.0
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.access_time_filled, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        CustomText(
                          _formatTime(notification.createdAt),
                          fontSize: AppFontSize.labelSmall,
                          color: Colors.grey[500],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(AppNotification notification, Color color) {
    IconData icon;
    switch (notification.type) {
      case NotificationType.NewAssignment: icon = Icons.assignment_turned_in; break;
      case NotificationType.ReportUpdate: icon = Icons.report_problem; break;
      case NotificationType.SystemAlert: icon = Icons.campaign; break;
      default: icon = Icons.notifications;
    }

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  /// ==================== LOGIC HELPERS ====================
  List<AppNotification> _getFilteredNotifications(List<AppNotification> notifications) {
    if (_selectedTab == 0) return notifications;
    if (_selectedTab == 1) {
      return notifications.where((n) => n.type == NotificationType.NewAssignment).toList();
    }
    if (_selectedTab == 2) {
      return notifications.where((n) => n.type == NotificationType.ReportUpdate).toList();
    }
    if (_selectedTab == 3) {
      return notifications.where((n) => n.type == NotificationType.SystemAlert).toList();
    }
    return notifications;
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}