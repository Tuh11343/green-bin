//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import '../../bloc/user_home/user_home_cubit.dart';
// import '../../configs/app_color.dart';
// import '../../configs/font_size.dart';
// import '../../widgets/custom_card.dart';
// import '../../widgets/custom_text.dart';
// import '../../widgets/custom_app_drawer.dart';
//
// class UserHomePage extends StatefulWidget {
//   const UserHomePage({super.key});
//
//   @override
//   State<UserHomePage> createState() => _UserHomePageState();
// }
//
// class _UserHomePageState extends State<UserHomePage> {
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       context.read<UserHomeCubit>().refreshUser();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const AppDrawer(),
//       appBar: AppBar(
//         centerTitle: true,
//         title: const _AppBarTitle(),
//         backgroundColor: AppColors.primary,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             _PointsCard(),
//             _Headline(),
//             _QuickTaskGrid(),
//             _TipCard(),
//             _RecentActivity(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class _AppBarTitle extends StatelessWidget {
//   const _AppBarTitle();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<UserHomeCubit, UserHomeState, String>(
//       selector: (state) => state.user?.name ?? 'Người dùng',
//       builder: (_, name) {
//         return Column(
//           children: [
//             const CustomText('Xin chào,', fontSize: 12, color: Colors.white70),
//             CustomText(
//               name,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               fontSize: 16,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class _PointsCard extends StatelessWidget {
//   const _PointsCard();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<UserHomeCubit, UserHomeState, (int, int)>(
//       selector: (state) => (
//       state.user?.points ?? 0,
//       state.pointsThisMonth ?? 0
//       ),
//       builder: (_, data) {
//         final points = data.$1;
//         final monthly = data.$2;
//
//         return CustomCard(
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           padding: const EdgeInsets.all(20),
//           child: Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const CustomText('Điểm xanh'),
//                   Text('$points điểm'),
//                   CustomText('+$monthly tháng này'),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// enum QuickTaskType { map, report, reward }
//
// class _QuickTaskGrid extends StatelessWidget {
//   const _QuickTaskGrid();
//
//   static const tasks = [
//     {
//       'type': QuickTaskType.map,
//       'icon': FontAwesomeIcons.map,
//       'title': 'Bản Đồ',
//     },
//     {
//       'type': QuickTaskType.report,
//       'icon': FontAwesomeIcons.file,
//       'title': 'Báo Cáo',
//     },
//     {
//       'type': QuickTaskType.reward,
//       'icon': FontAwesomeIcons.gift,
//       'title': 'Đổi Thưởng',
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: LayoutBuilder(
//         builder: (_, constraints) {
//           final width = (constraints.maxWidth - 12) / 2;
//
//           return Wrap(
//             spacing: 12,
//             runSpacing: 12,
//             children: tasks.map((task) {
//               return SizedBox(
//                 width: width,
//                 child: _QuickTaskItem(task: task),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _QuickTaskItem extends StatelessWidget {
//   final Map<String, dynamic> task;
//
//   const _QuickTaskItem({required this.task});
//
//   @override
//   Widget build(BuildContext context) {
//     final type = task['type'] as QuickTaskType;
//
//     return InkWell(
//       onTap: () {
//         switch (type) {
//           case QuickTaskType.map:
//             context.go('/map');
//             break;
//           case QuickTaskType.report:
//             context.push('/report');
//             break;
//           case QuickTaskType.reward:
//             context.go('/reward');
//             break;
//         }
//       },
//       borderRadius: BorderRadius.circular(14),
//       child: CustomCard(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             FaIcon(task['icon']),
//             const SizedBox(height: 8),
//             CustomText(task['title']),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _RecentActivity extends StatelessWidget {
//   const _RecentActivity();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<UserHomeCubit, UserHomeState>(
//       buildWhen: (p, c) => p.recentReports != c.recentReports,
//       builder: (_, state) {
//         if (state.status == UserHomeStatus.loading) {
//           return const CircularProgressIndicator();
//         }
//
//         if (state.recentReports.isEmpty) {
//           return const CustomText('Chưa có hoạt động');
//         }
//
//         return Column(
//           children: state.recentReports.map((r) {
//             return _ActivityItem(report: r);
//           }).toList(),
//         );
//       },
//     );
//   }
// }
//
// class _ActivityItem extends StatelessWidget {
//   final Report report;
//
//   const _ActivityItem({required this.report});
//
//   @override
//   Widget build(BuildContext context) {
//     final isDone = report.status == ReportStatus.completed;
//
//     return CustomCard(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Expanded(child: Text(report.description)),
//           Text('+${report.points ?? 0}'),
//           if (isDone)
//             const Icon(Icons.check, color: Colors.green)
//           else
//             const Text('Đang xử lý'),
//         ],
//       ),
//     );
//   }
// }
//
// class _Headline extends StatelessWidget {
//   const _Headline();
//
//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.all(20),
//       child: CustomText(
//         'Tác Vụ Nhanh',
//         fontSize: AppFontSize.displayLarge,
//       ),
//     );
//   }
// }
//
