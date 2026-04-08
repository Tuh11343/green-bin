import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/app/app_cubit.dart';
import '../../bloc/report/report_cubit.dart';
import '../../bloc/report/report_state.dart';
import '../../bloc/user/user_cubit.dart';
import '../../configs/app_color.dart';
import '../../configs/font_size.dart';
import '../../models/bin.dart';
import '../../models/enums.dart';
import '../../models/report.dart';
import '../../models/user.dart';

class CreateReportPage extends StatefulWidget {
  final Bin bin;

  const CreateReportPage({Key? key, required this.bin}) : super(key: key);

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final List<Uint8List> _images = [];
  final ImagePicker _picker = ImagePicker();

  static const int _maxImages = 5;
  static const int _minLength = 10;
  static const int _maxLength = 500;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _binTypeLabel(BinType type) => switch (type) {
        BinType.organic => 'Hữu cơ',
        BinType.recyclable => 'Tái chế',
        BinType.non_recyclable => 'Vô cơ',
      };

  Color _binTypeColor(BinType type) => switch (type) {
        BinType.organic => AppColors.primary,
        BinType.recyclable => AppColors.blueInfo,
        BinType.non_recyclable => AppColors.redDanger,
      };

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.redDanger : AppColors.primary,
      ),
    );
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> _pickImage({required ImageSource source}) async {
    if (_images.length >= _maxImages) {
      _showSnackBar('Tối đa $_maxImages ảnh', isError: true);
      return;
    }
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (!mounted || picked == null) return;
      final bytes = await picked.readAsBytes();
      setState(() => _images.add(bytes));
    } catch (e) {
      _showSnackBar('Lỗi: $e', isError: true);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Vui lòng kiểm tra lại form', isError: true);
      return;
    }
    if (_images.isEmpty) {
      _showSnackBar('Vui lòng chọn ít nhất 1 ảnh', isError: true);
      return;
    }
    try {
      if (mounted) {
        User user = context.read<UserCubit>().state.user!;
        Bin bin = widget.bin;
        final report = Report(
            userId: user.id!,
            binId: bin.id,
            addressName: bin.addressName ?? "Không rõ",
            latitude: bin.latitude,
            longitude: bin.longitude,
            description: _descController.text.trim(),
            status: ReportStatus.pending,);

        context
            .read<ReportCubit>()
            .createNewReport(report: report, images: _images).onError((error, stackTrace) {

            });
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e', isError: true);
    }
  }

  // ─── Bin Info ─────────────────────────────────────────────────────────────

  Widget _buildBinHeader() {
    final color = _binTypeColor(widget.bin.type);
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.delete_outline, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thùng rác #${widget.bin.id}',
                style: const TextStyle(
                  fontSize: AppFontSize.bodyLarge,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _binTypeLabel(widget.bin.type),
                  style: TextStyle(
                    fontSize: AppFontSize.labelSmall,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBinAddress() {
    final address = widget.bin.addressName ??
        '${widget.bin.latitude.toStringAsFixed(4)}, ${widget.bin.longitude.toStringAsFixed(4)}';
    return Row(
      children: [
        const Icon(Icons.location_on, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(
              fontSize: AppFontSize.bodySmall,
              color: AppColors.textGrey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBinInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _buildBinHeader(),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _buildBinAddress(),
        ],
      ),
    );
  }

  // ─── Image Section ────────────────────────────────────────────────────────

  Widget _buildImagePlaceholder() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate,
              size: 48, color: AppColors.primary.withOpacity(0.6)),
          const SizedBox(height: 12),
          Text(
            'Chưa có ảnh',
            style: TextStyle(
              fontSize: AppFontSize.bodyMedium,
              fontWeight: FontWeight.w600,
              color: AppColors.primary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _images.length,
      itemBuilder: (_, i) => Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              _images[i],
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => setState(() => _images.removeAt(i)),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.redDanger,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerButtons() {
    Widget pickerButton({
      required IconData icon,
      required String label,
      required VoidCallback onPressed,
    }) =>
        OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

    return Row(
      children: [
        Expanded(
          child: pickerButton(
            icon: Icons.camera_alt,
            label: 'Chụp ảnh',
            onPressed: () => _pickImage(source: ImageSource.camera),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: pickerButton(
            icon: Icons.photo_library,
            label: 'Thư viện',
            onPressed: () => _pickImage(source: ImageSource.gallery),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ảnh minh chứng',
          style: TextStyle(
            fontSize: AppFontSize.bodyMedium,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        _images.isEmpty ? _buildImagePlaceholder() : _buildImageGrid(),
        const SizedBox(height: 12),
        _buildImagePickerButtons(),
      ],
    );
  }

  // ─── Description Section ──────────────────────────────────────────────────

  Widget _buildCharCounter() {
    final length = _descController.text.length;
    final isOver = length > _maxLength;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tối thiểu 10 ký tự',
          style: TextStyle(
            fontSize: AppFontSize.labelSmall,
            color: AppColors.textGrey,
          ),
        ),
        Text(
          '$length/$_maxLength ký tự',
          style: TextStyle(
            fontSize: AppFontSize.labelSmall,
            color: isOver ? AppColors.redDanger : AppColors.textGrey,
            fontWeight: isOver ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mô tả vấn đề',
          style: TextStyle(
            fontSize: AppFontSize.bodyMedium,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descController,
          maxLines: 5,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Vd: Thùng rác bị đầy, tràn ra ngoài...',
            hintStyle: const TextStyle(
              color: AppColors.textGrey,
              fontSize: AppFontSize.bodySmall,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.lightCard,
            contentPadding: const EdgeInsets.all(16),
            counterText: '',
          ),
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Nhập mô tả';
            if (v!.length < _minLength) return 'Tối thiểu $_minLength ký tự';
            if (v.length > _maxLength) return 'Tối đa $_maxLength ký tự';
            return null;
          },
        ),
        const SizedBox(height: 8),
        _buildCharCounter(),
      ],
    );
  }

  // ─── Submit Button ────────────────────────────────────────────────────────

  Widget _buildSubmitButton({required bool isLoading}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.lightCard,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.textGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'GỬI BÁO CÁO',
                    style: TextStyle(
                      fontSize: AppFontSize.labelLarge,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportCubit, ReportState>(
      listenWhen: (prev, curr) =>
          curr.action == ReportAction.create && curr.status != prev.status,
      listener: (context, state) {
        if (state.status == ReportStatusState.success) {
          _showSnackBar('Tạo báo cáo thành công!');

          //Cập nhật danh sách user report
          context.read<ReportCubit>().getUserRecentReports(limit: 5);

          //Cập nhật bottomNavBar
          context.read<AppCubit>().toggleBottomBar(true);

          //2 lần pop tương ứng với 2 trang này và BinSelectionPage
          context.pop();
          context.pop();
        }
        if (state.status == ReportStatusState.failure) {
          _showSnackBar(state.message ?? 'Lỗi', isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ReportStatusState.loading &&
            state.action == ReportAction.create;

        return Scaffold(
          backgroundColor: AppColors.lightBg,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.lightCard,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Báo cáo vấn đề',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: AppFontSize.headlineSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBinInfoCard(),
                  const SizedBox(height: 20),
                  _buildImageSection(),
                  const SizedBox(height: 20),
                  _buildDescriptionField(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildSubmitButton(isLoading: isLoading),
        );
      },
    );
  }
}
