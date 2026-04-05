// class BinSelectionPage extends StatefulWidget {
//   const BinSelectionPage({super.key});
//
//   @override
//   State<StatefulWidget> createState() {
//     return _BinSelectionPageState();
//   }
// }
//
// class _BinSelectionPageState extends State<BinSelectionPage> {
//   late final MapController _mapController;
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//
//   // Subject cho debounce search
//   final _searchSubject = BehaviorSubject<String>();
//
//   static const LatLng _initialCenter = LatLng(10.7769, 106.7009);
//   static const double _initialZoom = 15.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<MapCubit>().initialize();
//       context.read<AppCubit>().toggleBottomBar(false);
//     });
//
//     _setupSearchDebounce();
//     _setupFocusListener();
//   }
//
//
//   void _setupSearchDebounce() {
//     _searchSubject
//         .debounceTime(const Duration(milliseconds: 500))
//         .distinct()
//         .listen((query) {
//       context.read<MapCubit>().searchLocation(query);
//     });
//   }
//
//   void _setupFocusListener() {
//     _searchFocusNode.addListener(() {
//       if (_searchFocusNode.hasFocus) {
//         final state = context.read<MapCubit>().state;
//         if (state.searchResults.isNotEmpty) {
//           context.read<MapCubit>().toggleSearchResults(true);
//         }
//       }
//     });
//   }
//
//   Color _getBinColor(BinType type) {
//     switch (type) {
//       case BinType.organic:
//         return AppColors.primary;
//       case BinType.recyclable:
//         return AppColors.blueInfo;
//       case BinType.non_recyclable:
//         return AppColors.redDanger;
//     }
//   }
//
//   void _onBinTapped(Bin bin) {
//     context.read<MapCubit>().selectBin(bin);
//     _mapController.move(
//       LatLng(bin.latitude, bin.longitude),
//       _mapController.camera.zoom,
//     );
//   }
//
//   void _selectSearchResult(SearchResult result) {
//     context.read<MapCubit>().selectSearchResult(result);
//     _searchController.text = result.shortName;
//     _mapController.move(result.position, 16.0);
//     _searchFocusNode.unfocus();
//   }
//
//   void _clearSearch() {
//     _searchController.clear();
//     context.read<MapCubit>().clearSearch();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightBg,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.lightCard,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Bản đồ thùng rác',
//           style: TextStyle(
//             color: AppColors.textDark,
//             fontSize: AppFontSize.displayMedium,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: [
//           // Filter button
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: AppColors.textDark),
//             onPressed: () => _showFilterDialog(context),
//           ),
//         ],
//       ),
//       body: BlocConsumer<MapCubit, MapState>(
//         listener: (context, state) {
//           // Show error messages
//           if (state.isFailure && state.errorMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.errorMessage!),
//                 backgroundColor: AppColors.redDanger,
//                 behavior: SnackBarBehavior.floating,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state.isLoading && !state.hasBins) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//               ),
//             );
//           }
//
//           return GestureDetector(
//             onTap: () {
//               if (state.showSearchResults) {
//                 context.read<MapCubit>().toggleSearchResults(false);
//               }
//               _searchFocusNode.unfocus();
//             },
//             child: Stack(
//               children: [
//                 Column(
//                   children: [
//                     // Search bar
//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: SearchBarCustom(
//                         controller: _searchController,
//                         focusNode: _searchFocusNode,
//                         isLoading: state.isSearching,
//                         onChanged: (value) => _searchSubject.add(value),
//                         onClear: _clearSearch,
//                       ),
//                     ),
//                     // Map
//                     Expanded(
//                       child: FlutterMap(
//                         mapController: _mapController,
//                         options: MapOptions(
//                           initialCenter: _initialCenter,
//                           initialZoom: _initialZoom,
//                           minZoom: 10.0,
//                           maxZoom: 18.0,
//                           interactionOptions: const InteractionOptions(
//                             flags: InteractiveFlag.all,
//                           ),
//                           onTap: (_, __) {
//                             if (state.hasSelectedBin ||
//                                 state.showSearchResults) {
//                               context.read<MapCubit>().selectBin(null);
//                               context
//                                   .read<MapCubit>()
//                                   .toggleSearchResults(false);
//                             }
//                           },
//                         ),
//                         children: [
//                           TileLayer(
//                             urlTemplate:
//                                 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                             userAgentPackageName: 'com.example.app',
//                             tileProvider: NetworkTileProvider(),
//                           ),
//                           MarkerLayer(
//                             markers: _buildMarkers(state),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 // Search results dropdown
//                 if (state.showSearchResults)
//                   Positioned(
//                     top: 76,
//                     left: 12,
//                     right: 12,
//                     child: SearchResultsDropdown(
//                       results: state.searchResults,
//                       isLoading: state.isSearching,
//                       onResultTap: _selectSearchResult,
//                     ),
//                   ),
//
//                 // Filter badge
//                 if (state.hasFilters)
//                   Positioned(
//                     top: 20,
//                     right: 16,
//                     child: FilterBadge(
//                       onTap: () => _showFilterDialog(context),
//                     ),
//                   ),
//
//                 // Zoom controls
//                 Positioned(
//                   right: 16,
//                   bottom: state.hasSelectedBin ? 320 : 100,
//                   child: ZoomControls(
//                     onZoomIn: () {
//                       final currentZoom = _mapController.camera.zoom;
//                       _mapController.move(
//                         _mapController.camera.center,
//                         currentZoom + 1,
//                       );
//                     },
//                     onZoomOut: () {
//                       final currentZoom = _mapController.camera.zoom;
//                       _mapController.move(
//                         _mapController.camera.center,
//                         currentZoom - 1,
//                       );
//                     },
//                   ),
//                 ),
//
//                 // Bottom sheet with bin details
//                 if (state.hasSelectedBin)
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: BinDetailSheet(
//                       bin: state.selectedBin!,
//                       onClose: () => context.read<MapCubit>().closeBinDetail(),
//                       onReport: () =>
//                           _handleReport(context, state.selectedBin!),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   List<Marker> _buildMarkers(MapState state) {
//     final binsToShow = state.displayBins;
//
//     return binsToShow.map((bin) {
//       final isSelected = state.selectedBin?.id == bin.id;
//
//       return Marker(
//         point: LatLng(bin.latitude, bin.longitude),
//         width: isSelected ? 56 : 48,
//         height: isSelected ? 56 : 48,
//         child: GestureDetector(
//           onTap: () => _onBinTapped(bin),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             decoration: BoxDecoration(
//               color: _getBinColor(bin.type),
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: _getBinColor(bin.type).withOpacity(0.4),
//                   blurRadius: isSelected ? 12 : 8,
//                   spreadRadius: isSelected ? 3 : 2,
//                 ),
//               ],
//               border:
//                   isSelected ? Border.all(color: Colors.white, width: 3) : null,
//             ),
//             child: Icon(
//               Icons.delete_outline,
//               color: Colors.white,
//               size: isSelected ? 28 : 24,
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }
//
//   void _handleReport(BuildContext context, Bin bin) {
//     // ScaffoldMessenger.of(context).showSnackBar(
//     //   SnackBar(
//     //     content: Text('Chỉ đường đến thùng rác #${bin.id}'),
//     //     backgroundColor: AppColors.primary,
//     //     behavior: SnackBarBehavior.floating,
//     //   ),
//     // );
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CreateReportPage(bin: bin),
//       ),
//     );
//     // TODO: Implement navigation logic
//   }
//
//   void _showFilterDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) => FilterBottomSheet,
//     );
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _searchFocusNode.dispose();
//     _searchSubject.close();
//     _mapController.dispose();
//     context.read<AppCubit>().toggleBottomBar(true);
//     super.dispose();
//   }
// }
//
// // Filter Badge Widget
// class FilterBadge extends StatelessWidget {
//   final VoidCallback onTap;
//
//   const FilterBadge({required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: AppColors.primary,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               spreadRadius: 1,
//             ),
//           ],
//         ),
//         child: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.filter_list, color: Colors.white, size: 16),
//             SizedBox(width: 4),
//             Text(
//               'Lọc',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: AppFontSize.labelSmall,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Filter Bottom Sheet Widget
// class _FilterBottomSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MapCubit, MapState>(
//       builder: (context, state) {
//         return Container(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Lọc thùng rác',
//                     style: TextStyle(
//                       fontSize: AppFontSize.displayMedium,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textDark,
//                     ),
//                   ),
//                   if (state.hasFilters)
//                     TextButton(
//                       onPressed: () {
//                         context.read<MapCubit>().clearFilters();
//                         Navigator.pop(context);
//                       },
//                       child: const Text('Xóa bộ lọc'),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Loại thùng',
//                 style: TextStyle(
//                   fontSize: AppFontSize.bodyMedium,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textDark,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Wrap(
//                 spacing: 8,
//                 children: [
//                   BinFilterChip(
//                     label: 'Hữu cơ',
//                     isSelected: state.filterType == BinType.organic,
//                     onTap: () {
//                       context.read<MapCubit>().filterBinsByType(
//                             state.filterType == BinType.organic
//                                 ? null
//                                 : BinType.organic,
//                           );
//                     },
//                   ),
//                   BinFilterChip(
//                     label: 'Tái chế',
//                     isSelected: state.filterType == BinType.recyclable,
//                     onTap: () {
//                       context.read<MapCubit>().filterBinsByType(
//                             state.filterType == BinType.recyclable
//                                 ? null
//                                 : BinType.recyclable,
//                           );
//                     },
//                   ),
//                   BinFilterChip(
//                     label: 'Vô cơ',
//                     isSelected: state.filterType == BinType.non_recyclable,
//                     onTap: () {
//                       context.read<MapCubit>().filterBinsByType(
//                             state.filterType == BinType.non_recyclable
//                                 ? null
//                                 : BinType.non_recyclable,
//                           );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Mức độ đầy',
//                 style: TextStyle(
//                   fontSize: AppFontSize.bodyMedium,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textDark,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Wrap(
//                 spacing: 8,
//                 children: [
//                   FilterChip(
//                     label: 'Thấp',
//                     isSelected: state.filterFillLevel == FillLevel.low,
//                     onTap: () {
//                       context.read<MapCubit>().filterBinsByFillLevel(
//                             state.filterFillLevel == FillLevel.low
//                                 ? null
//                                 : FillLevel.low,
//                           );
//                     },
//                   ),
//                   FilterChip(
//                     label: 'Trung bình',
//                     isSelected: state.filterFillLevel == FillLevel.medium,
//                     onTap: () {
//                       context.read<MapCubit>().filterBinsByFillLevel(
//                             state.filterFillLevel == FillLevel.medium
//                                 ? null
//                                 : FillLevel.medium,
//                           );
//                     },
//                   ),
//                   FilterChip(
//                     label: 'Cao',
//                     isSelected: state.filterFillLevel == FillLevel.high,
//                     onTap: () {
//                       context.read<MapCubit>().filterBinsByFillLevel(
//                             state.filterFillLevel == FillLevel.high
//                                 ? null
//                                 : FillLevel.high,
//                           );
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     'ÁP DỤNG',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: AppFontSize.labelLarge,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }