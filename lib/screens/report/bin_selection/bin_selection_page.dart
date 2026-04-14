import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:greenbin/bloc/app/app_cubit.dart';
import 'package:greenbin/bloc/report/bin_selection/bin_list_event.dart';
import 'package:greenbin/bloc/report/bin_selection/bin_list_state.dart';
import 'package:greenbin/widgets/dialog.dart';
import 'package:latlong2/latlong.dart';

import '../../../bloc/report/bin_selection/bin_list_bloc.dart';
import '../../../models/bin.dart';
import '../../../models/enums.dart';
import 'bin_selection_widget.dart';

class BinListSelectionPage extends StatefulWidget {
  const BinListSelectionPage({super.key});

  @override
  State<BinListSelectionPage> createState() => _BinListSelectionPageState();
}

class _BinListSelectionPageState extends State<BinListSelectionPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  static const LatLng _initialCenter = LatLng(10.7769, 106.7009);
  static const double _initialZoom = 15.0;

  Color _getColor(FillLevel level) {
    switch (level) {
      case FillLevel.low:
        return Colors.green;
      case FillLevel.medium:
        return Colors.orange;
      case FillLevel.high:
        return Colors.red;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<BinListBloc>().add(FetchBins());
        context.read<AppCubit>().toggleBottomBar(false);
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BinListBloc, BinListState>(
        listenWhen: (previous, current) {
          return previous.locateStatus != current.locateStatus;
        },
        listener: (context, state) {
          if (state.locateStatus == LocateStatus.loading) {
            AppDialog.showLoading(context);
          } else {
            AppDialog.hideLoading(context);

            final location = state.userLocation;
            if (location != null) {
              _mapController.move(location, 16);
            }
          }
        },
        child: Stack(
          children: [
            /// 🗺️ MAP
            FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: _initialCenter,
                initialZoom: _initialZoom,
                minZoom: 10.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.greenbin.app',
                  tileProvider: NetworkTileProvider(),
                ),
                BlocBuilder<BinListBloc, BinListState>(
                  buildWhen: (prev, curr) =>
                      prev.bins != curr.bins ||
                      prev.filterCriteria != curr.filterCriteria ||
                      prev.filterFillLevel != curr.filterFillLevel,
                  builder: (context, state) {
                    if (state.bins.isEmpty) return const SizedBox();

                    return MarkerLayer(
                      markers: _buildMarkers(state),
                    );
                  },
                ),
                BlocConsumer<BinListBloc, BinListState>(
                  listenWhen: (previous, current) {
                    return previous.locateStatus != current.locateStatus;
                  },
                  listener: (context, state) {
                    if (state.errorMessage == 'permission_denied_forever' && state.locateStatus==LocateStatus.failure) {
                      showDialog(
                        context: context,
                        useRootNavigator: true,
                        builder: (_) => AlertDialog(
                          title: const Text('Cần quyền định vị'),
                          content: const Text(
                            'Bạn đã tắt quyền định vị. Vui lòng bật trong cài đặt.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                await Geolocator
                                    .openAppSettings(); // 🔥 mở settings
                              },
                              child: const Text('Mở cài đặt'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return BlocBuilder<BinListBloc, BinListState>(
                      buildWhen: (prev, curr) =>
                          prev.userLocation != curr.userLocation,
                      builder: (context, state) {
                        final location = state.userLocation;

                        if (location == null) return const SizedBox();

                        return MarkerLayer(
                          markers: [
                            Marker(
                              point: location,
                              width: 40,
                              height: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                ),
                                child: const Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),

            _buildMapControls(),

            /// 🔍 SEARCH BAR + SUGGESTION
            SafeArea(
              child: Column(
                children: [
                  _buildSearchBar(),
                  _buildSuggestionList(),
                ],
              ),
            ),

            // ✅ Bottom sheet with bin details
            BlocBuilder<BinListBloc, BinListState>(
              buildWhen: (prev, curr) => prev.selectedBin != curr.selectedBin,
              builder: (context, state) {
                if (state.selectedBin == null) return const SizedBox();

                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BinDetailSheet(
                    bin: state.selectedBin!,
                    onClose: () {
                      context.read<BinListBloc>().add(ClearSelectedBin());
                    },
                    onReport: () {
                      context.pushNamed(
                        'createReport',
                        extra: state.selectedBin,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔍 SEARCH BAR
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          /// 🔍 SEARCH
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<BinListBloc>().add(QueryChanged(value));
              },
              decoration: InputDecoration(
                hintText: 'Tìm địa điểm...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// ⚙️ FILTER BUTTON
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                context.read<BinListBloc>().add(ClearSelectedBin());
                _showFilterDialog(context);
              },
              icon: const Icon(Icons.tune),
            ),
          ),
        ],
      ),
    );
  }

  /// 📋 SUGGESTION LIST
  Widget _buildSuggestionList() {
    return BlocBuilder<BinListBloc, BinListState>(
      buildWhen: (prev, curr) =>
          prev.searchResults != curr.searchResults ||
          prev.status != curr.status,
      builder: (context, state) {
        if (state.query.isEmpty) return const SizedBox();

        if (state.status == BinListStatus.loading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }

        if (state.searchResults.isEmpty) {
          return const SizedBox();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          constraints: const BoxConstraints(maxHeight: 300),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              final item = state.searchResults[index];

              return ListTile(
                title: Text(item.displayName ?? ''),
                onTap: () {
                  _mapController.move(item.position, 16);

                  /// clear UI
                  _searchController.clear();
                  context.read<BinListBloc>().add(QueryChanged(''));
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      bottom: 24,
      right: 16,
      child: Column(
        children: [
          /// ➕ Zoom in
          GestureDetector(
            onTap: () {
              final zoom = _mapController.camera.zoom;
              _mapController.move(
                _mapController.camera.center,
                zoom + 1,
              );
            },
            child: _btn(Icons.add),
          ),

          const SizedBox(height: 8),

          /// ➖ Zoom out
          GestureDetector(
            onTap: () {
              final zoom = _mapController.camera.zoom;
              _mapController.move(
                _mapController.camera.center,
                zoom - 1,
              );
            },
            child: _btn(Icons.remove),
          ),

          const SizedBox(height: 12),

          /// 📍 Locate
          GestureDetector(
            onTap: () {
              context.read<BinListBloc>().add(LocateMe());
            },
            child: _btn(Icons.my_location),
          ),
        ],
      ),
    );
  }

  Widget _btn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20),
    );
  }

  List<Marker> _buildMarkers(BinListState state) {
    List<Bin> filteredBins = state.bins.where((bin) {
      final matchType =
          state.filterCriteria == null || bin.type == state.filterCriteria;

      final matchLevel = state.filterFillLevel == null ||
          bin.fillLevel == state.filterFillLevel;

      return matchType && matchLevel;
    }).toList();
    return filteredBins.map((bin) {
      final isSelected = state.selectedBin?.id == bin.id;

      return Marker(
        point: LatLng(bin.latitude, bin.longitude),
        width: isSelected ? 44 : 36,
        height: isSelected ? 44 : 36,
        child: GestureDetector(
          onTap: () {
            context.read<BinListBloc>().add(SelectBin(bin));
            _mapController.move(
              LatLng(bin.latitude, bin.longitude),
              _mapController.camera.zoom,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: _getColor(bin.fillLevel),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getColor(bin.fillLevel).withValues(alpha: 0.4),
                  blurRadius: isSelected ? 12 : 8,
                  spreadRadius: isSelected ? 3 : 2,
                ),
              ],
              border:
                  isSelected ? Border.all(color: Colors.white, width: 3) : null,
            ),
            child: Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: isSelected ? 24 : 20,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }
}


