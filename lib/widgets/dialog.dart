import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbin/bloc/user/user_cubit.dart';
import 'package:greenbin/configs/font_size.dart';
import 'package:greenbin/widgets/custom_text.dart';

import '../configs/app_color.dart';

class AppDialog {
  AppDialog._();

  /// Alert Dialog with single action
  static Future<void> showAlert(
      BuildContext context, {
        required String title,
        required String message,
        String actionText = 'OK',
        VoidCallback? onAction,
      }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(title,fontSize: AppFontSize.titleLarge,),
        content: CustomText(message,fontSize: AppFontSize.bodyLarge,),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onAction?.call();
            },
            child: CustomText(actionText,fontSize: AppFontSize.bodyLarge,),
          ),
        ],
      ),
    );
  }

  /// Confirmation Dialog with Yes/No
  static Future<bool?> showConfirm(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = 'Yes',
        String cancelText = 'No',
      }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showAssignmentConfirm(
      BuildContext context, {
        required String binCode,
        required String binType,
        required String address,
      }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.assignment_ind_rounded, color: AppColors.primary),
            SizedBox(width: 10),
            Text('Xác nhận nhận việc'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bạn có chắc chắn muốn thu gom thùng rác này không?'),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.qr_code, 'Mã số: ', binCode),
            _buildInfoRow(Icons.category, 'Loại: ', binType),
            _buildInfoRow(Icons.location_on, 'Vị trí: ', address),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy bỏ', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xác nhận nhận', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textGrey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  static Widget loadingDialog(BuildContext context) {
    return PopScope(
      canPop: false, // ← chặn back button vật lý
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Đang xử lý...'),
              ],
            ),
          ),
        ),
      ),
    );
  }


  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext sheetContext) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc muốn đăng xuất khỏi tài khoản này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                //Đóng sheet
                Navigator.pop(sheetContext);

                context.read<UserCubit>().logOut();
                context.pushReplacement('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
              ),
              child: const Text('Đăng xuất',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

}



