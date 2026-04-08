import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/screens/reward/redeem_reward_history.dart';
import 'package:greenbin/screens/reward/reward_tab.dart';

import '../../bloc/reward/reward_bloc.dart';
import '../../bloc/reward/reward_event.dart';
import '../../bloc/user/user_cubit.dart';
import '../../bloc/user/user_state.dart';
import '../../configs/font_size.dart';
import '../../widgets/custom_text.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<RewardBloc>().add(RewardFetched());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                RewardProductTab(),
                RedeemRewardHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: primaryColor,
      child: Column(
        children: [
          // AppBar thu gọn
          SizedBox(
            height: topPadding + 48,
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: const Row(
                children: [
                  Expanded(
                    child: CustomText(
                      'Phần Thưởng',
                      fontSize: AppFontSize.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Points card thu gọn
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.star, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      CustomText('Điểm của bạn',
                          fontSize: AppFontSize.bodyMedium,
                          color: Colors.white70),
                    ],
                  ),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) => CustomText(
                      '${state.user?.points ?? 0}',
                      fontSize: AppFontSize.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TabBar
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: const [
              Tab(icon: Icon(Icons.card_giftcard, size: 18), text: 'Sản phẩm'),
              Tab(icon: Icon(Icons.history, size: 18), text: 'Lịch sử'),
            ],
          ),
        ],
      ),
    );
  }
}
