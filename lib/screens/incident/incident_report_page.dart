// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import '../../configs/app_color.dart';
// import '../../models/incident.dart';
// import '../../models/enums.dart';
// import 'incident_page.dart';
//
// class IncidentReportPage extends StatefulWidget {
//   final int userId; // ID của người báo cáo (collector)
//   final int binId;
//   final double? initialLatitude;
//   final double? initialLongitude;
//
//   const IncidentReportPage({
//     Key? key,
//     required this.userId,
//     this.initialLatitude,
//     this.initialLongitude,
//   }) : super(key: key);
//
//   @override
//   State<IncidentReportPage> createState() => _IncidentReportPageState();
// }
//
// class _IncidentReportPageState extends State<IncidentReportPage> {
//   final _formKey = GlobalKey<FormState>();
//   final ImagePicker _imagePicker = ImagePicker();
//
//   late TextEditingController _descriptionController;
//   late TextEditingController _binIdController;
//   late TextEditingController _latitudeController;
//   late TextEditingController _longitudeController;
//
//   IncidentType _selectedType = IncidentType.Other;
//   Priority _selectedPriority = Priority.Medium;
//   File? _selectedImage;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _descriptionController = TextEditingController();
//     _binIdController = TextEditingController();
//     _latitudeController = TextEditingController(
//       text: widget.initialLatitude?.toString() ?? '',
//     );
//     _longitudeController = TextEditingController(
//       text: widget.initialLongitude?.toString() ?? '',
//     );
//   }
//
//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     _binIdController.dispose();
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//       if (image != null) {
//         setState(() {
//           _selectedImage = File(image.path);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi chọn ảnh: $e')),
//       );
//     }
//   }
//
//   Future<void> _submitReport() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     if (_latitudeController.text.isEmpty || _longitudeController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Vui lòng nhập tọa độ vị trí')),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       // Mô phỏng upload ảnh và tạo incident
//       String? imageUrl;
//       if (_selectedImage != null) {
//         // Trong thực tế, upload ảnh lên server ở đây
//         // imageUrl = await _uploadImage(_selectedImage!);
//         imageUrl = 'https://via.placeholder.com/400x300';
//       }
//
//       // Tạo đối tượng Incident
//       final newIncident = Incident(
//         id: DateTime.now().millisecondsSinceEpoch,
//         userId: widget.userId,
//         latitude: double.parse(_latitudeController.text),
//         longitude: double.parse(_longitudeController.text),
//         description: _descriptionController.text,
//         type: _selectedType,
//         imageUrl: imageUrl,
//         status: IncidentStatus.OPEN,
//         priority: _selectedPriority,
//         binId: _binIdController.text.isNotEmpty
//             ? int.tryParse(_binIdController.text)
//             : null,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );
//
//       // TODO: Gửi incident lên server
//       // await _incidentService.createIncident(newIncident);
//
//       setState(() => _isLoading = false);
//
//       // Chuyển đến trang detail để hiển thị incident vừa tạo
//       if (mounted) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => IncidentDetailPage(incident: newIncident),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         title: const Text('Báo cáo sự cố mới'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeadline("Thông tin cơ bản"),
//               const SizedBox(height: 12),
//               _buildTypeSelector(),
//               const SizedBox(height: 20),
//               _buildPrioritySelector(),
//               const SizedBox(height: 24),
//               _buildHeadline("Mô tả chi tiết"),
//               const SizedBox(height: 12),
//               _buildDescriptionField(),
//               const SizedBox(height: 24),
//               _buildHeadline("Vị trí sự cố"),
//               const SizedBox(height: 12),
//               _buildLocationFields(),
//               const SizedBox(height: 24),
//               _buildHeadline("Thùng rác liên quan"),
//               const SizedBox(height: 12),
//               _buildBinIdField(),
//               const SizedBox(height: 24),
//               _buildHeadline("Hình ảnh minh chứng"),
//               const SizedBox(height: 12),
//               _buildImageUploadArea(),
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildSubmitButton(),
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
//   // Type Selector
//   Widget _buildTypeSelector() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Loại sự cố",
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: DropdownButton<IncidentType>(
//               value: _selectedType,
//               isExpanded: true,
//               underline: const SizedBox.shrink(),
//               items: IncidentType.values.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type.toString().split('.').last),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() => _selectedType = value);
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Priority Selector
//   Widget _buildPrioritySelector() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Độ ưu tiên",
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: Priority.values.map((priority) {
//               final isSelected = _selectedPriority == priority;
//               final color = _getPriorityColor(priority);
//               return Expanded(
//                 child: GestureDetector(
//                   onTap: () => setState(() => _selectedPriority = priority),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     margin: const EdgeInsets.symmetric(horizontal: 4),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? color.withOpacity(0.2)
//                           : Colors.grey.shade100,
//                       border: Border.all(
//                         color: isSelected ? color : Colors.grey.shade300,
//                         width: isSelected ? 2 : 1,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       _getPriorityText(priority),
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
//                         color: isSelected ? color : Colors.grey.shade700,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Description Field
//   Widget _buildDescriptionField() {
//     return TextFormField(
//       controller: _descriptionController,
//       maxLines: 5,
//       minLines: 4,
//       validator: (value) {
//         if (value?.isEmpty ?? true) {
//           return "Vui lòng nhập mô tả sự cố";
//         }
//         if (value!.length < 10) {
//           return "Mô tả phải có ít nhất 10 ký tự";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         hintText: "Mô tả chi tiết về sự cố...",
//         hintStyle: TextStyle(color: Colors.grey.shade400),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.primary, width: 2),
//         ),
//         contentPadding: const EdgeInsets.all(14),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     );
//   }
//
//   // Location Fields
//   Widget _buildLocationFields() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.location_on, color: AppColors.primary, size: 18),
//               const SizedBox(width: 8),
//               Text(
//                 "Tọa độ GPS",
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: _latitudeController,
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                     signed: true,
//                   ),
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) return "Nhập vĩ độ";
//                     if (double.tryParse(value!) == null) return "Không hợp lệ";
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     labelText: "Vĩ độ",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     contentPadding: const EdgeInsets.all(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: TextFormField(
//                   controller: _longitudeController,
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                     signed: true,
//                   ),
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) return "Nhập kinh độ";
//                     if (double.tryParse(value!) == null) return "Không hợp lệ";
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     labelText: "Kinh độ",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     contentPadding: const EdgeInsets.all(12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton.icon(
//               onPressed: () {
//                 // TODO: Lấy vị trí GPS hiện tại
//               },
//               icon: const Icon(Icons.my_location, size: 18),
//               label: const Text("Lấy vị trí hiện tại"),
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Bin ID Field
//   Widget _buildBinIdField() {
//     return TextFormField(
//       controller: _binIdController,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: "ID Thùng rác (tùy chọn)",
//         hintText: "Nhập ID nếu sự cố liên quan đến thùng rác",
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.primary, width: 2),
//         ),
//         contentPadding: const EdgeInsets.all(14),
//         filled: true,
//         fillColor: Colors.white,
//         prefixIcon: const Icon(Icons.delete_outline),
//       ),
//     );
//   }
//
//   // Image Upload Area
//   Widget _buildImageUploadArea() {
//     return GestureDetector(
//       onTap: _pickImage,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: AppColors.primary.withOpacity(0.3),
//             width: 2,
//             style: BorderStyle.solid,
//           ),
//         ),
//         child: _selectedImage != null
//             ? Column(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.file(
//                 _selectedImage!,
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 OutlinedButton.icon(
//                   onPressed: _pickImage,
//                   icon: const Icon(Icons.edit),
//                   label: const Text("Thay đổi ảnh"),
//                 ),
//                 const SizedBox(width: 12),
//                 OutlinedButton.icon(
//                   onPressed: () => setState(() => _selectedImage = null),
//                   icon: const Icon(Icons.close),
//                   label: const Text("Xóa"),
//                 ),
//               ],
//             ),
//           ],
//         )
//             : Column(
//           children: [
//             Icon(
//               Icons.camera_alt_outlined,
//               size: 48,
//               color: AppColors.primary,
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "Chụp ảnh minh chứng",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "Nhấn để chụp ảnh sự cố",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Submit Button
//   Widget _buildSubmitButton() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: ElevatedButton.icon(
//         onPressed: _isLoading ? null : _submitReport,
//         icon: _isLoading
//             ? const SizedBox(
//           height: 18,
//           width: 18,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation(Colors.white),
//           ),
//         )
//             : const Icon(Icons.send),
//         label: Text(_isLoading ? "Đang gửi..." : "GỬI BÁO CÁO"),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           disabledBackgroundColor: Colors.grey.shade400,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper Functions
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
//         return "Thấp";
//       case Priority.Medium:
//         return "Trung bình";
//       case Priority.High:
//         return "Cao";
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import '../../configs/app_color.dart';
// import '../../models/bin.dart';
// import '../../models/incident.dart';
// import '../../models/enums.dart';
// import 'incident_page.dart';
//
// class IncidentReportPage extends StatefulWidget {
//   final int userId; // ID của người báo cáo (collector)
//   final int? binId; // ID của thùng rác
//   final Bin? bin; // Hoặc truyền cả object Bin
//   final double? initialLatitude;
//   final double? initialLongitude;
//
//   const IncidentReportPage({
//     Key? key,
//     required this.userId,
//     this.binId,
//     this.bin,
//     this.initialLatitude,
//     this.initialLongitude,
//   }) : super(key: key);
//
//   @override
//   State<IncidentReportPage> createState() => _IncidentReportPageState();
// }
//
// class _IncidentReportPageState extends State<IncidentReportPage> {
//   final _formKey = GlobalKey<FormState>();
//   final ImagePicker _imagePicker = ImagePicker();
//
//   late TextEditingController _descriptionController;
//   late TextEditingController _binIdController;
//   late TextEditingController _latitudeController;
//   late TextEditingController _longitudeController;
//
//   IncidentType _selectedType = IncidentType.Other;
//   Priority _selectedPriority = Priority.Medium;
//   File? _selectedImage;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _descriptionController = TextEditingController();
//     _binIdController = TextEditingController();
//     _latitudeController = TextEditingController(
//       text: widget.initialLatitude?.toString() ?? '',
//     );
//     _longitudeController = TextEditingController(
//       text: widget.initialLongitude?.toString() ?? '',
//     );
//   }
//
//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     _binIdController.dispose();
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//       if (image != null) {
//         setState(() {
//           _selectedImage = File(image.path);
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi chọn ảnh: $e')),
//       );
//     }
//   }
//
//   Future<void> _submitReport() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     if (_latitudeController.text.isEmpty || _longitudeController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Vui lòng nhập tọa độ vị trí')),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       // Mô phỏng upload ảnh và tạo incident
//       String? imageUrl;
//       if (_selectedImage != null) {
//         // Trong thực tế, upload ảnh lên server ở đây
//         // imageUrl = await _uploadImage(_selectedImage!);
//         imageUrl = 'https://via.placeholder.com/400x300';
//       }
//
//       // Tạo đối tượng Incident
//       final newIncident = Incident(
//         id: DateTime.now().millisecondsSinceEpoch,
//         userId: widget.userId,
//         latitude: double.parse(_latitudeController.text),
//         longitude: double.parse(_longitudeController.text),
//         description: _descriptionController.text,
//         type: _selectedType,
//         imageUrl: imageUrl,
//         status: IncidentStatus.OPEN,
//         priority: _selectedPriority,
//         binId: widget.binId ?? widget.bin?.id,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );
//
//       // TODO: Gửi incident lên server
//       // await _incidentService.createIncident(newIncident);
//
//       setState(() => _isLoading = false);
//
//       // Chuyển đến trang detail để hiển thị incident vừa tạo
//       if (mounted) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => IncidentDetailPage(incident: newIncident),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         title: const Text('Báo cáo sự cố mới'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeadline("Thông tin cơ bản"),
//               const SizedBox(height: 12),
//               _buildTypeSelector(),
//               const SizedBox(height: 20),
//               _buildPrioritySelector(),
//               const SizedBox(height: 24),
//               if (widget.bin != null) ...[
//                 _buildHeadline("Thông tin thùng rác"),
//                 const SizedBox(height: 12),
//                 _buildBinInfoCard(),
//                 const SizedBox(height: 24),
//               ],
//               _buildHeadline("Mô tả chi tiết"),
//               const SizedBox(height: 12),
//               _buildDescriptionField(),
//               const SizedBox(height: 24),
//               _buildHeadline("Vị trí sự cố"),
//               const SizedBox(height: 12),
//               _buildLocationFields(),
//               const SizedBox(height: 24),
//               _buildHeadline("Hình ảnh minh chứng"),
//               const SizedBox(height: 12),
//               _buildImageUploadArea(),
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildSubmitButton(),
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
//   // Type Selector
//   Widget _buildTypeSelector() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Loại sự cố",
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: DropdownButton<IncidentType>(
//               value: _selectedType,
//               isExpanded: true,
//               underline: const SizedBox.shrink(),
//               items: IncidentType.values.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type.toString().split('.').last),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() => _selectedType = value);
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Priority Selector
//   Widget _buildPrioritySelector() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Độ ưu tiên",
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: Priority.values.map((priority) {
//               final isSelected = _selectedPriority == priority;
//               final color = _getPriorityColor(priority);
//               return Expanded(
//                 child: GestureDetector(
//                   onTap: () => setState(() => _selectedPriority = priority),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     margin: const EdgeInsets.symmetric(horizontal: 4),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? color.withOpacity(0.2)
//                           : Colors.grey.shade100,
//                       border: Border.all(
//                         color: isSelected ? color : Colors.grey.shade300,
//                         width: isSelected ? 2 : 1,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       _getPriorityText(priority),
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
//                         color: isSelected ? color : Colors.grey.shade700,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Description Field
//   Widget _buildDescriptionField() {
//     return TextFormField(
//       controller: _descriptionController,
//       maxLines: 5,
//       minLines: 4,
//       validator: (value) {
//         if (value?.isEmpty ?? true) {
//           return "Vui lòng nhập mô tả sự cố";
//         }
//         if (value!.length < 10) {
//           return "Mô tả phải có ít nhất 10 ký tự";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         hintText: "Mô tả chi tiết về sự cố...",
//         hintStyle: TextStyle(color: Colors.grey.shade400),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColors.primary, width: 2),
//         ),
//         contentPadding: const EdgeInsets.all(14),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//     );
//   }
//
//   // Location Fields
//   Widget _buildLocationFields() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.location_on, color: AppColors.primary, size: 18),
//               const SizedBox(width: 8),
//               Text(
//                 "Tọa độ GPS",
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: _latitudeController,
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                     signed: true,
//                   ),
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) return "Nhập vĩ độ";
//                     if (double.tryParse(value!) == null) return "Không hợp lệ";
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     labelText: "Vĩ độ",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     contentPadding: const EdgeInsets.all(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: TextFormField(
//                   controller: _longitudeController,
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                     signed: true,
//                   ),
//                   validator: (value) {
//                     if (value?.isEmpty ?? true) return "Nhập kinh độ";
//                     if (double.tryParse(value!) == null) return "Không hợp lệ";
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     labelText: "Kinh độ",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     contentPadding: const EdgeInsets.all(12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton.icon(
//               onPressed: () {
//                 // TODO: Lấy vị trí GPS hiện tại
//               },
//               icon: const Icon(Icons.my_location, size: 18),
//               label: const Text("Lấy vị trí hiện tại"),
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Bin Info Card
//   Widget _buildBinInfoCard() {
//     final bin = widget.bin!;
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
//               const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   bin.addressName ?? "Vị trí chưa xác định",
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: _infoTile("Mã thùng", bin.qrCode ?? "N/A"),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _infoTile(
//                   "Loại rác",
//                   bin.type.toString().split('.').last,
//                   isTag: true,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _infoTile("Mức độ đầy", _getFillLevelText(bin.fillLevel)),
//         ],
//       ),
//     );
//   }
//
//   Widget _infoTile(String label, String value, {bool isTag = false}) {
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
//         isTag
//             ? Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           decoration: BoxDecoration(
//             color: AppColors.primary.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: AppColors.primary.withOpacity(0.3)),
//           ),
//           child: Text(
//             value,
//             style: const TextStyle(
//               color: AppColors.primary,
//               fontWeight: FontWeight.w600,
//               fontSize: 13,
//             ),
//           ),
//         )
//             : Text(
//           value,
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
//         ),
//       ],
//     );
//   }
//
//   String _getFillLevelText(FillLevel level) {
//     switch (level) {
//       case FillLevel.low:
//         return "Thấp";
//       case FillLevel.medium:
//         return "Vừa phải";
//       case FillLevel.high:
//         return "Cao";
//     }
//   }
//
//   // Image Upload Area
//   Widget _buildImageUploadArea() {
//     return GestureDetector(
//       onTap: _pickImage,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: AppColors.primary.withOpacity(0.3),
//             width: 2,
//             style: BorderStyle.solid,
//           ),
//         ),
//         child: _selectedImage != null
//             ? Column(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.file(
//                 _selectedImage!,
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 OutlinedButton.icon(
//                   onPressed: _pickImage,
//                   icon: const Icon(Icons.edit),
//                   label: const Text("Thay đổi ảnh"),
//                 ),
//                 const SizedBox(width: 12),
//                 OutlinedButton.icon(
//                   onPressed: () => setState(() => _selectedImage = null),
//                   icon: const Icon(Icons.close),
//                   label: const Text("Xóa"),
//                 ),
//               ],
//             ),
//           ],
//         )
//             : Column(
//           children: [
//             Icon(
//               Icons.camera_alt_outlined,
//               size: 48,
//               color: AppColors.primary,
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "Chụp ảnh minh chứng",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "Nhấn để chụp ảnh sự cố",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Submit Button
//   Widget _buildSubmitButton() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: ElevatedButton.icon(
//         onPressed: _isLoading ? null : _submitReport,
//         icon: _isLoading
//             ? const SizedBox(
//           height: 18,
//           width: 18,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation(Colors.white),
//           ),
//         )
//             : const Icon(Icons.send),
//         label: Text(_isLoading ? "Đang gửi..." : "GỬI BÁO CÁO"),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           disabledBackgroundColor: Colors.grey.shade400,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper Functions
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
//         return "Thấp";
//       case Priority.Medium:
//         return "Trung bình";
//       case Priority.High:
//         return "Cao";
//     }
//   }
// }