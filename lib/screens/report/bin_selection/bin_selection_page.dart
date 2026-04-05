import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../bloc/app/app_cubit.dart';
import '../../../bloc/report/bin_selection/bin_selection_cubit.dart';
import '../../../bloc/report/bin_selection/bin_selection_state.dart';
import '../../../configs/app_color.dart';
import '../../../configs/font_size.dart';
import '../../../models/bin.dart';
import '../../../models/enums.dart';
import 'bin_selection_widget.dart';
import '../create_report.dart';
import 'package:geolocator/geolocator.dart';

class BinSelectionPage extends StatefulWidget {
  const BinSelectionPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BinSelectionPageState();
  }
}

class _BinSelectionPageState extends State<BinSelectionPage> {
  late final MapController _mapController;

  bool _isMapLoaded = false;
  bool _isLocating = false;
  LatLng? _userLocation;

  static const LatLng _initialCenter = LatLng(10.7769, 106.7009);
  static const double _initialZoom = 15.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize map
      context.read<BinSelectionCubit>().initialize();
      context.read<AppCubit>().toggleBottomBar(false);

      setState(() => _isMapLoaded = true);
    });
  }

  /// 📍 Get user location and zoom to it
  Future<void> _locateMe() async {
    setState(() => _isLocating = true);

    try {
      // Request permission if needed
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Vui lòng bật quyền định vị để sử dụng tính năng này'),
            backgroundColor: AppColors.redDanger,
          ),
        );
        setState(() => _isLocating = false);
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });

      // Zoom to user location
      _mapController.move(_userLocation!, 16.0);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xác định vị trí của bạn'),
            backgroundColor: AppColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể xác định vị trí: $e'),
            backgroundColor: AppColors.redDanger,
          ),
        );
      }
    } finally {
      setState(() => _isLocating = false);
    }
  }

  void _onBinTapped(Bin bin) {
    context.read<BinSelectionCubit>().selectBin(bin);
    _mapController.move(
      LatLng(bin.latitude, bin.longitude),
      _mapController.camera.zoom,
    );
  }

  Color _getBinColor(BinType type) {
    switch (type) {
      case BinType.organic:
        return AppColors.primary;
      case BinType.recyclable:
        return AppColors.blueInfo;
      case BinType.non_recyclable:
        return AppColors.redDanger;
    }
  }

  void _handleReport(BuildContext context, Bin bin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateReportPage(bin: bin),
      ),
    );
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      appBar: _buildAppBar(),
      body: BlocConsumer<BinSelectionCubit, BinSelectionState>(
        listenWhen: (prev, curr) {
          return prev.status != curr.status;
        },
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.redDanger,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        buildWhen: (prev, curr) {
          return prev.bins != curr.bins ||
              prev.selectedBin != curr.selectedBin ||
              prev.filterCriteria != curr.filterCriteria ||
              prev.displayBins != curr.displayBins;
        },
        builder: (context, state) {
          return _buildBody(context, state);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.lightCard,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Bản đồ thùng rác',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: AppFontSize.displayMedium,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        // Filter button
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.textDark),
          onPressed: () => _showFilterDialog(context),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, BinSelectionState state) {
    if (state.status==BinSelectionStatus.loading && state.displayBins.isNotEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (state.hasSelectedBin) {
          context.read<BinSelectionCubit>().closeBinDetail();
        }
      },
      child: Stack(
        children: [
          // 🗺️ Map
          _isMapLoaded
              ? FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _initialCenter,
                    initialZoom: _initialZoom,
                    minZoom: 10.0,
                    maxZoom: 18.0,
                    onTap: (_, __) {
                      if (state.hasSelectedBin) {
                        context.read<BinSelectionCubit>().closeBinDetail();
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.greenbin.app',
                      tileProvider: NetworkTileProvider(),
                    ),
                    MarkerLayer(
                      markers: _buildMarkers(state),
                    ),
                    // User location marker
                    if (_userLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _userLocation!,
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 3,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                )
              : const SizedBox.shrink(),

          // ✅ Filter badge
          if (state.hasFilters)
            Positioned(
              top: 20,
              right: 16,
              child: FilterBadge(
                onTap: () => _showFilterDialog(context),
              ),
            ),

          // ✅ Zoom controls
          Positioned(
            right: 16,
            bottom: state.hasSelectedBin ? 320 : 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Zoom In
                FloatingActionButton(
                  mini: true,
                  onPressed: _zoomIn,
                  backgroundColor: AppColors.lightCard,
                  heroTag: 'zoom_in',
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),

                // Zoom Out
                FloatingActionButton(
                  mini: true,
                  onPressed: _zoomOut,
                  backgroundColor: AppColors.lightCard,
                  heroTag: 'zoom_out',
                  child: const Icon(
                    Icons.remove,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),

                // Locate Me
                FloatingActionButton(
                  mini: true,
                  onPressed: _isLocating ? null : _locateMe,
                  backgroundColor:
                      _isLocating ? AppColors.lightBg : AppColors.primary,
                  heroTag: 'locate_me',
                  child: _isLocating
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.7),
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                ),
              ],
            ),
          ),

          // ✅ Bottom sheet with bin details
          if (state.hasSelectedBin)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BinDetailSheet(
                bin: state.selectedBin!,
                onClose: () => context.read<BinSelectionCubit>().closeBinDetail(),
                onReport: () => _handleReport(context, state.selectedBin!),
              ),
            ),
        ],
      ),
    );
  }

  /// 🎯 Build bin markers
  List<Marker> _buildMarkers(BinSelectionState state) {
    return state.displayBins.map((bin) {
      final isSelected = state.selectedBin?.id == bin.id;

      return Marker(
        point: LatLng(bin.latitude, bin.longitude),
        width: isSelected ? 56 : 48,
        height: isSelected ? 56 : 48,
        child: GestureDetector(
          onTap: () => _onBinTapped(bin),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _getBinColor(bin.type),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getBinColor(bin.type).withOpacity(0.4),
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
              size: isSelected ? 28 : 24,
            ),
          ),
        ),
      );
    }).toList();
  }

  /// 📋 Filter dialog
  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    // context.read<AppCubit>().toggleBottomBar(true);
    super.dispose();
  }
}
