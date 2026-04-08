import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbin/configs/font_size.dart';
import 'package:greenbin/models/enums.dart';
import 'package:greenbin/widgets/custom_text.dart';
import 'package:greenbin/widgets/dialog.dart';

import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/auth/auth_state.dart';
import '../../configs/app_color.dart';
import '../../configs/validation.dart';
import '../../widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().login(
          email: _emailController.text.trim(),
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
        body: BlocListener<AuthCubit, AuthState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status && curr.action == AuthAction.login,
          listener: (context, state) {
            if (state.action != AuthAction.login) return;

            if (state.status == AuthStatus.loading) {
              AppDialog.showLoading(context);
            } else {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }

            if (state.status == AuthStatus.failure) {
              AppDialog.showAlert(context,
                  title: 'Lỗi', message: state.message ?? "Có lỗi xảy ra");
            }

            if (state.status == AuthStatus.success &&
                state.action == AuthAction.login) {
              if (state.user!.role == UserRole.resident) {
                context.go('/home'); //Check lại
              } else if (state.user!.role == UserRole.collector) {
                //Điều hướng
              } else {
                //Điều hướng
              }
            }
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildForm(),
                    const SizedBox(height: 32),
                    _buildLoginButton(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Hoặc đăng nhập với"),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildGoogleLogin(),
                    const SizedBox(height: 32),
                    _buildSignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/icons/logo_bg_remove.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.recycling_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "GreenBin Chào Mừng",
          style: TextStyle(
              fontSize: AppFontSize.headlineLarge,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Text(
          "Hành động nhỏ cho hành tinh xanh",
          style: TextStyle(
              color: Colors.grey.shade500, fontSize: AppFontSize.bodyLarge),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            labelText: "Email",
            textFontSize: AppFontSize.bodyLarge,
            controller: _emailController,
            prefixIcon: Icons.mail,
            // textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return ValidationConstants.emptyFieldError;
              }
              final emailRegex = RegExp(ValidationConstants.emailRegex);
              if (!emailRegex.hasMatch(value)) {
                return ValidationConstants.invalidEmailError;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            labelText: "Mật khẩu",
            textFontSize: AppFontSize.bodyLarge,
            controller: _passwordController,
            prefixIcon: FontAwesomeIcons.lock,
            obscureText: true,
            // textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.length < 6) {
                return "Mật khẩu quá ngắn";
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.pushNamed('forgotPassword'),
              child: const CustomText(
                "Quên mật khẩu?",
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: AppFontSize.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status && curr.action == AuthAction.login,
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading &&
            state.action == AuthAction.login;

        return SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: isLoading ? null : _onLoginPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              "ĐĂNG NHẬP",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoogleLogin() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status && curr.action == AuthAction.login,
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading &&
            state.action == AuthAction.login;

        return OutlinedButton(
          onPressed: isLoading
              ? null
              : () => context.read<AuthCubit>().signInWithGoogle(),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            side: BorderSide(color: Colors.grey.shade300),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.google, size: 24, color: Colors.red),
              SizedBox(width: 12),
              Text(
                "Google",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: AppFontSize.bodyLarge,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignUpLink() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: Colors.black54, fontSize: AppFontSize.bodyMedium),
        children: [
          const TextSpan(text: "Bạn chưa có tài khoản? "),
          TextSpan(
            text: "Đăng ký ngay",
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.pushNamed('register'),
          ),
        ],
      ),
    );
  }
}
