import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbin/configs/font_size.dart';
import '../bloc/user/user_cubit.dart';
import '../bloc/user/user_state.dart';
import '../configs/app_color.dart';
import '../widgets/custom_text.dart';
import 'dialog.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // 1. Header Drawer
          _buildHeader(context),

          // 2. Danh sách các Menu Item
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(Icons.home_outlined, 'Trang chủ',
                    isSelected: true),
                _buildMenuItem(Icons.location_on_outlined, 'Bản đồ'),
                _buildMenuItem(Icons.eco_outlined, 'Báo cáo rác thải'),
                _buildMenuItem(Icons.card_giftcard_outlined, 'Đổi thưởng'),
                _buildMenuItem(Icons.history_outlined, 'Lịch sử hoạt động'),
                _buildMenuItem(Icons.emoji_events_outlined, 'Bảng xếp hạng'),

                const Divider(indent: 20, endIndent: 20), // Đường kẻ phân cách

                // _buildMenuItem(Icons.person, 'Chỉnh sửa tài khoản',onTap:() {
                //   context.pushNamed('');
                // },),
                _buildMenuItem(Icons.settings_outlined, 'Cài đặt'),
                _buildMenuItem(Icons.help_outline_rounded, 'Trợ giúp'),
                _buildMenuItem(Icons.mail_outline_rounded, 'Liên hệ'),
                _buildMenuItem(
                  Icons.logout_rounded,
                  'Đăng xuất',
                  color: Colors.red,
                  onTap: () {
                    AppDialog.showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),

          // 3. Footer (Thông tin phiên bản)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CustomText('EcoSmart Waste Management',
                    fontSize: AppFontSize.bodySmall, color: AppColors.textGrey),
                CustomText('Phiên bản 1.0.0',
                    fontSize: AppFontSize.bodySmall, color: AppColors.textGrey),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget Header màu xanh phía trên
  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) {
        return previous.status != current.status;
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
          decoration: const BoxDecoration(color: AppColors.primary),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nút Close
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(state.user?.name ?? 'Nguyễn Văn A',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const CustomText('Hạng Bạc',
                            color: Colors.white, fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              // Khối hiển thị điểm nhanh
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText('Điểm xanh hiện tại',
                        color: Colors.white70, fontSize: 14),
                    CustomText(state.user?.points.toString() ?? '1.250',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Widget mẫu cho từng dòng menu
  Widget _buildMenuItem(
    IconData icon,
    String title, {
    bool isSelected = false,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon,
          color:
              color ?? (isSelected ? AppColors.primary : AppColors.textDark)),
      title: CustomText(
        title,
        color: color ?? (isSelected ? AppColors.primary : AppColors.textDark),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onTap: onTap ?? () {},
    );
  }
}
