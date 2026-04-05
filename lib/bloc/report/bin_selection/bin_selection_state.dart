import 'package:equatable/equatable.dart';

import '../../../models/bin.dart';
import '../../../models/enums.dart';

enum BinSelectionStatus {
  initial,
  loading,
  success,
  failure,
}

class BinSelectionState extends Equatable {
  final BinSelectionStatus status;
  final String? errorMessage;

  final List<Bin> bins;
  final List<Bin> displayBins;
  final Bin? selectedBin;

  final BinType? filterCriteria;
  final FillLevel? filterFillLevel;

  const BinSelectionState({
    this.status = BinSelectionStatus.initial,
    this.errorMessage,
    this.bins = const [],
    this.displayBins = const [],
    this.selectedBin,
    this.filterCriteria,
    this.filterFillLevel,
  });

  BinSelectionState copyWith({
    BinSelectionStatus? status,
    String? errorMessage,
    List<Bin>? bins,
    List<Bin>? displayBins,
    Bin? selectedBin,
    BinType? filterCriteria,
    FillLevel? filterFillLevel,
    bool clearSelectedBin = false,
    bool clearFilterCriteria = false,
    bool clearFilterFillLevel = false,
  }) {
    return BinSelectionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      bins: bins ?? this.bins,
      displayBins: displayBins??this.displayBins,
      selectedBin: clearSelectedBin ? null : (selectedBin ?? this.selectedBin),
      filterCriteria: clearFilterCriteria ? null : (filterCriteria ?? this.filterCriteria),
      filterFillLevel: clearFilterFillLevel
          ? null
          : (filterFillLevel ?? this.filterFillLevel),
    );
  }

  @override
  List<Object?> get props => [
        status,
        bins,
        displayBins,
        selectedBin,
        filterCriteria,
        filterFillLevel,
      ];

  bool get hasSelectedBin => selectedBin != null;

  bool get hasFilters => filterCriteria != null || filterFillLevel != null;
}
