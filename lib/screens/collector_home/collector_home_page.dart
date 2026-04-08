import 'package:flutter/material.dart';

import '../../configs/app_color.dart';
import '../../configs/font_size.dart';

class CollectorHomePage extends StatefulWidget {
  const CollectorHomePage({Key? key}) : super(key: key);

  @override
  State<CollectorHomePage> createState() => _CollectorHomePageState();
}

class _CollectorHomePageState extends State<CollectorHomePage> {
  int currentIndex = 0;

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Phân loại rác tái chế',
      'description': '5kg giấy, nhua',
      'time': '2 giờ trước',
      'reward': '+50',
      'completed': false,
      'icon': Icons.recycling,
    },
    {
      'title': 'Thu gom rác hữu cơ',
      'description': '3kg thực phẩm',
      'time': '1 ngày trước',
      'reward': '+30',
      'completed': true,
      'icon': Icons.nature,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Card
            _buildStatsCard(),
            const SizedBox(height: 24),
            // Quick Actions
            _buildQuickActions(),
            const SizedBox(height: 24),
            // Promo Card
            _buildPromoCard(),
            const SizedBox(height: 24),
            // Recent Tasks Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hoạt Động Gần Đây',
                    style: TextStyle(
                      fontSize: AppFontSize.displaySmall,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: AppFontSize.bodySmall,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildTasksList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {},
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Xin chào,',
            style: TextStyle(
              fontSize: AppFontSize.bodySmall,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            'Nguyễn Văn A',
            style: TextStyle(
              fontSize: AppFontSize.headlineSmall,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {},
            ),
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 12,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: AppColors.redDanger,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.95),
              AppColors.primaryDark.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Điểm Tích Lũy',
                                style: TextStyle(
                                  fontSize: AppFontSize.bodySmall,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '2,850',
                                      style: TextStyle(
                                        fontSize: AppFontSize.headlineMedium,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' điểm',
                                      style: TextStyle(
                                        fontSize: AppFontSize.bodyMedium,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '+200 điểm tuần này',
                            style: TextStyle(
                              fontSize: AppFontSize.bodySmall,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Hạng Bạc',
                      style: TextStyle(
                        fontSize: AppFontSize.labelMedium,
                        fontWeight: FontWeight.w700,
                        color: AppColors.orangeWarning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.location_on,
        'label': 'Điểm Thả\nGom Rác',
        'color': AppColors.blueInfo,
      },
      {
        'icon': Icons.assignment,
        'label': 'Công Việc\nCó Sẵn',
        'color': AppColors.orangeWarning,
      },
      {
        'icon': Icons.card_giftcard,
        'label': 'Đổi\nThưởng',
        'color': AppColors.lightPurple,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions
            .map(
              (action) => GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: (action['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (action['color'] as Color).withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    action['icon'] as IconData,
                    color: action['color'] as Color,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 75,
                  child: Text(
                    action['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: AppFontSize.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.15),
              AppColors.blueInfo.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.eco,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mẹo Xanh Hôm Nay',
                      style: TextStyle(
                        fontSize: AppFontSize.bodyLarge,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Phân loại rác tái chế đúng cách giúp tăng hiệu suất tái chế lên 40%',
                      style: TextStyle(
                        fontSize: AppFontSize.bodySmall,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: tasks.asMap().entries.map((entry) {
          final task = entry.value;
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: task['completed']
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.blueInfo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          task['icon'] as IconData,
                          color: task['completed']
                              ? AppColors.primary
                              : AppColors.blueInfo,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['title'] as String,
                              style: TextStyle(
                                fontSize: AppFontSize.bodyMedium,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                                decoration: task['completed']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  task['description'] as String,
                                  style: const TextStyle(
                                    fontSize: AppFontSize.bodySmall,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  task['time'] as String,
                                  style: const TextStyle(
                                    fontSize: AppFontSize.bodySmall,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            task['reward'] as String,
                            style: TextStyle(
                              fontSize: AppFontSize.labelLarge,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            task['completed']
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: task['completed']
                                ? AppColors.primary
                                : AppColors.textGrey,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (entry.key < tasks.length - 1) const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }
}