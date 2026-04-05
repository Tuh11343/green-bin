import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/report/bin_selection/bin_selection_cubit.dart';
import '../../../bloc/report/bin_selection/bin_selection_state.dart';
import '../../../configs/app_color.dart';
import '../../../configs/font_size.dart';
import '../../../models/bin.dart';
import '../../../models/enums.dart';

// Bin Detail Sheet Widget
class BinDetailSheet extends StatelessWidget {
  final Bin bin;
  final VoidCallback onClose;
  final VoidCallback onReport;

  const BinDetailSheet({
    Key? key,
    required this.bin,
    required this.onClose,
    required this.onReport,
  }) : super(key: key);

  String _getBinTypeLabel(BinType type) {
    switch (type) {
      case BinType.organic:
        return 'Hữu cơ';
      case BinType.recyclable:
        return 'Tái chế';
      case BinType.non_recyclable:
        return 'Vô cơ';
    }
  }

  String _getFillLevelPercent(FillLevel level) {
    switch (level) {
      case FillLevel.low:
        return '20%';
      case FillLevel.medium:
        return '60%';
      case FillLevel.high:
        return '90%';
    }
  }

  double _getFillLevelValue(FillLevel level) {
    switch (level) {
      case FillLevel.low:
        return 0.2;
      case FillLevel.medium:
        return 0.6;
      case FillLevel.high:
        return 0.9;
    }
  }

  Color _getFillLevelColor(FillLevel level) {
    switch (level) {
      case FillLevel.low:
        return AppColors.primary;
      case FillLevel.medium:
        return AppColors.orangeWarning;
      case FillLevel.high:
        return AppColors.redDanger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: Offset.zero,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.lightCard,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thùng rác #${bin.id}',
                              style: const TextStyle(
                                fontSize: AppFontSize.displayMedium,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${bin.latitude.toStringAsFixed(4)}, ${bin.longitude.toStringAsFixed(4)}',
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
                      GestureDetector(
                        onTap: onClose,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.textGrey,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TypeChip(
                    label: _getBinTypeLabel(bin.type),
                    type: bin.type,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mức độ đầy',
                        style: TextStyle(
                          fontSize: AppFontSize.bodyMedium,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _getFillLevelPercent(bin.fillLevel),
                        style: TextStyle(
                          fontSize: AppFontSize.bodyMedium,
                          color: _getFillLevelColor(bin.fillLevel),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _getFillLevelValue(bin.fillLevel),
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getFillLevelColor(bin.fillLevel),
                      ),
                    ),
                  ),
                  if (bin.reportCount > 0) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orangeWarning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            size: 18,
                            color: AppColors.orangeWarning,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${bin.reportCount} báo cáo chưa xử lý',
                            style: const TextStyle(
                              fontSize: AppFontSize.bodySmall,
                              color: AppColors.orangeWarning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'CHỈ ĐƯỜNG ĐẾN ĐÂY',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: AppFontSize.labelLarge,
                            ),
                          ),
                        ],
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
}

// Type Chip Widget
class TypeChip extends StatelessWidget {
  final String label;
  final BinType type;

  const TypeChip({
    required this.label,
    required this.type,
  });

  Color _getTypeColor(BinType type) {
    switch (type) {
      case BinType.organic:
        return AppColors.primary;
      case BinType.recyclable:
        return AppColors.blueInfo;
      case BinType.non_recyclable:
        return AppColors.redDanger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSize.labelMedium,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class BinFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BinFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: isSelected ? 1.5 : 0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppFontSize.labelMedium,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BinSelectionCubit, BinSelectionState>(
      buildWhen: (prev, curr) {
        return prev.filterCriteria != curr.filterCriteria ||
            prev.filterFillLevel != curr.filterFillLevel;
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lọc thùng rác',
                    style: TextStyle(
                      fontSize: AppFontSize.displayMedium,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (state.hasFilters)
                    TextButton(
                      onPressed: () {
                        context.read<BinSelectionCubit>().clearFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Xóa bộ lọc'),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Type filters
              const Text(
                'Loại thùng',
                style: TextStyle(
                  fontSize: AppFontSize.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  BinFilterChip(
                    label: 'Hữu cơ',
                    isSelected: state.filterCriteria == BinType.organic,
                    onTap: () {
                      context.read<BinSelectionCubit>().filterBinsByCriteria(
                            state.filterCriteria == BinType.organic
                                ? null
                                : BinType.organic,
                          );
                    },
                  ),
                  BinFilterChip(
                    label: 'Tái chế',
                    isSelected: state.filterCriteria == BinType.recyclable,
                    onTap: () {
                      context.read<BinSelectionCubit>().filterBinsByCriteria(
                            state.filterCriteria == BinType.recyclable
                                ? null
                                : BinType.recyclable,
                          );
                    },
                  ),
                  BinFilterChip(
                    label: 'Vô cơ',
                    isSelected: state.filterCriteria == BinType.non_recyclable,
                    onTap: () {
                      context.read<BinSelectionCubit>().filterBinsByCriteria(
                            state.filterCriteria == BinType.non_recyclable
                                ? null
                                : BinType.non_recyclable,
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Fill level filters
              const Text(
                'Mức độ đầy',
                style: TextStyle(
                  fontSize: AppFontSize.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  BinFilterChip(
                    label: 'Thấp',
                    isSelected: state.filterFillLevel == FillLevel.low,
                    onTap: () {
                      context.read<BinSelectionCubit>().filterBinsByFillLevel(
                            state.filterFillLevel == FillLevel.low
                                ? null
                                : FillLevel.low,
                          );
                    },
                  ),
                  BinFilterChip(
                    label: 'Trung bình',
                    isSelected: state.filterFillLevel == FillLevel.medium,
                    onTap: () {
                      context.read<BinSelectionCubit>().filterBinsByFillLevel(
                            state.filterFillLevel == FillLevel.medium
                                ? null
                                : FillLevel.medium,
                          );
                    },
                  ),
                  BinFilterChip(
                    label: 'Cao',
                    isSelected: state.filterFillLevel == FillLevel.high,
                    onTap: () {
                      context.read<BinSelectionCubit>().filterBinsByFillLevel(
                            state.filterFillLevel == FillLevel.high
                                ? null
                                : FillLevel.high,
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ÁP DỤNG',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: AppFontSize.labelLarge,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FilterBadge extends StatelessWidget {
  final VoidCallback onTap;

  const FilterBadge({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_list, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              'Lọc',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppFontSize.labelSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
