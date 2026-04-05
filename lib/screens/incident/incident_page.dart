// import 'package:flutter/material.dart';
// import '../../configs/app_color.dart';
// import '../../models/enums.dart';
// import '../../models/incident.dart';
//
// class IncidentDetailPage extends StatefulWidget {
//   final Incident incident;
//
//   const IncidentDetailPage({
//     Key? key,
//     required this.incident,
//   }) : super(key: key);
//
//   @override
//   State<IncidentDetailPage> createState() => _IncidentDetailPageState();
// }
//
// class _IncidentDetailPageState extends State<IncidentDetailPage> {
//   late TextEditingController _commentController;
//
//   @override
//   void initState() {
//     super.initState();
//     _commentController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         title: Text('Sự cố #${widget.incident.id ?? "Mới"}'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildStatusBanner(),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildHeadline("Thông tin sự cố"),
//                   const SizedBox(height: 12),
//                   _buildIncidentInfoCard(),
//                   const SizedBox(height: 24),
//                   _buildHeadline("Chi tiết vị trí"),
//                   const SizedBox(height: 12),
//                   _buildLocationCard(),
//                   const SizedBox(height: 24),
//                   if (widget.incident.imageUrl != null) ...[
//                     _buildHeadline("Hình ảnh sự cố"),
//                     const SizedBox(height: 12),
//                     _buildImageCard(),
//                     const SizedBox(height: 24),
//                   ],
//                   _buildHeadline("Lịch sử cập nhật"),
//                   const SizedBox(height: 12),
//                   _buildTimeline(),
//                   const SizedBox(height: 24),
//                   _buildHeadline("Ghi chú và bình luận"),
//                   const SizedBox(height: 12),
//                   _buildCommentSection(),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomAction(),
//     );
//   }
//
//   // Status Banner
//   Widget _buildStatusBanner() {
//     final statusColor = _getStatusColor(widget.incident.status);
//     final statusText = _getStatusText(widget.incident.status);
//     final priorityColor = _getPriorityColor(widget.incident.priority);
//     final priorityText = _getPriorityText(widget.incident.priority);
//
//     return Container(
//       color: statusColor.withOpacity(0.1),
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 12,
//                       height: 12,
//                       decoration: BoxDecoration(
//                         color: statusColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       statusText,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: statusColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Được cập nhật lần cuối: ${_formatDateTime(widget.incident.updatedAt)}",
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: priorityColor.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: priorityColor.withOpacity(0.5)),
//             ),
//             child: Text(
//               priorityText,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: priorityColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Headline
//   Widget _buildHeadline(String title) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Container(
//           width: 40,
//           height: 3,
//           decoration: BoxDecoration(
//             color: AppColors.primary,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Incident Info Card
//   Widget _buildIncidentInfoCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(Icons.warning_amber_rounded, color: AppColors.primary),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.incident.type.toString().split('.').last,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       "Loại sự cố",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           const Divider(height: 1),
//           const SizedBox(height: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Mô tả chi tiết",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey.shade600,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: Text(
//                   widget.incident.description,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.black87,
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: _infoTile(
//                   "Thời gian báo cáo",
//                   _formatDateTime(widget.incident.createdAt),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _infoTile(
//                   "ID Thùng rác",
//                   widget.incident.binId?.toString() ?? "Chưa xác định",
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Location Card
//   Widget _buildLocationCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.location_on,
//                     size: 48,
//                     color: AppColors.primary,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Vị trí sự cố",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "${widget.incident.latitude.toStringAsFixed(4)}, ${widget.incident.longitude.toStringAsFixed(4)}",
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Icon(Icons.navigation, color: AppColors.primary, size: 18),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   "Nhấn để mở trên bản đồ",
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ),
//               Icon(Icons.chevron_right, color: Colors.grey.shade400),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Image Card
//   Widget _buildImageCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Image.network(
//           widget.incident.imageUrl!,
//           fit: BoxFit.cover,
//           height: 300,
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               height: 300,
//               color: Colors.grey.shade200,
//               child: const Center(
//                 child: Icon(Icons.image_not_supported, color: Colors.grey),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // Timeline
//   Widget _buildTimeline() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           _timelineItem(
//             icon: Icons.add_circle_outline,
//             title: "Báo cáo sự cố",
//             time: _formatDateTime(widget.incident.createdAt),
//             isFirst: true,
//           ),
//           _timelineItem(
//             icon: Icons.update,
//             title: "Cập nhật trạng thái",
//             time: _formatDateTime(widget.incident.updatedAt),
//             isFirst: false,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _timelineItem({
//     required IconData icon,
//     required String title,
//     required String time,
//     required bool isFirst,
//   }) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(icon, size: 20, color: AppColors.primary),
//                 ),
//                 if (!isFirst)
//                   Container(
//                     width: 2,
//                     height: 30,
//                     margin: const EdgeInsets.only(top: 8),
//                     color: AppColors.primary.withOpacity(0.3),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     time,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // Comment Section
//   Widget _buildCommentSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextField(
//             controller: _commentController,
//             maxLines: 4,
//             decoration: InputDecoration(
//               hintText: "Thêm ghi chú hoặc bình luận...",
//               hintStyle: TextStyle(color: Colors.grey.shade400),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: AppColors.primary, width: 2),
//               ),
//               contentPadding: const EdgeInsets.all(12),
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 if (_commentController.text.isNotEmpty) {
//                   // Xử lý ghi chú
//                   _commentController.clear();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Ghi chú đã được lưu"),
//                       duration: Duration(seconds: 2),
//                     ),
//                   );
//                 }
//               },
//               icon: const Icon(Icons.send, size: 18),
//               label: const Text("Gửi ghi chú"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Info Tile
//   Widget _infoTile(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey.shade600,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Bottom Action
//   Widget _buildBottomAction() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Expanded(
//             child: OutlinedButton.icon(
//               onPressed: () {
//                 // Xử lý phản hồi
//               },
//               icon: const Icon(Icons.reply, size: 18),
//               label: const Text("Phản hồi"),
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 side: const BorderSide(color: AppColors.primary),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 // Xử lý giải quyết
//               },
//               icon: const Icon(Icons.check_circle, size: 18),
//               label: const Text("Giải quyết"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Helper Functions
//   Color _getStatusColor(IncidentStatus status) {
//     switch (status) {
//       case IncidentStatus.OPEN:
//         return Colors.red;
//       case IncidentStatus.IN_Progress:
//         return Colors.orange;
//       case IncidentStatus.Resolved:
//         return Colors.green;
//     }
//   }
//
//   String _getStatusText(IncidentStatus status) {
//     switch (status) {
//       case IncidentStatus.OPEN:
//         return "Chưa xử lý";
//       case IncidentStatus.IN_Progress:
//         return "Đang xử lý";
//       case IncidentStatus.Resolved:
//         return "Đã giải quyết";
//     }
//   }
//
//   Color _getPriorityColor(Priority priority) {
//     switch (priority) {
//       case Priority.Low:
//         return Colors.blue;
//       case Priority.Medium:
//         return Colors.orange;
//       case Priority.High:
//         return Colors.red;
//     }
//   }
//
//   String _getPriorityText(Priority priority) {
//     switch (priority) {
//       case Priority.Low:
//         return "Ưu tiên thấp";
//       case Priority.Medium:
//         return "Ưu tiên trung bình";
//       case Priority.High:
//         return "Ưu tiên cao";
//     }
//   }
//
//   String _formatDateTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final diff = now.difference(dateTime);
//
//     if (diff.inDays == 0) {
//       if (diff.inHours == 0) {
//         return "${diff.inMinutes} phút trước";
//       }
//       return "${diff.inHours} giờ trước";
//     }
//     if (diff.inDays == 1) {
//       return "Hôm qua";
//     }
//     if (diff.inDays < 7) {
//       return "${diff.inDays} ngày trước";
//     }
//
//     return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
//   }
// }