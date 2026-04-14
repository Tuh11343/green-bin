import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:greenbin/services/http/dio_client.dart';

import '../../configs/api_endpoint.dart';
import '../../configs/api_error_handle.dart';
import '../../models/user.dart';
import '../../utils/api_parser.dart';

class UserApi {
  final DioClient _dioClient = DioClient();

  Future<User> getCurrentUser() async {
    try {
      final res = await _dioClient.get(ApiEndpoints.getCurrentUser);
      final Map<String, dynamic> actualData = res.data['data'];
      // lấy token từ bên ngoài vào bên trong map của user
      actualData['user']['token'] = actualData['token'];
      return ApiParser.parseData(
          response: res, fromJson: User.fromJson, dataKey: 'user');
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<User> getUserById(String id) async {
    try {
      final res = await _dioClient.get(
        '${ApiEndpoints.getUserById}/$id',
      );
      return ApiParser.parseData(
          response: res, fromJson: User.fromJson, dataKey: 'user');
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getAllUsers,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> listData = response.data!['data'];

        return listData.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Get All Users failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<User> updateUserProfile({
    required String name,
    String? currentPassword,
    String? newPassword,
    Uint8List? imageBytes,
  }) async {
    try {

      // Tính ext bên ngoài fromMap cho gọn
      final String? imageExt =
          imageBytes != null ? _detectMimeType(imageBytes) : null;

      final formData = FormData.fromMap({
        'name': name,
        if (currentPassword != null && currentPassword.isNotEmpty)
          'currentPassword': currentPassword,
        if (newPassword != null && newPassword.isNotEmpty)
          'newPassword': newPassword,
        if (imageBytes != null && imageExt != null)
          'image': MultipartFile.fromBytes(
            imageBytes,
            filename:
                'avatar_${DateTime.now().millisecondsSinceEpoch}.$imageExt',
            contentType: DioMediaType('image', imageExt),
          ),
      });

      final res = await _dioClient.patch(
        ApiEndpoints.updateUserProfile,
        data: formData,
      );
      final Map<String, dynamic> actualData = res.data['data'];
      // Đút token từ bên ngoài vào bên trong map của user
      // actualData['user']['token'] = actualData['token'];
      return ApiParser.parseData(
          response: res, fromJson: User.fromJson, dataKey: 'user');
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  String _detectMimeType(Uint8List bytes) {
    if (bytes[0] == 0x89 && bytes[1] == 0x50) return 'png';
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) return 'jpeg';
    return 'jpeg';
  }
}
