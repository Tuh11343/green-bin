import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenbin/repositories/app_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:rxdart/rxdart.dart';

import '../../../configs/exception.dart';
import 'bin_list_event.dart';
import 'bin_list_state.dart';

EventTransformer<T> debounceRestartable<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class BinListBloc extends Bloc<BinListEvent, BinListState> {
  final AppRepository _repo;

  BinListBloc({required AppRepository repo})
      : _repo = repo,
        super(const BinListState()) {
    on<QueryChanged>(
      _onQueryChanged,
      transformer: debounceRestartable(const Duration(milliseconds: 500)),
    );

    on<LocateMe>(_onLocateMe);

    on<FetchBins>(_fetchBins);

    on<SelectBin>((event, emit) {
      emit(state.copyWith(selectedBin: event.bin));
    });

    on<ClearSelectedBin>(
      (event, emit) {
        emit(state.copyWith(clearSelectedBin: true));
      },
    );

    on<UpdateFilter>((event, emit) {
      emit(state.copyWith(
        filterCriteria: event.type,
        clearFilterCriteria: event.type == null,

        filterFillLevel: event.fillLevel,
        clearFilterFillLevel: event.fillLevel == null,
      ));
    });

    on<ClearFilter>((event, emit) {
      emit(state.copyWith(
        clearFilterCriteria: true,
        clearFilterFillLevel: true,
      ));
    });
  }

  Future<void> _onQueryChanged(
    QueryChanged event,
    Emitter<BinListState> emit,
  ) async {
    try {
      if (event.query.isEmpty) {
        emit(state.copyWith(
          query: '',
          status: BinListStatus.initial,
        ));
        return;
      }

      emit(state.copyWith(
        query: event.query,
        status: BinListStatus.loading,
      ));

      final results = await _repo.googleMap.searchLocation(query: event.query);

      emit(state.copyWith(
        status: BinListStatus.success,
        searchResults: results,
        query: event.query,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BinListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLocateMe(
      LocateMe event,
      Emitter<BinListState> emit,
      ) async {
    try {

      emit(state.copyWith(locateStatus: LocateStatus.initial));
      LocationPermission permission = await Geolocator.checkPermission();

      /// ❌ Chưa cấp quyền
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(errorMessage: 'permission_denied',locateStatus: LocateStatus.failure));
          return;
        }
      }

      /// 🚨 Bị chặn vĩnh viễn
      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(errorMessage: 'permission_denied_forever',locateStatus: LocateStatus.failure));
        return;
      }

      emit(state.copyWith(locateStatus: LocateStatus.loading));

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      emit(state.copyWith(
        locateStatus: LocateStatus.success,
        userLocation: LatLng(position.latitude, position.longitude),
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
        locateStatus: LocateStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _fetchBins(
    FetchBins event,
    Emitter<BinListState> emit,
  ) async {
    try {
      emit(state.copyWith(binStatus: BinLoadStatus.loading));

      final bins = await _repo.bin.getAllBins();

      emit(state.copyWith(
        bins: bins,
        binStatus: BinLoadStatus.success,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
        binStatus: BinLoadStatus.failure,
        errorMessage: 'Có lỗi xảy ra khi tải bins',
      ));
    }
  }
}
