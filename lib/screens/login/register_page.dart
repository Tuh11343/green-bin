import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbin/configs/font_size.dart';
import 'package:greenbin/widgets/custom_text.dart';
import 'package:greenbin/widgets/dialog.dart';

import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/auth/auth_state.dart';
import '../../configs/app_color.dart';
import '../../configs/validation.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/snack_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Gọi hàm signUp từ Cubit
  void _onSignUpPressed() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      AppDialog.showAlert(context,
          title: 'Thông báo', message: 'Vui lòng đồng ý với điều khoản');
      return;
    }

    context.read<AuthCubit>().signUp(
          email: _emailController.text.trim(),
          name: _nameController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.action == AuthAction.register,
          listener: (context, state) {
            if (state.action != AuthAction.register) return;

            if (state.status == AuthStatus.loading) {
              AppDialog.showLoading(context);
            } else {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }

            if (state.status == AuthStatus.failure) {
              AppDialog.showAlert(context,
                  title: 'Thông báo', message: 'Đăng ký thất bại');
            }
            if (state.status == AuthStatus.success) {
              AppDialog.showAlert(context, title: 'Thông báo', message: 'Đăng ký thành công',onAction: () => context.go('/home'),);
              // context.go('/home'); //Lưu ý thằng này chưa phân role
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildSignUpForm(),
                  const SizedBox(height: 24),
                  _buildSignUpButton(),
                  const SizedBox(height: 24),
                  _buildLoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText("Tạo tài khoản mới",
            fontSize: AppFontSize.headlineMedium,
            fontWeight: FontWeight.bold,
            color: Colors.black87),
        const SizedBox(height: 8),
        CustomText("Gia nhập cộng đồng GreenBin để bảo vệ môi trường",
            fontSize: AppFontSize.bodyMedium, color: Colors.grey.shade600),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            textFontSize: AppFontSize.bodyLarge,
            labelText: "Họ và tên",
            controller: _nameController,
            prefixIcon: Icons.person_outline,
            // textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return ValidationConstants.emptyFieldError;
              }
              if (value.length < 3) return "Tên quá ngắn";
              return null;
            },
          ),
          const SizedBox(height: 18),
          CustomTextField(
            textFontSize: AppFontSize.bodyLarge,
            labelText: "Email",
            controller: _emailController,
            prefixIcon: Icons.mail_outline,
            // textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return ValidationConstants.emptyFieldError;
              }
              if (!RegExp(ValidationConstants.emailRegex).hasMatch(value)) {
                return ValidationConstants.invalidEmailError;
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          CustomTextField(
            textFontSize: AppFontSize.bodyLarge,
            labelText: "Mật khẩu",
            controller: _passwordController,
            prefixIcon: FontAwesomeIcons.lock,
            obscureText: true,
            // textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return ValidationConstants.emptyFieldError;
              }
              if (value.length < 6) {
                return ValidationConstants.passwordTooShortError;
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          CustomTextField(
            textFontSize: AppFontSize.bodyLarge,
            labelText: "Xác nhận mật khẩu",
            controller: _confirmPasswordController,
            prefixIcon: FontAwesomeIcons.shieldHalved,
            obscureText: true,
            // textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return ValidationConstants.emptyFieldError;
              }
              if (value != _passwordController.text) {
                return ValidationConstants.passwordMismatchError;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          _buildTermsCheckbox(),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _agreeTerms,
            onChanged: (value) => setState(() => _agreeTerms = value ?? false),
            activeColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: "Tôi đồng ý với ",
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              children: [
                TextSpan(
                  text: "Điều khoản",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: " & "),
                TextSpan(
                  text: "Chính sách bảo mật",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.status != current.status &&
          current.action == AuthAction.register,
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : _onSignUpPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const CustomText("ĐĂNG KÝ NGAY",
                fontSize: AppFontSize.bodyLarge,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black54, fontSize: 15),
          children: [
            const TextSpan(text: "Đã có tài khoản? "),
            TextSpan(
              text: "Đăng nhập",
              style: const TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
