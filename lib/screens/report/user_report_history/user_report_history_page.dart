import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/screens/report/user_report_detail_page.dart';

import '../../../bloc/app/app_cubit.dart';
import '../../../bloc/report/user_report_history/user_report_history_bloc.dart';
import '../../../bloc/report/user_report_history/user_report_history_event.dart';
import '../../../bloc/report/user_report_history/user_report_history_state.dart';
import '../../../configs/app_color.dart';
import '../../../models/enums.dart';
import '../../../models/response/report_detail_response.dart';
import 'user_report_history_page_widgets.dart';

class UserReportHistoryPage extends StatefulWidget {
  const UserReportHistoryPage({super.key});

  @override
  State<UserReportHistoryPage> createState() => UserReportHistoryPageState();
}

class UserReportHistoryPageState extends State<UserReportHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AppCubit>().toggleBottomBar(false);
    context.read<UserReportHistoryBloc>().add(const FetchReportsEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= max - 200) {
      context.read<UserReportHistoryBloc>().add(const LoadMoreReportsEvent());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  String getSortLabel(UserReportHistorySort type) {
    switch (type) {
      case UserReportHistorySort.newest:
        return 'Mới nhất';
      case UserReportHistorySort.oldest:
        return 'Cũ nhất';
    }
  }

  final statusFilterLabels = <ReportStatus?, String>{
    null: 'Tất cả',
    ReportStatus.pending: 'Chưa xử lý',
    ReportStatus.processing: 'Đang xử lý',
    ReportStatus.completed: 'Hoàn thành',
    ReportStatus.cancelled: 'Đã hủy',
  };

  void _showSortAndFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocBuilder<UserReportHistoryBloc, UserReportHistoryState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sắp xếp theo',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Row(
                children: UserReportHistorySort.values.map((sortOption) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<UserReportHistoryBloc>()
                            .add(ChangeSortByEvent(sortOption));
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: state.sortBy == sortOption
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: state.sortBy == sortOption
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          getSortLabel(sortOption),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: state.sortBy == sortOption
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Trạng thái',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: statusFilterLabels.entries.map((entry) {
                  final selected = state.filterCriteria == entry.key;
                  return GestureDetector(
                    onTap: () {
                      // tap lại chip đang chọn → reset về null (Tất cả)
                      final next = selected ? null : entry.key;
                      context
                          .read<UserReportHistoryBloc>()
                          .add(ChangeFilterCriteriaEvent(next));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
          if(didPop){
            context.read<AppCubit>().toggleBottomBar(true);
          }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch sử báo cáo'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              context.read<AppCubit>().toggleBottomBar(true);
            },
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<UserReportHistoryBloc, UserReportHistoryState>(
          builder: (context, state) {
            return Column(
              children: [
                StatsBar(reports: state.reportResponses.toReportList()),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _showSortAndFilterBottomSheet,
                    icon: const Icon(Icons.tune_rounded),
                    label: const Text('Lọc & Sắp xếp'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(child: _buildBody(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(UserReportHistoryState state) {
    // Lần đầu load
    if (state.status == UserReportHistoryStatus.loading &&
        state.reportResponses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Lỗi lần đầu
    if (state.status == UserReportHistoryStatus.failure &&
        state.reportResponses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? 'Có lỗi xảy ra',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context
                  .read<UserReportHistoryBloc>()
                  .add(const FetchReportsEvent()),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (state.reportResponses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.description_outlined,
                  size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'Không có báo cáo',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<UserReportHistoryBloc>().add(const FetchReportsEvent()),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        // +1 để chứa loading indicator / end indicator ở cuối
        itemCount: state.reportResponses.length + 1,
        itemBuilder: (context, index) {
          if (index == state.reportResponses.length) {
            return _buildFooter(state);
          }
          final item = state.reportResponses[index];
          return ReportCard(
            item: item,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserReportDetailPage(item: item),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter(UserReportHistoryState state) {
    if (state.status == UserReportHistoryStatus.loadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return const SizedBox.shrink();
  }
}