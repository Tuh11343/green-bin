import 'package:flutter/material.dart';
import 'package:greenbin/configs/font_size.dart';

import '../../configs/app_color.dart';
import '../../models/enums.dart';
import '../../models/response/report_detail_response.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

Color _statusColor(ReportStatus s) => {
  ReportStatus.pending: Colors.red,
  ReportStatus.processing: Colors.orange,
  ReportStatus.completed: Colors.green,
  ReportStatus.cancelled: Colors.grey,
}[s]!;

String _statusLabel(ReportStatus s) => {
  ReportStatus.pending: 'Chưa xử lý',
  ReportStatus.processing: 'Đang xử lý',
  ReportStatus.completed: 'Hoàn thành',
  ReportStatus.cancelled: 'Đã hủy',
}[s]!;

String _binTypeLabel(BinType t) => {
  BinType.organic: 'Hữu cơ',
  BinType.recyclable: 'Tái chế',
  BinType.non_recyclable: 'Không tái chế',
}[t]!;

String _fillLevelLabel(FillLevel l) => {
  FillLevel.low: 'Thấp',
  FillLevel.medium: 'Vừa phải',
  FillLevel.high: 'Cao',
}[l]!;

String _formatDateTime(DateTime? dt) {
  if (dt == null) return 'Chưa xác định';
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'Vừa xong';
  if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
  if (diff.inHours < 24) return '${diff.inHours} giờ trước';
  if (diff.inDays == 1) return 'Hôm qua';
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  return '$d/$m/${dt.year}';
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class UserReportDetailPage extends StatelessWidget {
  final ReportDetailResponse item;

  const UserReportDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = item.report.status;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Báo cáo #${item.report.id}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _StatusBanner(status: status),
            const SizedBox(height: 16),

            _DetailSection(title: 'Thông tin báo cáo', rows: [
              ('Mã báo cáo', '#${item.report.id}'),
              ('Địa chỉ', item.report.addressName),
              ('Mô tả', item.report.description),
              ('Ngày báo cáo', _formatDateTime(item.report.createdAt)),
            ]),
            const SizedBox(height: 16),

            // Thông tin thùng rác
            if (item.bin != null) ...[
              _DetailSection(title: 'Thông tin thùng rác', rows: [
                ('Mã thùng', 'Bin #${item.bin!.id} (${item.bin!.qrCode})'),
                ('Loại rác', _binTypeLabel(item.bin!.type)),
                ('Mức độ đầy', _fillLevelLabel(item.bin!.fillLevel)),
                ('Lần xả gần nhất', _formatDateTime(item.bin!.lastEmptiedAt)),
              ]),
              const SizedBox(height: 16),
            ],

            // Ảnh báo cáo
            if (item.reportPhotos.isNotEmpty) ...[
              const Text('Ảnh báo cáo',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87)),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: item.reportPhotos.length,
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.reportPhotos[i].imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  final ReportStatus status;

  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 8),
          Text(
            _statusLabel(status),
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;

  const _DetailSection({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: rows.map((row) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.$1,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(row.$2,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: AppFontSize.bodySmall,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}