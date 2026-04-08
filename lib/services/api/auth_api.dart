import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:greenbin/utils/api_parser.dart';

import '../../configs/api_endpoint.dart';
import '../../configs/api_error_handle.dart';
import '../../configs/exception.dart';
import '../../models/user.dart';
import '../http/dio_client.dart';

class AuthApi {
  final DioClient _dioClient;

  AuthApi(this._dioClient);

  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.login,
        data: {
          'identifier': email,
          'password': password,
        },
      );
      final Map<String, dynamic> actualData = res.data['data'];
      // Đút token từ bên ngoài vào bên trong map của user
      actualData['user']['token'] = actualData['token'];

      return ApiParser.parseData(
          response: res, fromJson: User.fromJson, dataKey: 'user');
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      final Map<String, dynamic> actualData = res.data['data'];
      // Đút token từ bên ngoài vào bên trong map của user
      actualData['user']['token'] = actualData['token'];
      return ApiParser.parseData(
          response: res, fromJson: User.fromJson, dataKey: 'user');
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<User> googleSignIn({
    required String firebaseIdToken,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.googleSignIn,
        data: {'firebaseIdToken': firebaseIdToken},
      );
      debugPrint('user data:${res}');
      final Map<String, dynamic> actualData = res.data['data'];
      // Đút token từ bên ngoài vào bên trong map của user
      actualData['user']['token'] = actualData['token'];


      return ApiParser.parseData(
          response: res, fromJson: User.fromJson, dataKey: 'user');
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _dioClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      await _dioClient.post(
        ApiEndpoints.verifyOtp,
        data: {'email': email, 'otp': otp},
      );
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _dioClient.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
