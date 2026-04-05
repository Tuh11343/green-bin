import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbin/bloc/user/user_cubit.dart';
import 'package:greenbin/widgets/custom_text.dart';
import 'package:greenbin/widgets/dialog.dart';

import '../../bloc/user/user_state.dart';
import '../../configs/font_size.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({Key? key}) : super(key: key);

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool emailUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ABC9C),
        elevation: 0,
        title: const Text(
          'Cài đặt',
          style: TextStyle(
              fontSize: AppFontSize.displayMedium, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              _buildProfileSection(),
              const SizedBox(height: 24),

              // Account Settings
              _buildSectionHeader('Tài khoản'),
              _buildSettingsTile(
                icon: Icons.person,
                title: 'Thông tin cá nhân',
                subtitle: 'Cập nhật hồ sơ của bạn',
              ),
              _buildSettingsTile(
                icon: Icons.security,
                title: 'Bảo mật',
                subtitle: 'Mật khẩu và xác thực',
              ),
              _buildSettingsTile(
                icon: Icons.payment,
                title: 'Phương thức thanh toán',
                subtitle: 'Quản lý thẻ và ví',
              ),
              const SizedBox(height: 16),

              // Notifications
              _buildSectionHeader('Thông báo'),
              _buildToggleTile(
                icon: Icons.notifications,
                title: 'Thông báo',
                subtitle: 'Nhận thông báo từ ứng dụng',
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() => notificationsEnabled = value);
                },
              ),
              _buildToggleTile(
                icon: Icons.email,
                title: 'Cập nhật qua email',
                subtitle: 'Nhận tin tức và ưu đãi',
                value: emailUpdates,
                onChanged: (value) {
                  setState(() => emailUpdates = value);
                },
              ),
              const SizedBox(height: 16),

              // Preferences
              _buildSectionHeader('Tùy chọn'),
              _buildToggleTile(
                icon: Icons.dark_mode,
                title: 'Chế độ tối',
                subtitle: 'Bảo vệ mắt của bạn',
                value: darkModeEnabled,
                onChanged: (value) {
                  setState(() => darkModeEnabled = value);
                },
              ),
              _buildSettingsTile(
                icon: Icons.language,
                title: 'Ngôn ngữ',
                subtitle: 'Tiếng Việt',
              ),
              const SizedBox(height: 16),

              // Help & Support
              _buildSectionHeader('Hỗ trợ'),
              _buildSettingsTile(
                icon: Icons.help,
                title: 'Trợ giúp',
                subtitle: 'FAQ và hướng dẫn',
              ),
              _buildSettingsTile(
                icon: Icons.feedback,
                title: 'Gửi phản hồi',
                subtitle: 'Giúp chúng tôi cải thiện',
              ),
              _buildSettingsTile(
                icon: Icons.info,
                title: 'Về ứng dụng',
                subtitle: 'Phiên bản 1.0.0',
              ),
              const SizedBox(height: 24),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AppDialog.showLogoutDialog(context);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Đăng xuất'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
          //Chỗ này sau này cần thống nhất màu từ AppColor không được hard code
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          //Xem xét bỏ được thì bỏ
          BoxShadow(
            color: const Color(0xFF1ABC9C).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          String? imageUrl = state.user?.imageUrl;
          return Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: ClipOval(
                  child: (imageUrl != null && imageUrl.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person, size: 40),
                        )
                      : CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey[200], // Màu nền
                          foregroundColor: Colors.grey[600], // Màu icon
                          child: const Icon(Icons.person, size: 40),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      state.user?.name ?? 'Nguyễn Văn A',
                      fontSize: AppFontSize.bodyLarge,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      state.user?.email ?? 'nguyenvana@gmail.com',
                      fontSize: AppFontSize.bodyMedium,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.2),
              //     shape: BoxShape.circle,
              //   ),
              //   child: IconButton(
              //     icon: const Icon(Icons.edit, color: Colors.white),
              //     onPressed: () {},
              //     constraints: const BoxConstraints(
              //       minWidth: 40,
              //       minHeight: 40,
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF333333),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF1ABC9C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF1ABC9C), size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: () {
          context.pushNamed('updateProfile');
        },
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF1ABC9C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF1ABC9C), size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1ABC9C),
            inactiveThumbColor: Colors.grey[300],
            inactiveTrackColor: Colors.grey[200],
          ),
        ),
      ),
    );
  }
}
