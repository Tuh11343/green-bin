import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/bloc/app/app_cubit.dart';
import 'package:greenbin/widgets/dialog.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/user/user_cubit.dart';
import '../../bloc/user_setting/user_profile_cubit.dart';
import '../../bloc/user_setting/user_profile_state.dart';
import '../../configs/app_color.dart';
import '../../configs/font_size.dart';
import '../../models/user.dart';
import '../../repositories/app_repository.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(AppRepository()),
      child: const _UpdateProfileView(),
    );
  }
}

class _UpdateProfileView extends StatefulWidget {
  const _UpdateProfileView();

  @override
  State<_UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<_UpdateProfileView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final currentUser = context.read<UserCubit>().state.user;

    context.read<AppCubit>().toggleBottomBar(false);

    _nameController = TextEditingController(text: currentUser?.name ?? '');
    _emailController = TextEditingController(text: currentUser?.email ?? '');
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handlePickImage({
    required ImageSource source,
    required BuildContext sheetContext,
  }) async {
    // Đóng bottom sheet trước khi mở picker
    Navigator.pop(sheetContext);
    var cubit = context.read<UserProfileCubit>();

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    // Guard: widget còn mounted và user đã chọn ảnh
    if (!mounted || picked == null) return;
    final bytes = await picked.readAsBytes();
    cubit.imageChanged(bytes);
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Thư viện ảnh'),
              onTap: () => _handlePickImage(
                source: ImageSource.gallery,
                sheetContext: sheetContext,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Máy ảnh'),
              onTap: () => _handlePickImage(
                source: ImageSource.camera,
                sheetContext: sheetContext,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context, Uint8List? imageBytes) {
    if (!_formKey.currentState!.validate()) return;
    context.read<UserProfileCubit>().updateProfile(
          name: _nameController.text.trim(),
          currentPass: _currentPasswordController.text,
          newPass: _newPasswordController.text,
          imageBytes: imageBytes,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileCubit, UserProfileState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == UserProfileStatus.loading) {
          debugPrint('Dang loading');
          // AppDialog.showLoading(context);
          return;
        }

        // //Đóng loading dialog
        // if (Navigator.of(context, rootNavigator: true).canPop()) {
        //   Navigator.of(context, rootNavigator: true).pop();
        // }

        if (state.status == UserProfileStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Cập nhật thành công'),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context);
        }

        if (state.status == UserProfileStatus.failure) {
          AppDialog.showAlert(context,
              title: 'Lỗi', message: state.message ?? 'Cập nhật thất bại');
        }
      },
      builder: (context, state) {
        User? truthUser = context.read<UserCubit>().state.user;

        return PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                context.read<AppCubit>().toggleBottomBar(true);
              }
              return;
            },
            child: Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                title: const CustomText(
                  'Cập nhật hồ sơ',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                centerTitle: true,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatarSection(
                        localImage: state.imageBytes,
                        remoteUrl: truthUser?.imageUrl,
                      ),
                      const SizedBox(height: 32),

                      _buildSectionHeader('Thông tin cá nhân'),
                      CustomTextField(
                        textFontSize: AppFontSize.bodyLarge,
                        labelText: 'Họ và tên',
                        controller: _nameController,
                        prefixIcon: Icons.person,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Vui lòng nhập tên'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        textFontSize: AppFontSize.bodyLarge,
                        labelText: 'Email',
                        controller: _emailController,
                        prefixIcon: Icons.email,
                        readOnly: true,
                      ),

                      // Chỉ hiện đổi mật khẩu nếu không phải social login
                      if (truthUser?.isSocialLogin == false) ...[
                        const SizedBox(height: 24),
                        _buildSectionHeader('Đổi mật khẩu'),
                        _buildPasswordFields(),
                      ],

                      const SizedBox(height: 40),
                      _buildSubmitButton(context, state),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Widget _buildAvatarSection({Uint8List? localImage, String? remoteUrl}) {
    ImageProvider? avatarImage;
    if (localImage != null) {
      avatarImage = MemoryImage(localImage);
    } else if (remoteUrl != null && remoteUrl.isNotEmpty) {
      avatarImage = NetworkImage(remoteUrl);
    }

    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
              image: avatarImage != null
                  ? DecorationImage(image: avatarImage, fit: BoxFit.cover)
                  : null,
            ),
            child: avatarImage == null
                ? const Icon(Icons.person, size: 60, color: AppColors.primary)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showImageSourceSheet,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        CustomTextField(
          textFontSize: AppFontSize.bodyLarge,
          labelText: 'Mật khẩu hiện tại',
          controller: _currentPasswordController,
          prefixIcon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          textFontSize: AppFontSize.bodyLarge,
          labelText: 'Mật khẩu mới',
          controller: _newPasswordController,
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          validator: (v) {
            if (v != null && v.isNotEmpty && v.length < 6) {
              return 'Mật khẩu phải ít nhất 6 ký tự';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          textFontSize: AppFontSize.bodyLarge,
          labelText: 'Xác nhận mật khẩu',
          controller: _confirmPasswordController,
          prefixIcon: Icons.lock_reset,
          obscureText: true,
          validator: (v) {
            if (_newPasswordController.text.isNotEmpty &&
                v != _newPasswordController.text) {
              return 'Mật khẩu không khớp';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, UserProfileState state) {
    final isLoading = state.status == UserProfileStatus.loading;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed:
            isLoading ? null : () => _onSubmit(context, state.imageBytes),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const CustomText('Lưu thay đổi'),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomText(title, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
