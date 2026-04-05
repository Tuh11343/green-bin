import 'package:flutter/material.dart';
import '../../configs/app_color.dart';
import '../../configs/font_size.dart';
import '../../models/bin.dart';
import '../../models/enums.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/dialog.dart';

class BinsListPage extends StatefulWidget {
  const BinsListPage({Key? key}) : super(key: key);

  @override
  State<BinsListPage> createState() => _BinsListPageState();
}

class _BinsListPageState extends State<BinsListPage> {
  late List<Bin> allBins;
  late List<Bin> filteredBins;

  String selectedQuickFilter = 'Tất cả';
  BinType? filterType;
  FillLevel? filterLevel;
  String sortBy = 'Mức độ đầy'; // 'Mức độ đầy', 'ID', 'Báo cáo'

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _applyFilters();
  }

  void _initializeMockData() {
    allBins = [
      Bin(id: 1, latitude: 10.7, longitude: 106.7, reportCount: 3, fillLevel: FillLevel.high, type: BinType.recyclable, qrCode: 'BIN001', lastEmptiedAt: DateTime.now().subtract(const Duration(hours: 2))),
      Bin(id: 2, latitude: 10.7, longitude: 106.7, reportCount: 1, fillLevel: FillLevel.medium, type: BinType.organic, qrCode: 'BIN002', lastEmptiedAt: DateTime.now().subtract(const Duration(hours: 5))),
      Bin(id: 3, latitude: 10.7, longitude: 106.7, reportCount: 0, fillLevel: FillLevel.low, type: BinType.non_recyclable, qrCode: 'BIN003', lastEmptiedAt: DateTime.now().subtract(const Duration(hours: 12))),
      Bin(id: 4, latitude: 10.7, longitude: 106.7, reportCount: 2, fillLevel: FillLevel.high, type: BinType.recyclable, qrCode: 'BIN004', lastEmptiedAt: DateTime.now().subtract(const Duration(hours: 1))),
    ];
  }

  void _applyFilters() {
    setState(() {
      filteredBins = allBins.where((bin) {
        // 1. Lọc nhanh (Quick Filter)
        bool matchQuick = true;
        if (selectedQuickFilter == 'Cần thu gom') {
          matchQuick = bin.fillLevel == FillLevel.high;
        } else if (selectedQuickFilter == 'Hữu cơ') {
          matchQuick = bin.type == BinType.organic;
        } else if (selectedQuickFilter == 'Tái chế') {
          matchQuick = bin.type == BinType.recyclable;
        }

        // 2. Lọc chi tiết từ Bottom Sheet
        bool matchType = filterType == null || bin.type == filterType;
        bool matchLevel = filterLevel == null || bin.fillLevel == filterLevel;

        return matchQuick && matchType && matchLevel;
      }).toList();

      // 3. Sắp xếp (Sorting)
      if (sortBy == 'Mức độ đầy') {
        // Sắp xếp giảm dần: Thùng High (2) -> Medium (1) -> Low (0)
        filteredBins.sort((a, b) => b.fillLevel.index.compareTo(a.fillLevel.index));
      } else if (sortBy == 'Báo cáo') {
        filteredBins.sort((a, b) => b.reportCount.compareTo(a.reportCount));
      } else if (sortBy == 'Gần nhất') {
        filteredBins.sort((a, b) {
          if (a.lastEmptiedAt == null) return 1;
          if (b.lastEmptiedAt == null) return -1;
          return b.lastEmptiedAt!.compareTo(a.lastEmptiedAt!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Màu nền nhẹ nhàng hơn
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildActionHeader(),
          _buildQuickFilterBar(),
          Expanded(
            child: filteredBins.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: filteredBins.length,
              itemBuilder: (context, index) => _buildBinCard(filteredBins[index]),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      centerTitle: false,
      title: const Text(
        'Thu gom rác',
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        // Nút bản đồ duy nhất trên AppBar
        IconButton(
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const MapViewPage()));
          },
          icon: const Icon(Icons.map_rounded, color: Colors.white),
          tooltip: 'Xem bản đồ',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildActionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            '${filteredBins.length} thùng rác tìm thấy',
            fontSize: AppFontSize.bodyMedium,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
          ),
          // Nút mở bộ lọc nâng cao
          InkWell(
            onTap: _showFilterBottomSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: const Row(
                children: [
                  Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('Lọc & Sắp xếp', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterBar() {
    final quickFilters = ['Tất cả', 'Cần thu gom', 'Hữu cơ', 'Tái chế'];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: quickFilters.length,
        itemBuilder: (context, index) {
          final filter = quickFilters[index];
          final isSelected = selectedQuickFilter == filter;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (val) {
                setState(() => selectedQuickFilter = filter);
                _applyFilters();
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textGrey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey[300]!),
            ),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sắp xếp theo',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['Mức độ đầy', 'Báo cáo', 'Gần nhất'].map((s) {
                      return ChoiceChip(
                        label: Text(s),
                        selected: sortBy == s,
                        onSelected: (v) => setModalState(() => sortBy = s),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Lọc theo mức độ đầy',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: FillLevel.values.map((level) {
                      return ChoiceChip(
                        label: Text(level == FillLevel.high ? 'Đầy' :
                        level == FillLevel.medium ? 'Vừa' : 'Thấp'),
                        selected: filterLevel == level,
                        onSelected: (v) => setModalState(() => filterLevel = v ? level : null),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Loại rác',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: BinType.values.map((type) {
                      return ChoiceChip(
                        label: Text(type == BinType.organic ? 'Hữu cơ' :
                        type == BinType.recyclable ? 'Tái chế' : 'Vô cơ'),
                        selected: filterType == type,
                        onSelected: (v) => setModalState(() => filterType = v ? type : null),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Áp dụng',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBinCard(Bin bin) {
    // Giữ nguyên logic Card của bạn nhưng tinh chỉnh UI nhẹ
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildTypeIndicator(bin.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Thùng rác #${bin.qrCode}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Quận 1, TP. Hồ Chí Minh', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ),
                _buildFillBadge(bin.fillLevel),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _getFillValue(bin.fillLevel),
              backgroundColor: Colors.grey[100],
              color: _getLevelColor(bin.fillLevel),
              minHeight: 8,
              // borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _iconInfo(Icons.warning_amber_rounded, '${bin.reportCount} báo cáo'),
                const SizedBox(width: 16),
                _iconInfo(Icons.history, _formatLastEmptied(bin.lastEmptiedAt)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // 1. Hiển thị dialog xác nhận
                    final confirm = await AppDialog.showAssignmentConfirm(
                      context,
                      binCode: bin.qrCode ?? 'N/A',
                      binType: bin.type.toString().split('.').last, // Hoặc dùng displayName từ extension
                      address: bin.addressName ?? 'Quận 1, TP. Hồ Chí Minh',
                    );

                    // 2. Nếu người dùng chọn "Xác nhận"
                    if (confirm == true) {
                      // TODO: Gọi API xử lý Transaction:
                      // - Kiểm tra Bin status (có bị ai nhận trước chưa)
                      // - Tạo CollectionTask (status: inProgress)
                      // - Chuyển các Report liên quan sang status: processing

                      // Giả lập xử lý thành công
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã nhận thành công thùng #${bin.qrCode}. Hãy kiểm tra trong Nhiệm vụ của tôi.'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        // Sau khi nhận, bạn có thể xóa bin này khỏi danh sách filteredBins hiện tại
                        setState(() {
                          allBins.removeWhere((item) => item.id == bin.id);
                          _applyFilters();
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Nhận việc', style: TextStyle(color: Colors.white)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Các Helper Widgets phụ trợ...
  Widget _buildTypeIndicator(BinType type) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: const Icon(Icons.delete_sweep_rounded, color: Colors.green),
    );
  }

  Widget _buildFillBadge(FillLevel level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: _getLevelColor(level).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6)
      ),
      child: Text(
        level.toString().split('.').last.toUpperCase(),
        style: TextStyle(color: _getLevelColor(level), fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _iconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Color _getLevelColor(FillLevel level) {
    if (level == FillLevel.high) return Colors.red;
    if (level == FillLevel.medium) return Colors.orange;
    return Colors.green;
  }

  double _getFillValue(FillLevel level) {
    switch (level) {
      case FillLevel.high:
        return 0.95; // 95%
      case FillLevel.medium:
        return 0.5;  // 50%
      case FillLevel.low:
        return 0.15; // 15%
    }
  }

  String _formatLastEmptied(DateTime? date) => "2h trước"; // Giả lập

  Widget _buildEmptyState() => const Center(child: Text("Không có dữ liệu"));
}