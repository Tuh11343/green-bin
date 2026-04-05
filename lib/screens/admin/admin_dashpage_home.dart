import 'package:flutter/material.dart';
import '../../configs/app_color.dart';
import '../../models/enums.dart';
import '../../models/report.dart';
import '../../models/bin.dart';
import 'admin_bin_list_page.dart';
import 'admin_report_detail_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedTab = 0;
  int _selectedStatusFilter = -1; // -1: All
  int _sortOption = 0; // 0: Newest, 1: Oldest

  // Mock data - thay thế bằng API call
  final List<Report> mockReports = [
    Report(
      id: 1,
      userId: 1,
      binId: null,
      latitude: 10.7769,
      longitude: 106.7009,
      addressName: "123 Đường Nguyễn Huệ, Q1",
      description: "Thùng rác đầy, nước rỉ ra đường",
      status: ReportStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Report(
      id: 2,
      userId: 2,
      binId: 5,
      latitude: 10.7870,
      longitude: 106.6980,
      addressName: "456 Đường Bến Thành, Q1",
      description: "Thùng rác bị vỡ, cần thay thế",
      status: ReportStatus.processing,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Report(
      id: 3,
      userId: 1,
      binId: 3,
      latitude: 10.7750,
      longitude: 106.6950,
      addressName: "789 Đường Lê Lợi, Q1",
      description: "Vật liệu lạ bên cạnh thùng rác",
      status: ReportStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  final List<Bin> mockBins = [
    Bin(
      id: 1,
      latitude: 10.7769,
      longitude: 106.7009,
      reportCount: 2,
      fillLevel: FillLevel.high,
      type: BinType.organic,
      qrCode: "BIN001",
      lastEmptiedAt: DateTime.now().subtract(const Duration(days: 3)),
      addressName: "123 Đường Nguyễn Huệ, Q1",
    ),
    Bin(
      id: 2,
      latitude: 10.7870,
      longitude: 106.6980,
      reportCount: 0,
      fillLevel: FillLevel.medium,
      type: BinType.recyclable,
      qrCode: "BIN002",
      lastEmptiedAt: DateTime.now().subtract(const Duration(days: 1)),
      addressName: "456 Đường Bến Thành, Q1",
    ),
    Bin(
      id: 3,
      latitude: 10.7750,
      longitude: 106.6950,
      reportCount: 1,
      fillLevel: FillLevel.low,
      type: BinType.non_recyclable,
      qrCode: "BIN003",
      lastEmptiedAt: DateTime.now(),
      addressName: "789 Đường Lê Lợi, Q1",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStatsSection(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildTabSection(),
            ),
          ],
        ),
      ),
    );
  }

  // AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Admin Dashboard'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withOpacity(0.3),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  // Stats Section
  Widget _buildStatsSection() {
    final pendingCount = mockReports.where((r) => r.status == ReportStatus.pending).length;
    final processingCount = mockReports.where((r) => r.status == ReportStatus.processing).length;
    final highFillBins = mockBins.where((b) => b.fillLevel == FillLevel.high).length;

    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statCard("Báo cáo", mockReports.length.toString(), Colors.white),
          _statCard("Thùng rác", mockBins.length.toString(), Colors.white),
          _statCard("Chưa xử lý", pendingCount.toString(), Colors.white),
          _statCard("Đầy", highFillBins.toString(), Colors.white),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // Tab Section
  Widget _buildTabSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab buttons
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _tabButton("Báo cáo", 0),
              _tabButton("Thùng rác", 1),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Tab content
        if (_selectedTab == 0) _buildReportsTab(),
        if (_selectedTab == 1) _buildBinsTab(),
      ],
    );
  }

  Widget _tabButton(String label, int tabIndex) {
    final isSelected = _selectedTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = tabIndex),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  // Reports Tab
  Widget _buildReportsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterSortBar(),
        const SizedBox(height: 12),
        const Text(
          "Danh sách báo cáo",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _getFilteredAndSortedReports().length,
          itemBuilder: (context, index) {
            final report = _getFilteredAndSortedReports()[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportDetailPage(report: report),
                  ),
                );
              },
              child: _buildReportCard(report),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterSortBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Filter Button
          Expanded(
            child: GestureDetector(
              onTap: _showFilterBottomSheet,
              child: Row(
                children: [
                  Icon(Icons.filter_list, size: 18, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _selectedStatusFilter == -1
                          ? "Tất cả trạng thái"
                          : _getStatusText(ReportStatus.values[_selectedStatusFilter]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.expand_more, size: 18, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          // Sort Button
          Expanded(
            child: GestureDetector(
              onTap: _showSortBottomSheet,
              child: Row(
                children: [
                  Icon(Icons.sort, size: 18, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _sortOption == 0 ? "Mới nhất" : "Cũ nhất",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.expand_more, size: 18, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
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
            const Text(
              "Lọc theo trạng thái",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _filterOption("Tất cả", -1),
            _filterOption("Chưa xử lý", 0, Colors.red),
            _filterOption("Đang xử lý", 1, Colors.orange),
            _filterOption("Hoàn thành", 2, Colors.green),
            _filterOption("Đã hủy", 3, Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _filterOption(String label, int value, [Color? color]) {
    final isSelected = _selectedStatusFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedStatusFilter = value);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? AppColors.primary).withOpacity(0.1) : Colors.grey.shade50,
          border: Border.all(
            color: isSelected ? (color ?? AppColors.primary) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? (color ?? AppColors.primary) : Colors.grey.shade400,
                  width: isSelected ? 5 : 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? (color ?? AppColors.primary) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
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
            const Text(
              "Sắp xếp theo",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _sortOptionWidget("Mới nhất", 0),
            _sortOptionWidget("Cũ nhất", 1),
          ],
        ),
      ),
    );
  }


  Widget _sortOptionWidget(String label, int value) {
    final isSelected = _sortOption == value;
    return GestureDetector(
      onTap: () {
        setState(() => _sortOption = value);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade50,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: isSelected ? 5 : 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Report> _getFilteredAndSortedReports() {
    var filtered = mockReports;

    if (_selectedStatusFilter != -1) {
      filtered = filtered
          .where((r) => r.status == ReportStatus.values[_selectedStatusFilter])
          .toList();
    }

    // Sort
    if (_sortOption == 0) {
      // Newest first (Mới nhất lên đầu)
      filtered.sort((a, b) {
        final dateA = a.createdAt ?? DateTime(0); // Nếu null thì coi như năm 0
        final dateB = b.createdAt ?? DateTime(0);
        return dateB.compareTo(dateA);
      });
    } else {
      // Oldest first (Cũ nhất lên đầu)
      filtered.sort((a, b) {
        final dateA = a.createdAt ?? DateTime(2100); // Nếu null thì coi như tương lai
        final dateB = b.createdAt ?? DateTime(2100);
        return dateA.compareTo(dateB);
      });
    }

    return filtered;
  }

  Widget _buildReportCard(Report report) {
    final statusColor = _getStatusColor(report.status);
    final statusText = _getStatusText(report.status);

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Báo cáo #${report.id}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  report.addressName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            report.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDateTime(report.createdAt),
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
              if (report.binId == null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Chưa có Bin",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
                )
              else
                Text(
                  "Bin #${report.binId}",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Bins Tab
  Widget _buildBinsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Danh sách thùng rác",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BinListPage(),
                  ),
                );
              },
              icon: const Icon(Icons.view_list, size: 16),
              label: const Text("Xem tất cả"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mockBins.take(3).length,
          itemBuilder: (context, index) {
            final bin = mockBins[index];
            return _buildBinCard(bin);
          },
        ),
      ],
    );
  }

  Widget _buildBinCard(Bin bin) {
    final fillLevelColor = _getFillLevelColor(bin.fillLevel);
    final fillLevelText = _getFillLevelText(bin.fillLevel);
    final binTypeText = _getBinTypeText(bin.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.delete_outline,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bin #${bin.id}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: fillLevelColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: fillLevelColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        fillLevelText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: fillLevelColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  bin.addressName ?? "Chưa xác định",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      binTypeText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.flag,
                      size: 11,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "${bin.reportCount} báo cáo",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
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

  String _getBinTypeText(BinType type) {
    switch (type) {
      case BinType.organic:
        return "Hữu cơ";
      case BinType.recyclable:
        return "Tái chế";
      case BinType.non_recyclable:
        return "Không tái chế";
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    // 1. Kiểm tra nếu ngày bị null thì thoát sớm
    if (dateTime == null) return "Chưa xác định";

    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes <= 0) return "Vừa xong"; // Tránh trường hợp "0 phút trước"
        return "${diff.inMinutes} phút trước";
      }
      return "${diff.inHours} giờ trước";
    }

    if (diff.inDays == 1) {
      return "Hôm qua";
    }

    // 2. Định dạng ngày tháng chuẩn (Thêm số 0 phía trước nếu < 10 cho đẹp)
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    return "$day/$month/${dateTime.year}";
  }
}