import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbin/bloc/app/app_cubit.dart';
import 'package:greenbin/bloc/report/report_state.dart';
import 'package:greenbin/bloc/user/user_state.dart';
import 'package:greenbin/configs/app_color.dart';
import 'package:greenbin/widgets/custom_card.dart';
import 'package:greenbin/widgets/custom_text.dart';

import '../../bloc/notification/app_notification_cubit.dart';
import '../../bloc/report/report_cubit.dart';
import '../../bloc/user/user_cubit.dart';
import '../../configs/font_size.dart';
import '../../configs/time_helper.dart';
import '../../models/enums.dart';
import '../../models/report.dart';
import '../../widgets/custom_app_drawer.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return UserHomePageState();
  }
}

class UserHomePageState extends State<UserHomePage> {
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCubit>().loadUser();
      context.read<ReportCubit>().getUserRecentReports(limit: 5);
      context.read<AppCubit>().init();
    });
  }

  static const List<Map<String, dynamic>> quickTasks = [
    {
      'icon': FontAwesomeIcons.map,
      'title': 'Báo cáo',
      'description': 'Báo cáo rác thải',
      'cardColor': AppColors.blueLight,
      'titleColor': AppColors.blueInfo,
      'descriptionColor': AppColors.lightDark,
    },
    {
      'icon': FontAwesomeIcons.file,
      'title': 'Lịch sử báo cáo',
      'description': 'Lịch sử báo cáo',
      'cardColor': AppColors.lightOrange,
      'titleColor': AppColors.orangeWarning,
      'descriptionColor': AppColors.lightDark,
    },
    {
      'icon': FontAwesomeIcons.gift,
      'title': 'Đổi Thưởng',
      'description': 'Quà tặng thân thiện',
      'cardColor': AppColors.lightPurple,
      'titleColor': AppColors.purpleBin,
      'descriptionColor': AppColors.lightDark,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
        listenWhen: (previous, current) =>
        previous.status != current.status &&
            current.status == UserStatus.success &&
            current.user != null &&
            current.token != null,
        listener: (context, state) {
            print("DEBUG: User đã sẵn sàng, thực hiện kết nối Socket...");
            context.read<AppNotificationCubit>().connectSocket(
                  userId: state.user!.id!,
                  token: state.token!,
                );
        },
        child: Scaffold(
          drawer: const CustomAppDrawer(),
          appBar: AppBar(
            centerTitle: true,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: _buildAppBarTitle(),
            backgroundColor: AppColors.primary,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildPointsCard(),
                _buildHeadline(),
                _buildQuickTasksGrid(),
                _buildTipCard(),
                _buildRecentActivity(),
              ],
            ),
          ),
        ));
  }

  Widget _buildAppBarTitle() {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Column(
          children: [
            const CustomText('Xin chào,',
                fontSize: AppFontSize.bodyLarge, color: Colors.white70),
            CustomText(
              state.user?.name ?? 'Người dùng', // Tên động
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: AppFontSize.bodyLarge,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPointsCard() {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return CustomCard(
          color: AppColors.lightBg,
          borderColor: AppColors.amberDark,
          borderRadius: 10,
          borderWidth: 2,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.point_of_sale, color: AppColors.amberPrimary),
                      SizedBox(width: 4),
                      CustomText('Điểm xanh',
                          color: AppColors.amberPrimary,
                          fontSize: AppFontSize.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: '${state.user?.points}',
                      style: const TextStyle(
                          fontSize: AppFontSize.headlineSmall,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                        text: ' điểm',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.amberPrimary)),
                  ])),
                  const SizedBox(height: 10),
                  CustomText(
                    '+${state.user?.points} điểm',
                    color: AppColors.primary,
                    fontSize: AppFontSize.bodyMedium,
                  ),
                ],
              ),
              const Spacer(),
              const CustomCard(
                color: AppColors.amberDark,
                child: CustomText('Hạng bạc',
                    color: Colors.white, fontSize: AppFontSize.bodySmall),
              ),
            ],
          ),
        );
      },
    );
  }

  // Headline
  Widget _buildHeadline() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const CustomText(
        'Tác Vụ Nhanh',
        color: Colors.black,
        fontSize: AppFontSize.headlineSmall,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget _buildTipCard() {
    return CustomCard(
      margin: const EdgeInsets.all(20),
      borderRadius: 16,
      hasShadow: true,
      borderColor: AppColors.primary.withOpacity(0.15),
      borderWidth: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.2),
              AppColors.primary.withValues(alpha: 0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    AppColors.primary.withOpacity(0.1),
                  ],
                ),
              ),
              child: const SizedBox(
                width: 56,
                height: 56,
                child: Icon(Icons.lightbulb_outline,
                    color: AppColors.primary, size: 28),
              ),
            ),

            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CustomText(
                        'Mẹo Xanh',
                        fontWeight: FontWeight.w700,
                        fontSize: AppFontSize.bodyLarge,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),

                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const CustomText(
                          'Hôm nay',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const CustomText(
                    'Phân loại rác tại nguồn giúp giảm 60% lượng rác thải đến bãi chôn lấp. Hãy bắt đầu ngay hôm nay!',
                    fontSize: AppFontSize.bodyMedium,
                    color: Colors.grey,
                    height: 1.5,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Arrow
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0x1A4CAF50),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: AppFontSize.bodyMedium,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Hoạt Động Gần Đây',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              TextButton(
                onPressed: () {
                  context.pushNamed('userReportHistory');
                },
                child: const CustomText(
                  'Xem tất cả',
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          BlocBuilder<ReportCubit, ReportState>(
            buildWhen: (previous, current) {
              return previous.status!=current.status || previous.action!=current.action;
            },
            builder: (context, state) {
              if (state.status == ReportStatusState.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.reports.isEmpty) {
                return const Center(
                  child: CustomText('Chưa có hoạt động nào'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.reports.length,
                itemBuilder: (context, index) {
                  final report = state.reports[index];
                  return buildActivityItem(
                    report,
                    FontAwesomeIcons.recycle,
                    AppColors.blueLight,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickTasksGrid() {
    final itemWidth = (MediaQuery.of(context).size.width - 40 - 12) / 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 12,
        runSpacing: 16,
        children: quickTasks.map((task) {
          return SizedBox(
            width: itemWidth,
            child: buildQuickTaskCard(
              task['icon'],
              task['title'],
              task['description'],
              task['cardColor'],
              task['titleColor'],
              task['descriptionColor'],
              () {
                if (task['title'] == 'Bản Đồ') {
                  context.pushNamed('report');
                } else if (task['title'] == 'Báo Cáo') {
                  context.pushNamed('userReportHistory');
                } else {
                  // context.pushNamed('reward');
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildQuickTaskCard(
    IconData icon,
    String title,
    String description,
    Color cardColor,
    Color titleColor,
    Color descriptionColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      // Dùng InkWell thay MouseRegion để có hiệu ứng nhấn (Ripple)
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: CustomCard(
        color: cardColor,
        borderRadius: 14,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        hasShadow: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, color: titleColor, size: 28),
            const SizedBox(height: 12),
            CustomText(
              title,
              color: titleColor,
              fontSize: AppFontSize.bodyLarge,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            CustomText(
              description,
              color: descriptionColor.withOpacity(0.8),
              fontSize: 11,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActivityItem(
    Report report,
    IconData icon,
    Color iconColor,
  ) {
    final isCompleted = report.status == ReportStatus.completed;

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      hasShadow: false,
      borderColor: Colors.grey.shade100,
      borderWidth: 1,
      borderRadius: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Icon Badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 2. Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'Báo Cáo Rác Thải',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                const SizedBox(height: 4),
                CustomText(
                  report.description,
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                CustomText(
                  TimeHelper.format(report.createdAt ?? DateTime.now()),
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ],
            ),
          ),

          //Thằng này chi cái nào khác pending,cancel mới hiện
          // 3. Points & Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                '+50',
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                fontSize: AppFontSize.bodyMedium,
              ),
              const SizedBox(height: 8),
              _buildStatusBadge(isCompleted),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isCompleted) {
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle_rounded,
          color: AppColors.primary,
          size: 18,
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const CustomText(
          'Đang xử lý',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.orange,
        ),
      );
    }
  }
}
