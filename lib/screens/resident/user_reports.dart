import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/enums.dart';
import '../../models/report.dart';
import '../../models/report_photo.dart';
import '../../models/user.dart';

class ActivityHistoryPage extends StatelessWidget {
  final List<Report> reports;
  final User currentUser;
  final Map<int, List<ReportPhoto>> photosByReportId;

  const ActivityHistoryPage({
    Key? key,
    required this.reports,
    required this.currentUser,
    required this.photosByReportId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoạt Động Gần Đây'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                // TODO: Implement filter logic
              },
              child: const Text(
                'Xem tất cả',
                style: TextStyle(color: Colors.teal, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: reports.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Không có hoạt động',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: reports.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final report = reports[index];
                final photos = photosByReportId[report.id] ?? [];
                return ActivityCard(
                  report: report,
                  photos: photos,
                  onTap: () {
                    // TODO: Navigate to report detail
                  },
                );
              },
            ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Report report;
  final List<ReportPhoto> photos;
  final VoidCallback onTap;

  const ActivityCard({
    Key? key,
    required this.report,
    required this.photos,
    required this.onTap,
  }) : super(key: key);

  String _getStatusLabel(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return 'Chưa xử lý';
      case ReportStatus.processing:
        return 'Đang xử lý';
      case ReportStatus.completed:
        return 'Đã xử lý';
      case ReportStatus.cancelled:
        return 'Từ chối';
      default:
        return 'Không xác định';
    }
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return Colors.orange;
      case ReportStatus.processing:
        return Colors.blue;
      case ReportStatus.completed:
        return Colors.green;
      case ReportStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return "Chưa có ngày";
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Báo Cáo Rác Thải',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(report.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(report.status),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _getStatusLabel(report.status),
                      style: TextStyle(
                        color: _getStatusColor(report.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Photos Preview
              if (photos.isNotEmpty)
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            photos[index].publicImageUrl,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                color: Colors.grey[200],
                                child: Icon(Icons.image_not_supported,
                                    color: Colors.grey[400]),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (photos.isNotEmpty) const SizedBox(height: 12),

              // Location Info
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      report.addressName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Coordinates
              Row(
                children: [
                  Icon(Icons.map, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    '${report.latitude.toStringAsFixed(4)}, ${report.longitude.toStringAsFixed(4)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Timestamps
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    _getTimeAgo(report.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    report.createdAt != null
                        ? DateFormat('dd/MM/yyyy HH:mm').format(report.createdAt!)
                        : 'Chưa có ngày',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Bin ID (if available)
              if (report.binId != null)
                Row(
                  children: [
                    Icon(Icons.delete, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Thùng #${report.binId}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

              // Additional Details Section
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chi tiết báo cáo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('ID Báo cáo:', '#${report.id ?? 'N/A'}'),
                    _buildDetailRow(
                        'Trạng thái:', _getStatusLabel(report.status)),
                    _buildDetailRow(
                      'Tạo lúc:',
                      DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(report.createdAt ?? DateTime.now()), // Nếu null thì lấy giờ hiện tại
                    ),
                    _buildDetailRow(
                      'Cập nhật lúc:',
                      DateFormat('dd/MM/yyyy HH:mm:ss')
                          .format(report.createdAt ?? DateTime.now()),
                    ),
                    if (photos.isNotEmpty)
                      _buildDetailRow('Số ảnh:', '${photos.length}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
