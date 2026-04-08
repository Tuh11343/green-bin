import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:greenbin/bloc/notification/app_notification_cubit.dart';
import 'package:greenbin/bloc/notification/app_notification_state.dart';
import 'package:greenbin/configs/app_color.dart';
import 'package:greenbin/configs/font_size.dart';
import 'package:greenbin/models/app_notification.dart';
import 'package:greenbin/models/enums.dart';
import 'package:greenbin/utils/helper.dart';

import '../../widgets/custom_text.dart';

class UserNotificationPage extends StatefulWidget {
  const UserNotificationPage({Key? key}) : super(key: key);

  @override
  State<UserNotificationPage> createState() => _UserNotificationPageState();
}

class _UserNotificationPageState extends State<UserNotificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<AppNotificationCubit>().getUserNotifications();
  }

  IconData _getIconByType(NotificationType type) {
    switch (type) {
      case NotificationType.ReportCreated:
        return Icons.assignment;
      case NotificationType.BinFullAlert:
        return Icons.warning_amber;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorByType(NotificationType type) {
    switch (type) {
      case NotificationType.ReportCreated:
        return AppColors.blueInfo;
      case NotificationType.BinFullAlert:
        return AppColors.redDanger;
      default:
        return AppColors.textGrey;
    }
  }

  String _getLabelByType(NotificationType type) {
    switch (type) {
      case NotificationType.ReportCreated:
        return 'Báo cáo mới';
      case NotificationType.BinFullAlert:
        return 'Thùng rác đầy';
      default:
        return 'Thông báo';
    }
  }

  Widget _buildNotificationItem(AppNotification notification) {
    final Color typeColor = _getColorByType(notification.type);
    final IconData typeIcon = _getIconByType(notification.type);
    final String typeLabel = _getLabelByType(notification.type);
    final String timeLabel = AppHelper.formatTimeAgo(notification.createdAt);
    final AppNotificationCubit cubit = context.read<AppNotificationCubit>();

    return Slidable(
      key: ValueKey(notification.id),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (_) => cubit.deleteNotification(notification.id!),
            backgroundColor: AppColors.redDanger,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Xóa',
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(12),
            ),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => cubit.markAsRead(notification.id!),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon bên trái
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(typeIcon, color: typeColor, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Nội dung giữa
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: AppFontSize.labelSmall,
                            fontWeight: FontWeight.w600,
                            color: typeColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: AppFontSize.bodyMedium,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.description,
                          style: const TextStyle(
                            fontSize: AppFontSize.bodySmall,
                            color: AppColors.textGrey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          timeLabel,
                          style: const TextStyle(
                            fontSize: AppFontSize.labelSmall,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Chấm tròn trạng thái chưa đọc bên phải
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          notification.isRead ? Colors.transparent : typeColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.lightCard,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppColors.textGrey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const CustomText(
            'Không có thông báo',
            fontSize: AppFontSize.bodyMedium,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          CustomText(
            'Các thông báo sẽ xuất hiện tại đây',
            fontSize: AppFontSize.bodySmall,
            color: AppColors.textGrey.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.redDanger.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const CustomText(
            'Có lỗi xảy ra',
            fontSize: AppFontSize.bodyMedium,
            color: AppColors.redDanger,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          CustomText(
            errorMessage ?? 'Không thể tải thông báo',
            fontSize: AppFontSize.bodySmall,
            color: AppColors.textGrey,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<AppNotificationCubit>().getUserNotifications(),
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<AppNotification> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: context.read<AppNotificationCubit>().getUserNotifications,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationItem(notifications[index]);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    int unreadCount,
    bool hasNotifications,
    AppNotificationCubit cubit,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.lightCard,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông báo',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: AppFontSize.headlineSmall,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (unreadCount > 0)
            CustomText(
              '$unreadCount chưa đọc',
              color: AppColors.textGrey,
              fontSize: AppFontSize.labelSmall,
              fontWeight: FontWeight.normal,
            ),
        ],
      ),
      actions: [
        if (unreadCount > 0)
          TextButton(
            onPressed: cubit.markAllAsRead,
            child: const Text(
              'Đọc tất cả',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: AppFontSize.labelSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (hasNotifications)
          IconButton(
            onPressed: () => _showConfirmClearAllDialog(cubit),
            icon: const Icon(
              Icons.delete_sweep_outlined,
              color: AppColors.redDanger,
            ),
            tooltip: 'Xóa tất cả',
          ),
      ],
    );
  }

  void _showConfirmClearAllDialog(AppNotificationCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xóa tất cả thông báo?'),
          content: const Text('Hành động này không thể hoàn tác.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                cubit.clearAllNotifications();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redDanger,
              ),
              child: const Text(
                'Xóa tất cả',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppNotificationCubit, AppNotificationState>(
      builder: (context, state) {
        final AppNotificationCubit cubit = context.read<AppNotificationCubit>();
        final int unreadCount =
            state.notifications.where((n) => !n.isRead).length;
        final bool isLoading = state.status == AppNotificationStatus.loading;
        final bool isError = state.status == AppNotificationStatus.error;
        final bool hasNotifications = state.notifications.isNotEmpty;

        Widget bodyContent;
        if (isLoading) {
          bodyContent = _buildLoadingState();
        } else if (isError) {
          bodyContent = _buildErrorState(state.errorMessage);
        } else {
          bodyContent = _buildNotificationList(state.notifications);
        }

        return Scaffold(
          backgroundColor: AppColors.lightBg,
          appBar: _buildAppBar(unreadCount, hasNotifications, cubit),
          body: bodyContent,
        );
      },
    );
  }
}
