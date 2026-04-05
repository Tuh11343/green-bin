import 'package:flutter/material.dart';
import '../../configs/app_color.dart';
import '../../models/enums.dart';
import '../../models/report.dart';
import '../../models/bin.dart';

class ReportDetailPage extends StatefulWidget {
  final Report report;

  const ReportDetailPage({
    Key? key,
    required this.report,
  }) : super(key: key);

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  late Report _currentReport;

  // Mock bins data
  final List<Bin> mockBins = [
    Bin(
      id: 10,
      latitude: 10.7769,
      longitude: 106.7009,
      reportCount: 2,
      fillLevel: FillLevel.high,
      type: BinType.organic,
      qrCode: "BIN010",
      lastEmptiedAt: DateTime.now().subtract(const Duration(days: 3)),
      addressName: "123 Đường Nguyễn Huệ, Q1",
    ),
    Bin(
      id: 11,
      latitude: 10.7870,
      longitude: 106.6980,
      reportCount: 0,
      fillLevel: FillLevel.medium,
      type: BinType.recyclable,
      qrCode: "BIN011",
      lastEmptiedAt: DateTime.now().subtract(const Duration(days: 1)),
      addressName: "456 Đường Bến Thành, Q1",
    ),
    Bin(
      id: 12,
      latitude: 10.7750,
      longitude: 106.6950,
      reportCount: 1,
      fillLevel: FillLevel.low,
      type: BinType.non_recyclable,
      qrCode: "BIN012",
      lastEmptiedAt: DateTime.now(),
      addressName: "789 Đường Lê Lợi, Q1",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentReport = widget.report;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Báo cáo #${_currentReport.id}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 20),
            _buildHeadline("Thông tin báo cáo"),
            const SizedBox(height: 12),
            _buildReportInfoCard(),
            const SizedBox(height: 20),
            _buildHeadline("Vị trí báo cáo"),
            const SizedBox(height: 12),
            _buildLocationCard(),
            const SizedBox(height: 20),
            _buildHeadline("Mô tả chi tiết"),
            const SizedBox(height: 12),
            _buildDescriptionCard(),
            const SizedBox(height: 20),
            if (_currentReport.binId != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeadline("Thùng rác liên quan"),
                  const SizedBox(height: 12),
                  _buildBinCard(),
                  const SizedBox(height: 20),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeadline("Gán thùng rác"),
                  const SizedBox(height: 12),
                  _buildAssignBinCard(),
                  const SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  // Status Card
  Widget _buildStatusCard() {
    final statusColor = _getStatusColor(_currentReport.status);
    final statusText = _getStatusText(_currentReport.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Cập nhật lần cuối: ${_formatDateTime(_currentReport.updatedAt)}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Headline
  Widget _buildHeadline(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  // Report Info Card
  Widget _buildReportInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Mã báo cáo", "#${_currentReport.id}"),
          const SizedBox(height: 12),
          _infoRow("Người báo cáo", "ID: ${_currentReport.userId}"),
          const SizedBox(height: 12),
          _infoRow("Thời gian báo cáo", _formatDateTime(_currentReport.createdAt)),
          const SizedBox(height: 12),
          _infoRow("Trạng thái", _getStatusText(_currentReport.status)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Location Card
  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _currentReport.addressName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vĩ độ",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        _currentReport.latitude.toStringAsFixed(4),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kinh độ",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        _currentReport.longitude.toStringAsFixed(4),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Description Card
  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        _currentReport.description,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
          height: 1.6,
        ),
      ),
    );
  }

  // Bin Card (khi có binId)
  Widget _buildBinCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Thùng rác #${_currentReport.binId}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: const Text(
              "Đã gán thùng rác",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Assign Bin Card (khi không có binId)
  Widget _buildAssignBinCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Báo cáo chưa được gán thùng rác",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Chọn từ danh sách hoặc tạo mới",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showSelectBinBottomSheet();
              },
              icon: const Icon(Icons.list, size: 18),
              label: const Text("Chọn thùng rác có sẵn"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showCreateBinDialog();
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Tạo thùng rác mới"),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.orange),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Select Bin Bottom Sheet
  void _showSelectBinBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Chọn thùng rác",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: mockBins.length,
              itemBuilder: (context, index) {
                final bin = mockBins[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentReport = _currentReport.copyWith(binId: bin.id);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Đã gán thùng rác #${bin.id}"),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bin #${bin.id}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                bin.addressName ?? "Chưa xác định",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getFillLevelColor(bin.fillLevel)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getFillLevelText(bin.fillLevel),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getFillLevelColor(bin.fillLevel),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Create Bin Dialog
  void _showCreateBinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tạo thùng rác mới"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vị trí: ${_currentReport.addressName}",
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              "Tọa độ: ${_currentReport.latitude.toStringAsFixed(4)}, ${_currentReport.longitude.toStringAsFixed(4)}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Thùng rác đã được tạo thành công"),
                  duration: Duration(seconds: 2),
                ),
              );
              setState(() {
                _currentReport = _currentReport.copyWith(binId: 999);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }

  // Bottom Action
  Widget _buildBottomAction() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Từ chối",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Chấp nhận",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Functions
  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return Colors.red;
      case ReportStatus.processing:
        return Colors.orange;
      case ReportStatus.completed:
        return Colors.green;
      case ReportStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getStatusText(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return "Chưa xử lý";
      case ReportStatus.processing:
        return "Đang xử lý";
      case ReportStatus.completed:
        return "Hoàn thành";
      case ReportStatus.cancelled:
        return "Đã hủy";
    }
  }

  Color _getFillLevelColor(FillLevel level) {
    switch (level) {
      case FillLevel.low:
        return Colors.green;
      case FillLevel.medium:
        return Colors.orange;
      case FillLevel.high:
        return Colors.red;
    }
  }

  String _getFillLevelText(FillLevel level) {
    switch (level) {
      case FillLevel.low:
        return "Thấp";
      case FillLevel.medium:
        return "Vừa phải";
      case FillLevel.high:
        return "Cao";
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Chưa có ngày";

    // Thêm padLeft để các số < 10 hiển thị là 01, 02... cho chuyên nghiệp
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return "$day/$month/${dateTime.year} $hour:$minute";
  }
}