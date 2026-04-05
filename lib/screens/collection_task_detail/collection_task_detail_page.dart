import 'package:flutter/material.dart';
import '../../configs/app_color.dart';
import '../../models/bin.dart';
import '../../models/collection_task.dart';
import '../../models/enums.dart';

class CollectionTaskDetailPage extends StatefulWidget {
  final CollectionTask task;
  final Bin bin;

  const CollectionTaskDetailPage({
    Key? key,
    required this.task,
    required this.bin,
  }) : super(key: key);

  @override
  State<CollectionTaskDetailPage> createState() => _CollectionTaskDetailPageState();
}

class _CollectionTaskDetailPageState extends State<CollectionTaskDetailPage> {
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Nhiệm vụ #${widget.task.id ?? "Mới"}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeadline("Quy trình công việc"),
            const SizedBox(height: 12),
            _buildStepIndicator(),
            const SizedBox(height: 28),
            _buildHeadline("Thông tin điểm thu gom"),
            const SizedBox(height: 12),
            _buildBinInfoCard(),
            const SizedBox(height: 28),
            _buildHeadline("Chi tiết nhiệm vụ"),
            const SizedBox(height: 12),
            _buildWorkArea(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  // Headline Component
  Widget _buildHeadline(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
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
      ),
    );
  }

  // 1. Thanh chỉ báo tiến trình
  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stepItem(1, "Di chuyển", isDone: _currentStep > 1, isActive: _currentStep == 1),
          _lineSeparator(_currentStep > 1),
          _stepItem(2, "Thu gom", isDone: _currentStep > 2, isActive: _currentStep == 2),
          _lineSeparator(_currentStep > 2),
          _stepItem(3, "Xác nhận", isDone: false, isActive: _currentStep == 3),
        ],
      ),
    );
  }

  Widget _stepItem(int step, String title, {required bool isDone, required bool isActive}) {
    Color color = isDone || isActive ? AppColors.primary : Colors.grey.shade300;
    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: color,
          child: isDone
              ? const Icon(Icons.check, size: 18, color: Colors.white)
              : Text('$step', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 5),
        Text(title, style: TextStyle(color: color, fontSize: 11, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _lineSeparator(bool isDone) {
    return Container(height: 2, width: 40, color: isDone ? AppColors.primary : Colors.grey.shade300);
  }

  // 2. Thẻ thông tin Thùng rác
  Widget _buildBinInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.bin.addressName ?? "Vị trí chưa xác định",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _infoTile("Mã thùng", widget.bin.qrCode ?? "N/A")),
              const SizedBox(width: 16),
              Expanded(child: _infoTile("Loại rác", widget.bin.type.toString().split('.').last, isTag: true)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _infoTile("Mức độ đầy", _getFillLevelText(widget.bin.fillLevel), isTag: true)),
              const SizedBox(width: 16),
              Expanded(child: _infoTile("Lần xả gần nhất", _formatLastEmptied(widget.bin.lastEmptiedAt))),
            ],
          ),
        ],
      ),
    );
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

  String _formatLastEmptied(DateTime? date) {
    if (date == null) return "Chưa xác định";
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return "Hôm nay";
    if (diff.inDays == 1) return "Hôm qua";
    if (diff.inDays < 7) return "${diff.inDays} ngày trước";
    return "${(diff.inDays / 7).toStringAsFixed(0)} tuần trước";
  }

  Widget _infoTile(String label, String value, {bool isTag = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        isTag
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Text(value, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
        )
            : Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  // 3. Khu vực làm việc thay đổi theo Bước
  Widget _buildWorkArea() {
    if (_currentStep == 1) {
      return _workCard(
        title: "Bắt đầu công việc",
        desc: "Xác nhận bạn đã đến điểm thu gom rác.",
        icon: Icons.directions_run,
        buttonText: "Tôi đã đến nơi",
        onTap: () => setState(() => _currentStep = 2),
      );
    } else if (_currentStep == 2) {
      return _workCard(
        title: "Đang thu gom rác",
        desc: "Hãy dọn dẹp sạch sẽ khu vực xung quanh thùng rác.",
        icon: Icons.delete_outline,
        buttonText: "Đã đổ rác xong",
        onTap: () => setState(() => _currentStep = 3),
      );
    } else {
      return _buildPhotoUploadArea();
    }
  }

  Widget _workCard({
    required String title,
    required String desc,
    required IconData icon,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 50, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(buttonText, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Khu vực chụp ảnh
  Widget _buildPhotoUploadArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Chụp ảnh xác nhận", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          const Text("Chụp ảnh thùng rác đã sạch để ghi nhận công việc", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: List.generate(3, (index) => Expanded(
              child: GestureDetector(
                onTap: () {
                  // Xử lý chụp ảnh
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary.withOpacity(0.3), style: BorderStyle.solid, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary.withOpacity(0.05),
                  ),
                  child: Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 32),
                ),
              ),
            )),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "Nhấn vào để chụp ảnh",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    if (_currentStep < 3) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          // Xử lý hoàn thành Task tại đây
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text("HOÀN THÀNH CÔNG VIỆC", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}