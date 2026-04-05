import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/repositories/geocoding_repository.dart';

import '../../../models/bin.dart';
import '../../../models/enums.dart';
import '../../../repositories/app_repository.dart';
import 'bin_selection_state.dart';

class BinSelectionCubit extends Cubit<BinSelectionState> {
  final AppRepository _repo;

  BinSelectionCubit(this._repo) : super(const BinSelectionState());

  // final GeocodingRepository _geocodingRepository =
  //     GeocodingRepository(); // Sử dụng cho tìm kiếm xong ảo ngược tọa độ

  Future<void> initialize() async {
    emit(state.copyWith(status: BinSelectionStatus.loading));

    try {
      final bins = await _repo.bin.getAllBins();

      emit(state.copyWith(
        status: BinSelectionStatus.success,
        bins: bins,
        displayBins: bins,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BinSelectionStatus.failure,
        errorMessage: 'Không thể tải dữ liệu thùng rác',
      ));
    }
  }

  void selectBin(Bin? bin) {
    emit(state.copyWith(selectedBin: bin));
  }

  void closeBinDetail() {
    emit(state.copyWith(clearSelectedBin: true));
  }

  void filterBinsByCriteria(BinType? type) {
    applyFilters(type: type, level: state.filterFillLevel);
  }

  void filterBinsByFillLevel(FillLevel? level) {
    applyFilters(type: state.filterCriteria, level: level);
  }

  void applyFilters({BinType? type, FillLevel? level}) {
    var filteredBins = state.bins;

    if (type != null) {
      filteredBins = filteredBins.where((bin) => bin.type == type).toList();
    }

    if (level != null) {
      filteredBins =
          filteredBins.where((bin) => bin.fillLevel == level).toList();
    }

    emit(state.copyWith(
      clearFilterCriteria: type == null,
      clearFilterFillLevel: level == null,
      filterCriteria: type,
      filterFillLevel: level,
      displayBins: filteredBins,
    ));
  }

  void clearFilters() {
    emit(state.copyWith(
      clearFilterCriteria: true,
      clearFilterFillLevel: true,
      displayBins: state.bins,
    ));
  }

  Future<void> reportBin(int binId, String issue) async {
    try {
      final updatedBins = state.bins.map((bin) {
        if (bin.id == binId) {
          return bin.copyWith(reportCount: bin.reportCount + 1);
        }
        return bin;
      }).toList();

      emit(state.copyWith(
        bins: updatedBins,
        displayBins: updatedBins,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Không thể gửi báo cáo'));
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: BinSelectionStatus.loading));

    try {
      initialize();
    } catch (e) {
      emit(state.copyWith(
        status: BinSelectionStatus.failure,
        errorMessage: 'Không thể tải lại dữ liệu',
      ));
    }
  }
}
