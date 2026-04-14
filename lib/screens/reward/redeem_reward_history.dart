import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/bloc/point_transaction/redemption_history_cubit.dart';
import 'package:greenbin/bloc/point_transaction/redemption_history_event.dart';
import 'package:greenbin/bloc/point_transaction/redemption_history_state.dart';

import '../../configs/font_size.dart';
import '../../models/point_transaction.dart';
import '../../widgets/custom_text.dart';

class RedeemRewardHistoryTab extends StatefulWidget {
  const RedeemRewardHistoryTab({Key? key}) : super(key: key);

  @override
  State<RedeemRewardHistoryTab> createState() => _RedeemRewardHistoryTabState();
}

class _RedeemRewardHistoryTabState extends State<RedeemRewardHistoryTab>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<RedemptionHistoryBloc>().add(RedemptionHistoryFetched());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= max - 200) {
      context.read<RedemptionHistoryBloc>().add(RedemptionHistoryLoadMore());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        _buildSortBar(context),
        Expanded(
          child: BlocBuilder<RedemptionHistoryBloc, RedemptionHistoryState>(
            builder: (context, state) => _buildBody(context, state, isDarkMode),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
      BuildContext context, RedemptionHistoryState state, bool isDarkMode) {
    // Loading lần đầu
    if (state.status == RedemptionHistoryStatus.loading &&
        state.transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == RedemptionHistoryStatus.failure &&
        state.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            CustomText(
              state.errorMessage ?? 'Có lỗi xảy ra',
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context
                  .read<RedemptionHistoryBloc>()
                  .add(RedemptionHistoryFetched()),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (state.transactions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            CustomText('Chưa có lịch sử đổi quà', color: Colors.grey),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<RedemptionHistoryBloc>().add(RedemptionHistoryFetched()),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.transactions.length + 1,
        itemBuilder: (context, index) {
          if (index == state.transactions.length) {
            return _buildFooter(state);
          }
          return _HistoryCard(
            transaction: state.transactions[index],
            isDarkMode: isDarkMode,
          );
        },
      ),
    );
  }

  Widget _buildFooter(RedemptionHistoryState state) {
    if (state.status == RedemptionHistoryStatus.loadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSortBar(BuildContext context) {
    return BlocBuilder<RedemptionHistoryBloc, RedemptionHistoryState>(
      buildWhen: (prev, curr) => prev.sortBy != curr.sortBy,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Row(
          children: [
            const CustomText('Sắp xếp: ',
                fontSize: AppFontSize.bodyMedium, color: Colors.grey),
            const SizedBox(width: 8),
            _SortChip(
              label: 'Mới nhất',
              value: RedemptionHistorySort.newest,
              current: state.sortBy,
            ),
            const SizedBox(width: 8),
            _SortChip(
              label: 'Cũ nhất',
              value: RedemptionHistorySort.oldest,
              current: state.sortBy,
            ),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final RedemptionHistorySort value;
  final RedemptionHistorySort current;

  const _SortChip(
      {required this.label, required this.value, required this.current});

  @override
  Widget build(BuildContext context) {
    final selected = current == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => context
          .read<RedemptionHistoryBloc>()
          .add(RedemptionHistorySortChanged(value)),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.15),
      labelStyle: TextStyle(
        color: selected ? Theme.of(context).primaryColor : null,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final PointTransaction transaction;
  final bool isDarkMode;

  const _HistoryCard({required this.transaction, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: Icon(Icons.card_giftcard,
                color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(transaction.rewardName,
                    fontSize: AppFontSize.bodyMedium,
                    fontWeight: FontWeight.w600,
                    maxLines: 1),
                const SizedBox(height: 4),
                CustomText(_formatTimeAgo(transaction.createdAt),
                    fontSize: AppFontSize.labelSmall, color: Colors.grey),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText('Số lượng: ${transaction.amount}',
                  fontSize: AppFontSize.bodyMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              const SizedBox(height: 4),
              const _StatusTag(),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const CustomText('Thành công',
          fontSize: AppFontSize.labelSmall,
          color: Colors.green,
          fontWeight: FontWeight.w500),
    );
  }
}
