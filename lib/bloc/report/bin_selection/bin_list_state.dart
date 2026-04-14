import 'package:equatable/equatable.dart';
import 'package:greenbin/models/bin.dart';
import 'package:greenbin/models/enums.dart';
import 'package:greenbin/models/search_result_map/search_result.dart';
import 'package:latlong2/latlong.dart';

enum BinListStatus {
  initial,
  loading,
  success,
  failure
}
enum LocateStatus {
  initial,
  loading,
  success,
  failure,
}

enum BinLoadStatus {
  initial,
  loading,
  success,
  failure,
}

class BinListState extends Equatable {
  final List<SearchResult> searchResults;
  final String query;

  final BinListStatus status;
  final String? errorMessage;

  final LatLng? userLocation;
  final LocateStatus locateStatus;

  final List<Bin> bins;
  final Bin? selectedBin;
  final BinLoadStatus binStatus;

  final BinType? filterCriteria;
  final FillLevel? filterFillLevel;

  const BinListState({
    this.searchResults = const [],
    this.query = '',
    this.status = BinListStatus.initial,
    this.errorMessage,
    this.userLocation,
    this.locateStatus = LocateStatus.initial,

    this.bins = const [],
    this.selectedBin,

    this.filterCriteria,
    this.filterFillLevel,

    this.binStatus = BinLoadStatus.initial,
  });

  @override
  List<Object?> get props => [
    searchResults,
    query,
    status,
    errorMessage,
    userLocation,
    locateStatus,
    bins,
    selectedBin,
    filterCriteria,
    filterFillLevel,
    binStatus,
  ];

  BinListState copyWith({
    List<SearchResult>? searchResults,
    String? query,
    BinListStatus? status,
    String? errorMessage,
    bool clearError = false,
    LatLng? userLocation,
    LocateStatus? locateStatus,

    List<Bin>? bins,
    BinLoadStatus? binStatus,
    Bin? selectedBin,
    bool clearSelectedBin = false,

    BinType? filterCriteria,
    bool clearFilterCriteria = false,
    FillLevel? filterFillLevel,
    bool clearFilterFillLevel = false,
  }) {
    return BinListState(
      searchResults: searchResults ?? this.searchResults,
      query: query ?? this.query,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      userLocation: userLocation ?? this.userLocation,
      locateStatus: locateStatus ?? this.locateStatus,

      bins: bins ?? this.bins,
      binStatus: binStatus ?? this.binStatus,
      selectedBin: clearSelectedBin ? null : selectedBin ?? this.selectedBin,

      filterCriteria: clearFilterCriteria
          ? null
          : filterCriteria ?? this.filterCriteria,

      filterFillLevel: clearFilterFillLevel
          ? null
          : filterFillLevel ?? this.filterFillLevel,
    );
  }
}
