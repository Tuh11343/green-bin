import 'package:flutter/material.dart';
import '../../configs/app_color.dart';
import '../../models/bin.dart';
import '../../models/enums.dart';

class BinListPage extends StatefulWidget {
  const BinListPage({Key? key}) : super(key: key);

  @override
  State<BinListPage> createState() => _BinListPageState();
}

class _BinListPageState extends State<BinListPage> {
  int _selectedFilter = 0; // 0: All, 1: High, 2: Medium, 3: Low

  // Mock data
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
    Bin(
      id: 4,
      latitude: 10.7700,
      longitude: 106.7000,
      reportCount: 3,
      fillLevel: FillLevel.high,
      type: BinType.organic,
      qrCode: "BIN004",
      lastEmptiedAt: DateTime.now().subtract(const Duration(days: 2)),
      addressName: "321 Đường Đồng Khởi, Q1",
    ),
    Bin(
      id: 5,
      latitude: 10.7850,
      longitude: 106.7050,
      reportCount: 0,
      fillLevel: FillLevel.low,
      type: BinType.recyclable,
      qrCode: "BIN005",
      lastEmptiedAt: DateTime.now().subtract(const Duration(hours: 12)),
      addressName: "654 Đường Nguyễn Hữu Cảnh, Q1",
    ),
  ];

  List<Bin> get _filteredBins {
    if (_selectedFilter == 0) return mockBins;
    final fillLevels = [FillLevel.high, FillLevel.medium, FillLevel.low];
    return mockBins.where((bin) => bin.fillLevel == fillLevels[_selectedFilter - 1]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Danh sách thùng rác'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFilterSection(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildBinsList(),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Section
  Widget _buildFilterSection() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lọc theo mức độ đầy",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip("Tất cả", 0),
                const SizedBox(width: 8),
                _filterChip("Cao", 1, Colors.red),
                const SizedBox(width: 8),
                _filterChip("Trung bình", 2, Colors.orange),
                const SizedBox(width: 8),
                _filterChip("Thấp", 3, Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, int index, [Color? color]) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (color ?? Colors.transparent)
                : Colors.white.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null && isSelected)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            if (color != null && isSelected) const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black87 : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bins List
  Widget _buildBinsList() {
    final bins = _filteredBins;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${bins.length} thùng rác",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bins.length,
          itemBuilder: (context, index) {
            return _buildBinCard(bins[index]);
          },
        ),
      ],
    );
  }

  Widget _buildBinCard(Bin bin) {
    final fillLevelColor = _getFillLevelColor(bin.fillLevel);
    final fillLevelText = _getFillLevelText(bin.fillLevel);
    final binTypeText = _getBinTypeText(bin.type);

    return GestureDetector(
      onTap: () {
        _showBinDetailBottomSheet(bin);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bin #${bin.id}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: fillLevelColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: fillLevelColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: fillLevelColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        fillLevelText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: fillLevelColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    bin.addressName ?? "Chưa xác định",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _infoChip(
                    Icons.qr_code,
                    "Mã",
                    bin.qrCode ?? "N/A",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _infoChip(
                    Icons.delete_outline,
                    "Loại",
                    binTypeText,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _infoChip(
                    Icons.flag,
                    "Báo cáo",
                    "${bin.reportCount}",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.grey.shade600),
              const SizedBox(width: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Bin Detail Bottom Sheet
  void _showBinDetailBottomSheet(Bin bin) {
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
            const SizedBox(height: 20),
            Text(
              "Thông tin thùng rác #${bin.id}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _detailRow("Mã QR", bin.qrCode ?? "N/A"),
            _detailRow("Địa chỉ", bin.addressName ?? "Chưa xác định"),
            _detailRow("Loại rác", _getBinTypeText(bin.type)),
            _detailRow(
              "Mức độ đầy",
              _getFillLevelText(bin.fillLevel),
            ),
            _detailRow("Số báo cáo", "${bin.reportCount}"),
            _detailRow(
              "Lần xả gần nhất",
              bin.lastEmptiedAt != null
                  ? "${bin.lastEmptiedAt!.day}/${bin.lastEmptiedAt!.month}/${bin.lastEmptiedAt!.year}"
                  : "Chưa xác định",
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Đã sao chép thông tin thùng rác #${bin.id}"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Sao chép thông tin"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Functions
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
}