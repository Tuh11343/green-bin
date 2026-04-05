import 'package:flutter/material.dart';

import '../../../bloc/report/user_report_history/user_report_history_state.dart';
import '../../../configs/app_color.dart';
import '../../../models/enums.dart';
import '../../../models/report.dart';
import '../../../models/response/report_detail_response.dart';

Color _statusColor(ReportStatus status) => {
      ReportStatus.pending: Colors.red,
      ReportStatus.processing: Colors.orange,
      ReportStatus.completed: Colors.green,
      ReportStatus.cancelled: Colors.grey,
    }[status]!;

String _statusLabel(ReportStatus status) => {
      ReportStatus.pending: 'Chưa xử lý',
      ReportStatus.processing: 'Đang xử lý',
      ReportStatus.completed: 'Hoàn thành',
      ReportStatus.cancelled: 'Đã hủy',
    }[status]!;

String _formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return 'Chưa xác định';
  final difference = DateTime.now().difference(dateTime);
  if (difference.inMinutes < 1) return 'Vừa xong';
  if (difference.inMinutes < 60) return '${difference.inMinutes} phút trước';
  if (difference.inHours < 24) return '${difference.inHours} giờ trước';
  if (difference.inDays == 1) return 'Hôm qua';
  final day = dateTime.day.toString().padLeft(2, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  return '$day/$month/${dateTime.year}';
}

class StatsBar extends StatelessWidget {
  final List<Report> reports;

  const StatsBar({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    int countByStatus(ReportStatus status) {
      return reports.where((report) => report.status == status).length;
    }

    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'Tổng', value: '${reports.length}'),
          _StatItem(
              label: 'Hoàn thành',
              value: '${countByStatus(ReportStatus.completed)}'),
          _StatItem(
              label: 'Đang xử lý',
              value: '${countByStatus(ReportStatus.processing)}'),
          _StatItem(
              label: 'Chưa xử lý',
              value: '${countByStatus(ReportStatus.pending)}'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }
}

class ReportCard extends StatelessWidget {
  final ReportDetailResponse item;
  final VoidCallback onTap;

  const ReportCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ReportStatus status = item.report.status;
    final Color statusColor = _statusColor(status);
    final String statusLabel = _statusLabel(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mã báo cáo + badge trạng thái
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Báo cáo #${item.report.id}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Địa chỉ
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.report.addressName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Mô tả
            Text(
              item.report.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            // Thời gian + bin tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDateTime(item.report.createdAt),
                  style: TextStyle(fontSize: 11, color: Colors.black),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Bin #${item.bin!.id}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
