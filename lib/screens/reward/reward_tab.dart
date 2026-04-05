import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/widgets/dialog.dart';

import '../../bloc/reward/reward_bloc.dart';
import '../../bloc/reward/reward_event.dart';
import '../../bloc/reward/reward_state.dart';
import '../../configs/font_size.dart';
import '../../models/reward.dart';
import '../../widgets/custom_text.dart';

class RewardProductTab extends StatefulWidget {
  const RewardProductTab({Key? key}) : super(key: key);

  @override
  State<RewardProductTab> createState() => _RewardProductTabState();
}

class _RewardProductTabState extends State<RewardProductTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }


  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= max - 200) {
      context.read<RewardBloc>().add(RewardLoadMoreFetched());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<RewardBloc, RewardState>(
        listenWhen: (prev, curr) => prev.redeemStatus != curr.redeemStatus,
        listener: (context, state) {
          if (state.redeemStatus != RedeemStatus.loading &&
              Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          if (state.redeemStatus == RedeemStatus.loading) {
            AppDialog.loadingDialog(context);
          } else if (state.redeemStatus == RedeemStatus.success) {
            AppDialog.showAlert(context,
                title: 'Thông báo', message: 'Đổi quà thành công');
          } else if (state.redeemStatus == RedeemStatus.failure) {
            AppDialog.showAlert(context,
                title: 'Lỗi', message: 'Đổi quà thất bại');
          }
        },
        child: Column(
          children: [
            //Thằng này là phần xử lý search,filter,sortBy
            _buildSearchBar(context),

            Expanded(
              child: BlocBuilder<RewardBloc, RewardState>(
                builder: (context, state) {
                  if (state.status == RewardStatus.loading &&
                      state.rewards.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.rewards.isEmpty) {
                    return const Center(
                        child: CustomText("Không có phần thưởng nào"));
                  }

                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<RewardBloc>().add(RewardFetched()),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                        return GridView.builder(
                          controller: _scrollController, // 👈 thêm
                          padding: const EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 220,
                          ),
                          // 👇 +1 để chứa loading indicator ở cuối
                          itemCount: state.rewards.length + (state.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Item cuối = loading indicator
                            if (index == state.rewards.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return _RewardCard(
                              reward: state.rewards[index],
                              isDarkMode: true,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  // -------------------------------------------------------
  //  Search bar + nút filter — tự quản lý trong tab này
  // -------------------------------------------------------

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) =>
                  context.read<RewardBloc>().add(RewardSearchChanged(val)),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm quà tặng...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Hiện badge khi đang có filter/sort khác mặc định
          BlocBuilder<RewardBloc, RewardState>(
            buildWhen: (prev, curr) =>
                prev.sortBy != curr.sortBy || prev.filter != curr.filter,
            builder: (context, state) {
              final hasActive = state.sortBy != RewardSort.newest ||
                  state.filter != RewardFilterCriteria.all;
              return Badge(
                isLabelVisible: hasActive,
                child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                      builder: (context) {
                        return const _ProductSortFilterSheet();
                      },
                    );
                  },
                  icon: const Icon(Icons.tune_rounded),
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.withValues(alpha: 0.1)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}

class _ProductSortFilterSheet extends StatelessWidget {
  const _ProductSortFilterSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RewardBloc, RewardState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText('Sắp xếp & Lọc',
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSize.bodyLarge),
                // Nút reset về mặc định
                TextButton(
                  onPressed: () {
                    context.read<RewardBloc>().add(RewardResetAll());
                  },
                  child: const CustomText('Đặt lại',
                      color: Colors.grey, fontSize: AppFontSize.bodyMedium),
                ),
              ],
            ),
            const Divider(height: 16),

            // ---------- Sort ----------
            const CustomText('Sắp xếp theo',
                fontWeight: FontWeight.w600, fontSize: AppFontSize.bodyMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _SortChip(
                    label: 'Mới nhất',
                    value: RewardSort.newest,
                    current: state.sortBy),
                _SortChip(
                    label: 'Cũ nhất',
                    value: RewardSort.oldest,
                    current: state.sortBy),
                _SortChip(
                    label: 'Điểm thấp → cao',
                    value: RewardSort.pointLowHigh,
                    current: state.sortBy),
                _SortChip(
                    label: 'Điểm cao → thấp',
                    value: RewardSort.pointHighLow,
                    current: state.sortBy),
              ],
            ),
            const SizedBox(height: 16),

            // ---------- Filter ----------
            const CustomText('Tình trạng',
                fontWeight: FontWeight.w600, fontSize: AppFontSize.bodyMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _FilterChip(
                    label: 'Tất cả',
                    value: RewardFilterCriteria.all,
                    current: state.filter),
                _FilterChip(
                    label: 'Còn hàng',
                    value: RewardFilterCriteria.inStock,
                    current: state.filter),
                _FilterChip(
                    label: 'Hết hàng',
                    value: RewardFilterCriteria.outOfStock,
                    current: state.filter),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final RewardSort value;
  final RewardSort current;

  const _SortChip(
      {required this.label, required this.value, required this.current});

  @override
  Widget build(BuildContext context) {
    final selected = current == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) =>
          context.read<RewardBloc>().add(RewardSortChanged(value)),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.15),
      labelStyle: TextStyle(
        color: selected ? Theme.of(context).primaryColor : null,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final RewardFilterCriteria value;
  final RewardFilterCriteria current;

  const _FilterChip(
      {required this.label, required this.value, required this.current});

  @override
  Widget build(BuildContext context) {
    final selected = current == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) =>
          context.read<RewardBloc>().add(RewardFilterChanged(value)),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.15),
      labelStyle: TextStyle(
        color: selected ? Theme.of(context).primaryColor : null,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final Reward reward;
  final bool isDarkMode;

  const _RewardCard({required this.reward, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = reward.stockQuantity <= 0;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: isOutOfStock ? null : () => _showRewardDialog(context, reward),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: reward.imageUrl ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 120,
                        placeholder: (context, url) => Container(
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[100],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[100],
                          child: Center(
                            child: Icon(Icons.broken_image,
                                color: primaryColor, size: 32),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomText(reward.name,
                      fontSize: AppFontSize.bodyMedium,
                      fontWeight: FontWeight.w600,
                      maxLines: 1),
                  CustomText(reward.description,
                      fontSize: AppFontSize.labelSmall,
                      maxLines: 1,
                      color: Colors.grey),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText('${reward.point} ⭐',
                          fontSize: AppFontSize.labelLarge,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                      CustomText('Còn ${reward.stockQuantity}',
                          fontSize: AppFontSize.labelSmall,
                          color: !isOutOfStock ? Colors.green : Colors.red),
                    ],
                  ),
                ],
              ),
            ),
            if (isOutOfStock)
              Container(
                decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                    child: CustomText('Hết hàng',
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  void _showRewardDialog(BuildContext context, Reward reward) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: CustomText(reward.name,
            fontSize: AppFontSize.displaySmall, fontWeight: FontWeight.bold),
        content: CustomText(
            'Bạn có chắc chắn muốn dùng ${reward.point} điểm để nhận quà này?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const CustomText('Hủy')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<RewardBloc>()
                  .add(RedeemReward(reward.id!, reward.point));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            child: const CustomText('Xác nhận', color: Colors.white),
          ),
        ],
      ),
    );
  }
}
