// // lib/bloc/theme/theme_cubit.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
//
// import '../../services/storage/app_storage.dart';
//
// /// Theme mode enum
// enum ThemeMode {
//   light,
//   dark,
// }
//
// extension ThemeModeExtension on ThemeMode {
//   String toJson() => name;
//
//   static ThemeMode fromJson(String json) {
//     return ThemeMode.values.firstWhere(
//           (mode) => mode.name == json,
//       orElse: () => ThemeMode.light,
//     );
//   }
// }
//
// /// Theme state
// class ThemeState extends Equatable {
//   final ThemeMode themeMode;
//   final bool isDarkMode;
//
//   const ThemeState({
//     this.themeMode = ThemeMode.light,
//   }) : isDarkMode = themeMode == ThemeMode.dark;
//
//   ThemeState copyWith({
//     ThemeMode? themeMode,
//   }) {
//     return ThemeState(
//       themeMode: themeMode ?? this.themeMode,
//     );
//   }
//
//   @override
//   List<Object?> get props => [themeMode, isDarkMode];
// }
//
// /// Theme cubit
// class ThemeCubit extends Cubit<ThemeState> {
//   ThemeCubit() : super(const ThemeState());
//
//   /// Initialize theme từ storage
//   Future<void> initialize() async {
//     try {
//       final themeString = await _getStoredTheme();
//       final themeMode = ThemeModeExtension.fromJson(themeString);
//       emit(ThemeState(themeMode: themeMode));
//     } catch (e) {
//       // Default to light mode
//       emit(const ThemeState(themeMode: ThemeMode.light));
//     }
//   }
//
//   /// Toggle theme (light <-> dark)
//   Future<void> toggleTheme() async {
//     final newMode = state.themeMode == ThemeMode.light
//         ? ThemeMode.dark
//         : ThemeMode.light;
//
//     await setTheme(newMode);
//   }
//
//   /// Set theme cụ thể
//   Future<void> setTheme(ThemeMode mode) async {
//     try {
//       // Save to storage
//       await _saveTheme(mode.name);
//
//       // Emit new state
//       emit(ThemeState(themeMode: mode));
//     } catch (e) {
//       print('Error setting theme: $e');
//     }
//   }
//
//   /// Set dark mode
//   Future<void> setDarkMode() async {
//     await setTheme(ThemeMode.dark);
//   }
//
//   /// Set light mode
//   Future<void> setLightMode() async {
//     await setTheme(ThemeMode.light);
//   }
//
//   /// Save theme to storage
//   Future<void> _saveTheme(String theme) async {
//     // Dùng SharedPreferences vì theme không phải sensitive data
//     // Bạn có thể thay đổi nếu muốn
//     try {
//       // Nếu bạn có AppStorage.saveTheme()
//       // await AppStorage.saveTheme(theme);
//
//       // Hoặc dùng SharedPreferences trực tiếp
//       // SharedPreferences prefs = await SharedPreferences.getInstance();
//       // await prefs.setString('theme_mode', theme);
//     } catch (e) {
//       print('Error saving theme: $e');
//     }
//   }
//
//   /// Get stored theme
//   Future<String> _getStoredTheme() async {
//     try {
//       // return await AppStorage.getTheme() ?? 'light';
//
//       // Hoặc dùng SharedPreferences
//       // SharedPreferences prefs = await SharedPreferences.getInstance();
//       // return prefs.getString('theme_mode') ?? 'light';
//
//       return 'light'; // Default
//     } catch (e) {
//       return 'light';
//     }
//   }
// }
//
// // lib/themes/app_theme.dart
// import 'package:flutter/material.dart';
//
// import '../config/app_colors.dart';
//
// class AppTheme {
//   AppTheme._();
//
//   /// Light theme
//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//
//       // ==================== PRIMARY COLORS ====================
//       primaryColor: AppColors.primary,
//       primaryColorDark: AppColors.primaryDark,
//       primaryColorLight: AppColors.primaryLight,
//
//       // ==================== COLOR SCHEME ====================
//       colorScheme: ColorScheme.light(
//         primary: AppColors.primary,
//         primaryContainer: AppColors.primaryLight,
//         secondary: AppColors.blueInfo,
//         secondaryContainer: AppColors.blueLight,
//         surface: AppColors.lightBg,
//         background: AppColors.lightBg,
//         error: AppColors.redDanger,
//         onPrimary: Colors.white,
//         onSecondary: Colors.white,
//         onSurface: AppColors.textDark,
//         onBackground: AppColors.textDark,
//         onError: Colors.white,
//       ),
//
//       // ==================== SCAFFOLD THEME ====================
//       scaffoldBackgroundColor: AppColors.lightBg,
//
//       // ==================== APP BAR THEME ====================
//       appBarTheme: AppBarTheme(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         titleTextStyle: const TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//
//       // ==================== CARD THEME ====================
//       cardTheme: CardTheme(
//         color: AppColors.lightCard,
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//
//       // ==================== BUTTON THEMES ====================
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//         ),
//       ),
//
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: AppColors.primary,
//         ),
//       ),
//
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           side: const BorderSide(color: AppColors.primary),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//
//       // ==================== INPUT DECORATION THEME ====================
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: Colors.white,
//         hintStyle: const TextStyle(color: AppColors.textGrey),
//         labelStyle: const TextStyle(color: AppColors.textDark),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.textGrey),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.textGrey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(
//             color: AppColors.primary,
//             width: 2,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.redDanger),
//         ),
//       ),
//
//       // ==================== TEXT THEMES ====================
//       textTheme: const TextTheme(
//         displayLarge: TextStyle(
//           fontSize: 32,
//           fontWeight: FontWeight.bold,
//           color: AppColors.textDark,
//         ),
//         displayMedium: TextStyle(
//           fontSize: 28,
//           fontWeight: FontWeight.bold,
//           color: AppColors.textDark,
//         ),
//         displaySmall: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: AppColors.textDark,
//         ),
//         headlineMedium: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textDark,
//         ),
//         headlineSmall: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textDark,
//         ),
//         titleLarge: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textDark,
//         ),
//         titleMedium: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: AppColors.textDark,
//         ),
//         titleSmall: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: AppColors.textGrey,
//         ),
//         bodyLarge: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.normal,
//           color: AppColors.textDark,
//         ),
//         bodyMedium: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.normal,
//           color: AppColors.textDark,
//         ),
//         bodySmall: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.normal,
//           color: AppColors.textGrey,
//         ),
//       ),
//
//       // ==================== ICON THEME ====================
//       iconTheme: const IconThemeData(
//         color: AppColors.textDark,
//         size: 24,
//       ),
//
//       // ==================== CHECKBOX & RADIO ====================
//       checkboxTheme: CheckboxThemeData(
//         fillColor: MaterialStateProperty.all(AppColors.primary),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ),
//
//       radioTheme: RadioThemeData(
//         fillColor: MaterialStateProperty.all(AppColors.primary),
//       ),
//
//       // ==================== SWITCH ====================
//       switchTheme: SwitchThemeData(
//         thumbColor: MaterialStateProperty.all(AppColors.primary),
//         trackColor: MaterialStateProperty.all(AppColors.primaryLight),
//       ),
//
//       // ==================== BOTTOM NAVIGATION ====================
//       bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//         backgroundColor: AppColors.lightCard,
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: AppColors.textGrey,
//         elevation: 8,
//       ),
//
//       // ==================== DIALOG ====================
//       dialogTheme: DialogTheme(
//         backgroundColor: AppColors.lightCard,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//
//       // ==================== SNACKBAR ====================
//       snackBarTheme: SnackBarThemeData(
//         backgroundColor: AppColors.darkBg,
//         contentTextStyle: const TextStyle(color: Colors.white),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }
//
//   /// Dark theme
//   static ThemeData get darkTheme {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.dark,
//
//       // ==================== PRIMARY COLORS ====================
//       primaryColor: AppColors.primary,
//       primaryColorDark: AppColors.primaryDark,
//
//       // ==================== COLOR SCHEME ====================
//       colorScheme: ColorScheme.dark(
//         primary: AppColors.primary,
//         primaryContainer: const Color(0xFF1E5631),
//         secondary: AppColors.blueInfo,
//         secondaryContainer: const Color(0xFF1E3A5F),
//         surface: AppColors.darkCard,
//         background: AppColors.darkBg,
//         error: AppColors.redDanger,
//         onPrimary: Colors.white,
//         onSecondary: Colors.white,
//         onSurface: AppColors.textWhite,
//         onBackground: AppColors.textWhite,
//         onError: Colors.white,
//       ),
//
//       // ==================== SCAFFOLD THEME ====================
//       scaffoldBackgroundColor: AppColors.darkBg,
//
//       // ==================== APP BAR THEME ====================
//       appBarTheme: AppBarTheme(
//         backgroundColor: AppColors.darkCard,
//         foregroundColor: AppColors.textWhite,
//         elevation: 0,
//         centerTitle: true,
//         titleTextStyle: const TextStyle(
//           color: AppColors.textWhite,
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//
//       // ==================== CARD THEME ====================
//       cardTheme: CardTheme(
//         color: AppColors.darkCard,
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//
//       // ==================== BUTTON THEMES ====================
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//         ),
//       ),
//
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: AppColors.primary,
//         ),
//       ),
//
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           side: const BorderSide(color: AppColors.primary),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//
//       // ==================== INPUT DECORATION THEME ====================
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: const Color(0xFF3A3F4B),
//         hintStyle: const TextStyle(color: AppColors.textMuted),
//         labelStyle: const TextStyle(color: AppColors.textWhite),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.textMuted),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.textMuted),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(
//             color: AppColors.primary,
//             width: 2,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: AppColors.redDanger),
//         ),
//       ),
//
//       // ==================== TEXT THEMES ====================
//       textTheme: const TextTheme(
//         displayLarge: TextStyle(
//           fontSize: 32,
//           fontWeight: FontWeight.bold,
//           color: AppColors.textWhite,
//         ),
//         displayMedium: TextStyle(
//           fontSize: 28,
//           fontWeight: FontWeight.bold,
//           color: AppColors.textWhite,
//         ),
//         displaySmall: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: AppColors.textWhite,
//         ),
//         headlineMedium: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textWhite,
//         ),
//         headlineSmall: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textWhite,
//         ),
//         titleLarge: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textWhite,
//         ),
//         titleMedium: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: AppColors.textWhite,
//         ),
//         titleSmall: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: AppColors.textMuted,
//         ),
//         bodyLarge: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.normal,
//           color: AppColors.textWhite,
//         ),
//         bodyMedium: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.normal,
//           color: AppColors.textWhite,
//         ),
//         bodySmall: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.normal,
//           color: AppColors.textMuted,
//         ),
//       ),
//
//       // ==================== ICON THEME ====================
//       iconTheme: const IconThemeData(
//         color: AppColors.textWhite,
//         size: 24,
//       ),
//
//       // ==================== CHECKBOX & RADIO ====================
//       checkboxTheme: CheckboxThemeData(
//         fillColor: MaterialStateProperty.all(AppColors.primary),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ),
//
//       radioTheme: RadioThemeData(
//         fillColor: MaterialStateProperty.all(AppColors.primary),
//       ),
//
//       // ==================== SWITCH ====================
//       switchTheme: SwitchThemeData(
//         thumbColor: MaterialStateProperty.all(AppColors.primary),
//         trackColor: MaterialStateProperty.all(AppColors.primaryDark),
//       ),
//
//       // ==================== BOTTOM NAVIGATION ====================
//       bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//         backgroundColor: AppColors.darkCard,
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: AppColors.textMuted,
//         elevation: 8,
//       ),
//
//       // ==================== DIALOG ====================
//       dialogTheme: DialogTheme(
//         backgroundColor: AppColors.darkCard,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//
//       // ==================== SNACKBAR ====================
//       snackBarTheme: SnackBarThemeData(
//         backgroundColor: AppColors.darkCard,
//         contentTextStyle: const TextStyle(color: AppColors.textWhite),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }
// }
//
// // lib/widgets/settings_widgets.dart
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import '../config/app_colors.dart';
// import '../config/font_size.dart';
// import '../models/enums.dart';
// import '../models/report.dart';
// import '../utils/time_helper.dart';
// import '../widgets/custom_card.dart';
// import '../widgets/custom_text.dart';
//
// /// ==================== AppBar Title ====================
//
// Widget buildAppBarTitle(BuildContext context) {
//   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       CustomText(
//         'Xin chào,',
//         fontSize: AppFontSize.bodySmall,
//         // Dùng textMuted color từ theme
//         color: isDarkMode ? AppColors.textMuted : Colors.white70,
//       ),
//       CustomText(
//         'Nguyễn Văn A',
//         fontWeight: FontWeight.bold,
//         // Text color dùng themewhite
//         color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
//       ),
//     ],
//   );
// }
//
// /// ==================== Quick Task Card ====================
//
// Widget buildQuickTaskCard(
//     BuildContext context, {
//       required IconData icon,
//       required String title,
//       required String description,
//       required Color cardColor,
//       Color? titleColor,
//       Color? descriptionColor,
//     }) {
//   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//   return CustomCard(
//     color: cardColor,
//     child: Column(
//       children: [
//         FaIcon(
//           icon,
//           // Nếu không có titleColor, dùng primary color từ theme
//           color: titleColor ?? Theme.of(context).primaryColor,
//           size: AppFontSize.bodyLarge,
//         ),
//         CustomText(
//           title,
//           color: titleColor ?? Theme.of(context).primaryColor,
//           fontSize: AppFontSize.bodyMedium,
//         ),
//         CustomText(
//           description,
//           // Description color: grey cho light, muted cho dark
//           color: descriptionColor ??
//               (isDarkMode
//                   ? AppColors.textMuted
//                   : Colors.grey[600]),
//           fontSize: AppFontSize.bodyMedium,
//         ),
//       ],
//     ),
//   );
// }
//
// /// ==================== Activity Item ====================
//
// Widget buildActivityItem(
//     BuildContext context, {
//       required Report report,
//       required IconData icon,
//       Color? iconColor,
//     }) {
//   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//   return CustomCard(
//     margin: const EdgeInsets.only(bottom: 12),
//     padding: const EdgeInsets.all(16),
//     // Dùng surface color từ theme
//     color: Theme.of(context).colorScheme.surface,
//     hasShadow: false,
//     // Border color: light grey cho light, dark grey cho dark
//     borderColor: isDarkMode
//         ? Colors.grey.shade800
//         : Colors.grey.shade100,
//     child: Row(
//       children: [
//         // 1. Icon bên trái
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             // Icon color: primary hoặc custom
//             color: (iconColor ?? Theme.of(context).primaryColor)
//                 .withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             icon,
//             color: iconColor ?? Theme.of(context).primaryColor,
//             size: 20,
//           ),
//         ),
//         const SizedBox(width: 15),
//
//         // 2. Nội dung text ở giữa
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                 'Báo Cáo Rác Thải',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//                 // Dùng title text style từ theme
//                 color: Theme.of(context).textTheme.titleMedium?.color,
//               ),
//               const SizedBox(height: 4),
//               CustomText(
//                 report.description,
//                 // Grey text: bodySmall color từ theme
//                 color: isDarkMode
//                     ? AppColors.textMuted
//                     : Colors.grey[600],
//                 fontSize: 13,
//               ),
//               const SizedBox(height: 4),
//               CustomText(
//                 TimeHelper.format(report.createdAt),
//                 // Muted text
//                 color: isDarkMode
//                     ? AppColors.textMuted.withOpacity(0.7)
//                     : Colors.grey.shade400,
//                 fontSize: 12,
//               ),
//             ],
//           ),
//         ),
//
//         // 3. Điểm và Trạng thái bên phải
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             CustomText(
//               '+ 50',
//               fontWeight: FontWeight.bold,
//               // Màu xanh nếu có +, đỏ nếu không
//               color: Theme.of(context).primaryColor,
//             ),
//             const SizedBox(height: 8),
//             // Hiển thị Badge "Đang xử lý" hoặc Icon "Hoàn thành"
//             report.status == ReportStatus.processing
//                 ? Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 8,
//                 vertical: 2,
//               ),
//               decoration: BoxDecoration(
//                 // Badge background: light grey
//                 color: isDarkMode
//                     ? Colors.grey.shade800
//                     : Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: CustomText(
//                 'Đang xử lý',
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//                 // Badge text color
//                 color: isDarkMode
//                     ? AppColors.textMuted
//                     : Colors.grey[600],
//               ),
//             )
//                 : Icon(
//               Icons.check_circle_outline,
//               color: Theme.of(context).primaryColor,
//               size: 18,
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// /// ==================== UTILS - Get theme colors ====================
//
// /// Lấy text color phù hợp với theme
// Color getTextColor(BuildContext context, {bool isMuted = false}) {
//   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//   if (isMuted) {
//     return isDarkMode ? AppColors.textMuted : Colors.grey[600]!;
//   }
//
//   return isDarkMode ? AppColors.textWhite : AppColors.textDark;
// }
//
// /// Lấy background color phù hợp
// Color getBackgroundColor(BuildContext context) {
//   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//   return isDarkMode ? AppColors.darkBg : AppColors.lightBg;
// }
//
// /// Lấy surface color (card background)
// Color getSurfaceColor(BuildContext context) {
//   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//   return isDarkMode ? AppColors.darkCard : AppColors.lightCard;
// }
//
// /// Lấy border color
// Color getBorderColor(BuildContext context) {
//   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//   return isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;
// }
//
// /// Lấy icon background color
// Color getIconBackgroundColor(BuildContext context) {
//   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//   return isDarkMode
//       ? Theme.of(context).primaryColor.withOpacity(0.2)
//       : Theme.of(context).primaryColor.withOpacity(0.1);
// }

// class SearchBarCustom extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final bool isLoading;
//   final ValueChanged<String> onChanged;
//   final VoidCallback onClear;
//
//   const SearchBarCustom({
//     required this.controller,
//     required this.focusNode,
//     required this.isLoading,
//     required this.onChanged,
//     required this.onClear,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       focusNode: focusNode,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         hintText: 'Tìm kiếm địa điểm...',
//         hintStyle: const TextStyle(color: AppColors.textGrey),
//         prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
//         suffixIcon: isLoading
//             ? const Padding(
//           padding: EdgeInsets.all(12.0),
//           child: SizedBox(
//             width: 20,
//             height: 20,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//               valueColor:
//               AlwaysStoppedAnimation<Color>(AppColors.primary),
//             ),
//           ),
//         )
//             : controller.text.isNotEmpty
//             ? IconButton(
//           icon: const Icon(Icons.clear, color: AppColors.textGrey),
//           onPressed: onClear,
//         )
//             : null,
//         filled: true,
//         fillColor: AppColors.lightCard,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding:
//         const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       ),
//     );
//   }
// }
//
// // Search Results Dropdown Widget
// class SearchResultsDropdown extends StatelessWidget {
//   final List<SearchResult> results;
//   final bool isLoading;
//   final Function(SearchResult) onResultTap;
//
//   const SearchResultsDropdown({
//     required this.results,
//     required this.isLoading,
//     required this.onResultTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       elevation: 8,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         constraints: const BoxConstraints(maxHeight: 300),
//         decoration: BoxDecoration(
//           color: AppColors.lightCard,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: isLoading
//             ? const Center(
//           child: Padding(
//             padding: EdgeInsets.all(20.0),
//             child: CircularProgressIndicator(
//               valueColor:
//               AlwaysStoppedAnimation<Color>(AppColors.primary),
//             ),
//           ),
//         )
//             : results.isEmpty
//             ? const Padding(
//           padding: EdgeInsets.all(20.0),
//           child: Center(
//             child: Text(
//               'Không tìm thấy kết quả',
//               style: TextStyle(
//                 color: AppColors.textGrey,
//                 fontSize: AppFontSize.bodyMedium,
//               ),
//             ),
//           ),
//         )
//             : ListView.separated(
//           shrinkWrap: true,
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           itemCount: results.length,
//           separatorBuilder: (context, index) => const Divider(
//             height: 1,
//             indent: 16,
//             endIndent: 16,
//           ),
//           itemBuilder: (context, index) {
//             final result = results[index];
//             return ListTile(
//               leading: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.location_on,
//                   color: AppColors.primary,
//                   size: 20,
//                 ),
//               ),
//               title: Text(
//                 result.shortName,
//                 style: const TextStyle(
//                   fontSize: AppFontSize.bodyMedium,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textDark,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               subtitle: Text(
//                 result.displayName,
//                 style: const TextStyle(
//                   fontSize: AppFontSize.bodySmall,
//                   color: AppColors.textGrey,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               trailing: const Icon(
//                 Icons.arrow_forward_ios,
//                 size: 16,
//                 color: AppColors.textGrey,
//               ),
//               onTap: () => onResultTap(result),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class MapCubit extends Cubit<MapState> {
//   MapCubit() : super(const MapState());
//
//   final GeocodingRepository _geocodingRepository=GeocodingRepository();
//
//   void initialize() {
//     emit(state.copyWith(status: MapStatus.loading));
//
//     try {
//       // Mock data bins
//       final bins = [
//         Bin(
//           id: 1,
//           latitude: 10.7769,
//           longitude: 106.7009,
//           type: BinType.recyclable,
//           fillLevel: FillLevel.high,
//           reportCount: 3,
//         ),
//         Bin(
//           id: 2,
//           latitude: 10.7772,
//           longitude: 106.7015,
//           type: BinType.organic,
//           fillLevel: FillLevel.medium,
//           reportCount: 1,
//         ),
//         Bin(
//           id: 3,
//           latitude: 10.7765,
//           longitude: 106.7020,
//           type: BinType.non_recyclable,
//           fillLevel: FillLevel.low,
//           reportCount: 0,
//         ),
//         Bin(
//           id: 4,
//           latitude: 10.7760,
//           longitude: 106.7010,
//           type: BinType.recyclable,
//           fillLevel: FillLevel.low,
//           reportCount: 2,
//         ),
//       ];
//
//       emit(state.copyWith(
//         status: MapStatus.success,
//         bins: bins,
//         displayBins: bins
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         status: MapStatus.failure,
//         errorMessage: 'Không thể tải dữ liệu thùng rác',
//       ));
//     }
//   }
//
//   void selectBin(Bin? bin) {
//     emit(state.copyWith(
//       selectedBin: bin,
//       searchResults: [], // Clear search results khi chọn bin
//       showSearchResults: false,
//     ));
//   }
//
//   void closeBinDetail() {
//     emit(state.copyWith(selectedBin: null));
//   }
//
//   void searchLocation(String query) {
//     if (query.trim().isEmpty) {
//       emit(state.copyWith(
//         searchQuery: query,
//         searchResults: [],
//         showSearchResults: false,
//         searchStatus: SearchStatus.initial,
//       ));
//       return;
//     }
//
//     emit(state.copyWith(
//       searchQuery: query,
//       searchStatus: SearchStatus.loading,
//       showSearchResults: true,
//     ));
//
//     // Debounce sẽ được xử lý ở UI layer với RxDart
//     _performSearch(query);
//   }
//
//   Future<void> _performSearch(String query) async {
//     try {
//       print('Đang tìm: "$query"');
//       final rawData = await _geocodingRepository.searchLocation(
//         query: query,
//         limit: 5,
//         countryCode: 'vn',
//         viewbox: '106.3,10.3,107.0,11.2',
//       );
//
//       print('Raw response length: ${rawData.length}');
//       if (rawData.isNotEmpty) {
//         print('Kết quả đầu tiên: ${rawData.first}');
//       } else {
//         print('Response rỗng hoàn toàn');
//       }
//
//       print('Sau parse: ${rawData.length} kết quả');
//
//       if (state.searchQuery == query) {
//         emit(state.copyWith(
//           searchResults: rawData,
//           searchStatus: SearchStatus.success, // Chuyển sang success để tắt loading
//           showSearchResults: true,
//         ));
//       }
//     } catch (e, stack) {
//       print('Lỗi search: $e');
//       print('Stack: $stack');
//     }
//   }
//
//   void selectSearchResult(SearchResult result) {
//     emit(state.copyWith(
//       selectedSearchResult: result,
//       searchQuery: result.shortName,
//       showSearchResults: false,
//       selectedBin: null, // Clear bin selection
//     ));
//   }
//
//   void clearSearch() {
//     emit(state.copyWith(
//       searchQuery: '',
//       searchResults: [],
//       showSearchResults: false,
//       selectedSearchResult: null,
//       searchStatus: SearchStatus.initial,
//     ));
//   }
//
//   void toggleSearchResults(bool show) {
//     emit(state.copyWith(showSearchResults: show));
//   }
//
//   void moveToLocation(LatLng position, {double zoom = 16.0}) {
//     emit(state.copyWith(
//       targetPosition: position,
//       targetZoom: zoom,
//     ));
//   }
//
//   void filterBinsByType(BinType? type) {
//     emit(state.copyWith(
//       filterType: type,
//       displayBins: type == null
//           ? state.bins
//           : state.bins.where((bin) => bin.type == type).toList(),
//     ));
//   }
//
//   void filterBinsByFillLevel(FillLevel? level) {
//     emit(state.copyWith(
//       filterFillLevel: level,
//       displayBins: level == null
//           ? state.bins
//           : state.bins.where((bin) => bin.fillLevel == level).toList(),
//     ));
//   }
//
//   void clearFilters() {
//     emit(state.copyWith(
//       filterType: null,
//       filterFillLevel: null,
//       displayBins: state.bins,
//     ));
//   }
//
//   Future<void> refresh() async {
//     emit(state.copyWith(status: MapStatus.loading));
//
//     await Future.delayed(const Duration(milliseconds: 500));
//
//     try {
//       // TODO: Thay bằng API call thực tế
//       initialize();
//     } catch (e) {
//       emit(state.copyWith(
//         status: MapStatus.failure,
//         errorMessage: 'Không thể tải lại dữ liệu',
//       ));
//     }
//   }
//
//   Future<void> reportBin(int binId, String issue) async {
//     try {
//       // TODO: Implement API call
//       await Future.delayed(const Duration(seconds: 1));
//
//       // Cập nhật report count
//       final updatedBins = state.bins.map((bin) {
//         if (bin.id == binId) {
//           return bin.copyWith(reportCount: bin.reportCount + 1);
//         }
//         return bin;
//       }).toList();
//
//       emit(state.copyWith(
//         bins: updatedBins,
//         displayBins: updatedBins,
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         errorMessage: 'Không thể gửi báo cáo',
//       ));
//     }
//   }
//
//   Future<void> reverseGeocode(LatLng position) async {
//     try {
//       final result = await _geocodingRepository.reverseGeocode(
//         position
//       );
//
//       if (result != null) {
//         emit(state.copyWith(
//           reverseGeocodeResult: result.displayName,
//         ));
//       }
//     } catch (e) {
//       // Silent fail cho reverse geocoding
//       emit(state.copyWith(reverseGeocodeResult: null));
//     }
//   }
// }


// /// Status cho map loading
// enum MapStatus {
//   initial,
//   loading,
//   success,
//   failure,
// }
//
// /// Status cho search
// enum SearchStatus {
//   initial,
//   loading,
//   success,
//   failure,
// }
//
// /// State cho Map page
// class MapState extends Equatable {
//   final MapStatus status;
//   final SearchStatus searchStatus;
//
//   // Bin data
//   final List<Bin> bins;
//   final List<Bin> displayBins; // Bins sau khi filter
//   final Bin? selectedBin;
//
//   // Search
//   final String searchQuery;
//   final List<SearchResult> searchResults;
//   final bool showSearchResults;
//   final SearchResult? selectedSearchResult;
//
//   // Filter
//   final BinType? filterType;
//   final FillLevel? filterFillLevel;
//
//   // Map control
//   final LatLng? targetPosition;
//   final double? targetZoom;
//
//   // Error handling
//   final String? errorMessage;
//
//   // Reverse geocoding
//   final String? reverseGeocodeResult;
//
//   const MapState({
//     this.status = MapStatus.initial,
//     this.searchStatus = SearchStatus.initial,
//     this.bins = const [],
//     this.displayBins = const [],
//     this.selectedBin,
//     this.searchQuery = '',
//     this.searchResults = const [],
//     this.showSearchResults = false,
//     this.selectedSearchResult,
//     this.filterType,
//     this.filterFillLevel,
//     this.targetPosition,
//     this.targetZoom,
//     this.errorMessage,
//     this.reverseGeocodeResult,
//   });
//
//   MapState copyWith({
//     MapStatus? status,
//     SearchStatus? searchStatus,
//     List<Bin>? bins,
//     List<Bin>? displayBins,
//     Bin? selectedBin,
//     String? searchQuery,
//     List<SearchResult>? searchResults,
//     bool? showSearchResults,
//     SearchResult? selectedSearchResult,
//     BinType? filterType,
//     FillLevel? filterFillLevel,
//     LatLng? targetPosition,
//     double? targetZoom,
//     String? errorMessage,
//     String? reverseGeocodeResult,
//   }) {
//     return MapState(
//       status: status ?? this.status,
//       searchStatus: searchStatus ?? this.searchStatus,
//       bins: bins ?? this.bins,
//       displayBins: displayBins ?? this.displayBins,
//       selectedBin: selectedBin ?? this.selectedBin,
//       searchQuery: searchQuery ?? this.searchQuery,
//       searchResults: searchResults ?? this.searchResults,
//       showSearchResults: showSearchResults ?? this.showSearchResults,
//       selectedSearchResult: selectedSearchResult ?? this.selectedSearchResult,
//       filterType: filterType ?? this.filterType,
//       filterFillLevel: filterFillLevel ?? this.filterFillLevel,
//       targetPosition: targetPosition ?? this.targetPosition,
//       targetZoom: targetZoom ?? this.targetZoom,
//       errorMessage: errorMessage ?? this.errorMessage,
//       reverseGeocodeResult: reverseGeocodeResult ?? this.reverseGeocodeResult,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     status,
//     searchStatus,
//     bins,
//     displayBins,
//     selectedBin,
//     searchQuery,
//     searchResults,
//     showSearchResults,
//     selectedSearchResult,
//     filterType,
//     filterFillLevel,
//     targetPosition,
//     targetZoom,
//     errorMessage,
//     reverseGeocodeResult,
//   ];
//
//   /// Helpers để check trạng thái
//   bool get isLoading => status == MapStatus.loading;
//   bool get isSuccess => status == MapStatus.success;
//   bool get isFailure => status == MapStatus.failure;
//
//   bool get isSearching => searchStatus == SearchStatus.loading;
//   bool get hasSearchResults => searchResults.isNotEmpty;
//
//   bool get hasBins => bins.isNotEmpty;
//   bool get hasSelectedBin => selectedBin != null;
//   bool get hasFilters => filterType != null || filterFillLevel != null;
// }


// void _showSuccessDialog(BuildContext context, Bin bin) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (dialogContext) => AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: AppColors.primary.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.check_circle,
//               color: AppColors.primary,
//               size: 48,
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             "Báo cáo đã được gửi",
//             style: TextStyle(
//               fontSize: AppFontSize.displayMedium,
//               fontWeight: FontWeight.w700,
//               color: AppColors.textDark,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "Cảm ơn bạn đã giúp cải thiện môi trường!",
//             style: TextStyle(
//               fontSize: AppFontSize.bodyMedium,
//               color: AppColors.textGrey,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: AppColors.lightBg,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Thùng rác:',
//                       style: TextStyle(
//                         fontSize: AppFontSize.bodySmall,
//                         color: AppColors.textGrey,
//                       ),
//                     ),
//                     Text(
//                       '#${bin.id}',
//                       style: const TextStyle(
//                         fontSize: AppFontSize.bodySmall,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textDark,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Loại:',
//                       style: TextStyle(
//                         fontSize: AppFontSize.bodySmall,
//                         color: AppColors.textGrey,
//                       ),
//                     ),
//                     Text(
//                       _getBinTypeLabel(bin.type),
//                       style: TextStyle(
//                         fontSize: AppFontSize.bodySmall,
//                         fontWeight: FontWeight.w600,
//                         color: _getBinTypeColor(bin.type),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         SizedBox(
//           width: double.infinity,
//           height: 48,
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.pop(dialogContext); // Close dialog
//               Navigator.pop(context); // Back to map
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 0,
//             ),
//             child: const Text(
//               "QUAY LẠI BẢN ĐỒ",
//               style: TextStyle(
//                 fontSize: AppFontSize.labelLarge,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/auth/auth_cubit.dart';
// import '../../bloc/auth/auth_state.dart';
// import '../../bloc/reward/reward_bloc.dart';
// import '../../bloc/reward/reward_event.dart';
// import '../../bloc/reward/reward_state.dart';
// import '../../configs/font_size.dart';
// import '../../models/reward.dart';
// import '../../widgets/custom_text.dart';
//
// class RewardPage extends StatefulWidget {
//   const RewardPage({Key? key}) : super(key: key);
//
//   @override
//   State<RewardPage> createState() => _RewardPageState();
// }
//
// class _RewardPageState extends State<RewardPage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _searchController = TextEditingController();
//   late ScrollController _scrollController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _scrollController = ScrollController();
//     _scrollController.addListener(_onScroll);
//
//     // Khởi tạo dữ liệu từ API
//     context.read<RewardBloc>().add(RewardFetched());
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   /// Xử lý infinite scroll - tải thêm khi scroll tới cuối
//   void _onScroll() {
//     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//       context.read<RewardBloc>().add(RewardLoadMoreFetched());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return BlocListener<RewardBloc, RewardState>(
//       listener: (context, state) {
//         // Hiển thị error message
//         if (state.errorMessage != null && state.status == RewardStatus.failure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.errorMessage!),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         body: CustomScrollView(
//           slivers: [
//             _buildAppBar(context),
//             _buildPointsCard(context),
//             _buildSearchBar(context),
//             _buildTabBar(context, isDarkMode),
//
//             // Nội dung Tab
//             SliverFillRemaining(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildProductTab(isDarkMode),
//                   _buildHistoryTab(isDarkMode),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // --- UI Components ---
//
//   Widget _buildAppBar(BuildContext context) {
//     return SliverAppBar(
//       expandedHeight: 180,
//       pinned: true,
//       backgroundColor: Theme.of(context).primaryColor,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () => Navigator.pop(context),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Theme.of(context).primaryColor,
//                 Theme.of(context).primaryColor.withOpacity(0.8)
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               SizedBox(height: 40),
//               Icon(Icons.card_giftcard, size: 40, color: Colors.white),
//               SizedBox(height: 12),
//               CustomText(
//                 'Phần Thưởng',
//                 fontSize: AppFontSize.h3,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               CustomText(
//                 'Đổi điểm lấy phần thưởng',
//                 fontSize: AppFontSize.bodyMedium,
//                 color: Colors.white70,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPointsCard(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Theme.of(context).primaryColor.withOpacity(0.9),
//                 Theme.of(context).primaryColor.withOpacity(0.7)
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const CustomText(
//                     'Điểm của bạn',
//                     fontSize: AppFontSize.labelLarge,
//                     color: Colors.white70,
//                   ),
//                   const SizedBox(height: 8),
//                   BlocBuilder<AuthCubit, AuthState>(
//                     builder: (context, authState) {
//                       return CustomText(
//                         '${authState.user?.points ?? 0}',
//                         fontSize: AppFontSize.h1,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               const Icon(Icons.star, size: 40, color: Colors.white),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSearchBar(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: (val) => context.read<RewardBloc>().add(RewardSearchChanged(val)),
//                 decoration: InputDecoration(
//                   hintText: 'Tìm kiếm quà tặng...',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   contentPadding: EdgeInsets.zero,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             IconButton(
//               onPressed: () => _showSortOptions(context),
//               icon: const Icon(Icons.tune_rounded),
//               style: IconButton.styleFrom(backgroundColor: Colors.grey.withOpacity(0.1)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTabBar(BuildContext context, bool isDarkMode) {
//     return SliverToBoxAdapter(
//       child: TabBar(
//         controller: _tabController,
//         indicatorColor: Theme.of(context).primaryColor,
//         labelColor: Theme.of(context).primaryColor,
//         unselectedLabelColor: isDarkMode ? Colors.grey[500] : Colors.grey[600],
//         tabs: const [
//           Tab(icon: Icon(Icons.card_giftcard, size: 20), text: 'Sản phẩm'),
//           Tab(icon: Icon(Icons.history, size: 20), text: 'Lịch sử'),
//         ],
//       ),
//     );
//   }
//
//   /// Tab sản phẩm với infinite scroll
//   Widget _buildProductTab(bool isDarkMode) {
//     return BlocBuilder<RewardBloc, RewardState>(
//       builder: (context, state) {
//         // Loading ban đầu
//         if (state.status == RewardStatus.loading && state.rewards.isEmpty) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         // Không có dữ liệu
//         if (state.rewards.isEmpty && state.status != RewardStatus.loadingMore) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
//                 const SizedBox(height: 16),
//                 const CustomText('Không tìm thấy phần thưởng nào', color: Colors.grey),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () => context.read<RewardBloc>().add(RewardFetched()),
//                   child: const Text("Tải lại"),
//                 )
//               ],
//             ),
//           );
//         }
//
//         // Có dữ liệu
//         return RefreshIndicator(
//           onRefresh: () async {
//             context.read<RewardBloc>().add(RewardFetched());
//             // Đợi để có thời gian refresh
//             await Future.delayed(const Duration(milliseconds: 500));
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: GridView.builder(
//               controller: _scrollController,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: state.rewards.length + (state.hasMore ? 1 : 0),
//               itemBuilder: (context, index) {
//                 // Loading indicator cho load more
//                 if (index == state.rewards.length) {
//                   return state.status == RewardStatus.loadingMore
//                       ? const Center(child: CircularProgressIndicator())
//                       : const SizedBox.shrink();
//                 }
//
//                 final reward = state.rewards[index];
//                 return _buildRewardCard(
//                   context: context,
//                   reward: reward,
//                   isDarkMode: isDarkMode,
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildRewardCard({
//     required BuildContext context,
//     required Reward reward,
//     required bool isDarkMode,
//   }) {
//     final bool isOutOfStock = reward.stockQuantity <= 0;
//
//     return GestureDetector(
//       onTap: isOutOfStock ? null : () => _showRewardDialog(context, reward),
//       child: Container(
//         decoration: BoxDecoration(
//           color: isDarkMode ? Colors.grey[900] : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
//           ),
//         ),
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         Icons.redeem,
//                         size: 40,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   CustomText(
//                     reward.name,
//                     fontSize: AppFontSize.bodyMedium,
//                     fontWeight: FontWeight.w600,
//                     maxLines: 1,
//                   ),
//                   CustomText(
//                     reward.description,
//                     fontSize: AppFontSize.labelSmall,
//                     maxLines: 1,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CustomText(
//                         '${reward.point} ⭐',
//                         fontSize: AppFontSize.labelLarge,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       CustomText(
//                         'Còn ${reward.stockQuantity}',
//                         fontSize: AppFontSize.labelSmall,
//                         color: !isOutOfStock ? Colors.green : Colors.red,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             if (isOutOfStock)
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black45,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Center(
//                   child: CustomText(
//                     'Hết hàng',
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showSortOptions(BuildContext context) {
//     final rewardBloc = context.read<RewardBloc>();
//
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: CustomText(
//               'Sắp xếp sản phẩm',
//               fontWeight: FontWeight.bold,
//               fontSize: AppFontSize.bodyLarge,
//             ),
//           ),
//           _buildSortTile(
//             context,
//             'Mới nhất',
//             RewardSort.newest,
//             Icons.arrow_downward,
//                 () => rewardBloc.add(RewardSortChanged(RewardSort.newest)),
//           ),
//           _buildSortTile(
//             context,
//             'Cũ nhất',
//             RewardSort.oldest,
//             Icons.arrow_upward,
//                 () => rewardBloc.add(RewardSortChanged(RewardSort.oldest)),
//           ),
//           _buildSortTile(
//             context,
//             'Điểm: Thấp đến cao',
//             RewardSort.pointLowHigh,
//             Icons.trending_up,
//                 () => rewardBloc.add(RewardSortChanged(RewardSort.pointLowHigh)),
//           ),
//           _buildSortTile(
//             context,
//             'Điểm: Cao đến thấp',
//             RewardSort.pointHighLow,
//             Icons.trending_down,
//                 () => rewardBloc.add(RewardSortChanged(RewardSort.pointHighLow)),
//           ),
//           const Divider(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: CustomText(
//               'Lọc sản phẩm',
//               fontWeight: FontWeight.bold,
//               fontSize: AppFontSize.bodyLarge,
//             ),
//           ),
//           _buildFilterTile(
//             context,
//             'Tất cả',
//             RewardFilter.all,
//                 () => rewardBloc.add(RewardFilterChanged(RewardFilter.all)),
//           ),
//           _buildFilterTile(
//             context,
//             'Còn hàng',
//             RewardFilter.inStock,
//                 () => rewardBloc.add(RewardFilterChanged(RewardFilter.inStock)),
//           ),
//           _buildFilterTile(
//             context,
//             'Hết hàng',
//             RewardFilter.outOfStock,
//                 () => rewardBloc.add(RewardFilterChanged(RewardFilter.outOfStock)),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSortTile(
//       BuildContext context,
//       String title,
//       RewardSort sort,
//       IconData icon,
//       VoidCallback onTap,
//       ) {
//     return BlocBuilder<RewardBloc, RewardState>(
//       builder: (context, state) {
//         final isSelected = state.sortBy == sort;
//         return ListTile(
//           leading: Icon(
//             icon,
//             color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
//           ),
//           title: CustomText(
//             title,
//             color: isSelected ? Theme.of(context).primaryColor : null,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//           trailing: isSelected
//               ? Icon(Icons.check, color: Theme.of(context).primaryColor)
//               : null,
//           onTap: () {
//             onTap();
//             Navigator.pop(context);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildFilterTile(
//       BuildContext context,
//       String title,
//       RewardFilter filter,
//       VoidCallback onTap,
//       ) {
//     return BlocBuilder<RewardBloc, RewardState>(
//       builder: (context, state) {
//         final isSelected = state.filter == filter;
//         return ListTile(
//           leading: Icon(
//             isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
//             color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
//           ),
//           title: CustomText(
//             title,
//             color: isSelected ? Theme.of(context).primaryColor : null,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           ),
//           onTap: () {
//             onTap();
//             Navigator.pop(context);
//           },
//         );
//       },
//     );
//   }
//
//   void _showRewardDialog(BuildContext context, Reward reward) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: CustomText(
//           reward.name,
//           fontSize: AppFontSize.displaySmall,
//           fontWeight: FontWeight.bold,
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomText(
//               'Bạn có chắc chắn muốn dùng ${reward.point} điểm để nhận quà này?',
//             ),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.grey.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: CustomText(
//                 'Mô tả: ${reward.description}',
//                 fontSize: AppFontSize.labelSmall,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const CustomText('Hủy'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               // TODO: Thêm RedeemRewardEvent khi triển khai chức năng đổi quà
//               // context.read<RewardBloc>().add(RedeemRewardEvent(reward.id!));
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//             ),
//             child: const CustomText('Xác nhận', color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Tab lịch sử (tạm thời không có dữ liệu)
//   Widget _buildHistoryTab(bool isDarkMode) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.history, size: 64, color: Colors.grey),
//           const SizedBox(height: 16),
//           const CustomText(
//             'Tính năng lịch sử đang cập nhật',
//             color: Colors.grey,
//             fontSize: AppFontSize.bodyMedium,
//           ),
//           const SizedBox(height: 16),
//           const CustomText(
//             'Sẽ sớm có sẵn',
//             color: Colors.grey,
//             fontSize: AppFontSize.labelSmall,
//           ),
//         ],
//       ),
//     );
//   }
// }