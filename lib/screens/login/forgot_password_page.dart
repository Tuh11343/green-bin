import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbin/widgets/custom_text.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/auth/auth_state.dart';
import '../../configs/app_color.dart';
import '../../configs/font_size.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();

  int _currentStep = 1; // 1: Nhập Email, 2: Nhập OTP, 3: Mật khẩu mới

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<AuthCubit>();
    final email = _emailController.text.trim();

    if (_currentStep == 1) {
      cubit.forgotPassword(email);
    } else if (_currentStep == 2) {
      cubit.verifyOTP(email, _otpController.text.trim());
    } else {
      cubit.resetPassword(
        email: email,
        otp: _otpController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status, // không cần check bởi vì đâu có chỗ nào dùng thằng Auth dưới
      listener: (context, state) {
        if (state.action != AuthAction.forgotPassword &&
            state.action != AuthAction.verifyOtp &&
            state.action != AuthAction.resetPassword) {
          return;
        }

        if (state.status == AuthStatus.loading) {
          AppDialog.showLoading(context);
        } else {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }

        if (state.status == AuthStatus.failure) {
          AppDialog.showAlert(context,
              title: 'Lỗi', message: state.message ?? 'Có lỗi xảy ra');
        }

        if (state.status == AuthStatus.success) {
          if (state.action == AuthAction.forgotPassword && _currentStep == 1) {
            setState(() => _currentStep = 2);
          } else if (state.action == AuthAction.verifyOtp &&
              _currentStep == 2) {
            setState(() => _currentStep = 3);
          } else if (state.action == AuthAction.resetPassword &&
              _currentStep == 3) {
            AppDialog.showAlert(context, title: 'Thông báo', message: 'Đổi mật khẩu thành công',onAction: () => context.pop(),);

            // context.pop();
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.black, size: 20),
              onPressed: () {
                if (_currentStep > 1) {
                  setState(() => _currentStep--);
                } else {
                  context.pop();
                }
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Form(
                key: _formKey,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey(_currentStep),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildInputFields(),
                      const SizedBox(height: 40),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String title = "Quên mật khẩu?";
    String sub = "Nhập email của bạn để nhận mã xác thực OTP.";

    if (_currentStep == 2) {
      title = "Xác thực mã OTP";
      sub = "Mã xác thực đã được gửi đến email: ${_emailController.text}";
    } else if (_currentStep == 3) {
      title = "Mật khẩu mới";
      sub = "Thiết lập mật khẩu mới để bảo vệ tài khoản của bạn.";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(title,
            fontSize: AppFontSize.headlineMedium, fontWeight: FontWeight.bold),
        const SizedBox(height: 12),
        CustomText(sub,
            fontSize: AppFontSize.bodyLarge,
            color: Colors.grey.shade600,
            height: 1.5),
      ],
    );
  }

  Widget _buildInputFields() {
    if (_currentStep == 1) {
      return CustomTextField(
        labelText: "Email đăng ký",
        textFontSize: AppFontSize.bodyLarge,
        controller: _emailController,
        prefixIcon: Icons.email_outlined,
        validator: (v) =>
            (v == null || !v.contains('@')) ? "Email không hợp lệ" : null,
      );
    } else if (_currentStep == 2) {
      return CustomTextField(
        labelText: "Mã OTP (6 số)",
        textFontSize: AppFontSize.bodyLarge,
        controller: _otpController,
        prefixIcon: Icons.lock_clock_outlined,
        isNumber: true,
        validator: (v) => (v?.length != 6) ? "Mã OTP phải có 6 chữ số" : null,
      );
    } else {
      return CustomTextField(
        labelText: "Mật khẩu mới",
        textFontSize: AppFontSize.bodyLarge,
        controller: _newPasswordController,
        prefixIcon: Icons.vpn_key_outlined,
        obscureText: true,
        validator: (v) =>
            (v == null || v.length < 6) ? "Mật khẩu tối thiểu 6 ký tự" : null,
      );
    }
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.status!=current.status,
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        String text = _currentStep == 1
            ? "GỬI MÃ OTP"
            : (_currentStep == 2 ? "XÁC NHẬN MÃ" : "CẬP NHẬT MẬT KHẨU");

        return Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5))
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : _onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : Text(text,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
          ),
        );
      },
    );
  }
}
