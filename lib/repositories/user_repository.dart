import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:greenbin/services/app_secure_storage.dart';

import '../models/user.dart';
import '../services/api/app_api.dart';
import '../configs/exception.dart';
import 'app_event_bus.dart';

abstract class IUserRepository {
  Future<User?> getCurrentUser({bool forceRefresh = false});

  Future<User> updateProfile({
    required String name,
    Uint8List? imageBytes,
    String? currentPassword,
    String? newPassword,
  });

  Future<void> updateUserLocal(User user);

  Future<void> clearUser();

  Future<void> logOut();
}

class UserRepository implements IUserRepository {
  final _api = AppApi().user;

  @override
  Future<User?> getCurrentUser({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final localUser = await AppStorage.getUser();
        return localUser;
      }

      final remoteUser = await _api.getCurrentUser();
      return remoteUser;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }

  @override
  Future<void> clearUser() async {
    await AppStorage.clearAll();
  }

  @override
  Future<User> updateProfile({
    required String name,
    Uint8List? imageBytes,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      // 1. Gọi API
      final updatedUser = await _api.updateUserProfile(
        name: name,
        currentPassword: currentPassword,
        newPassword: newPassword,
        imageBytes: imageBytes,
      );

      await AppStorage.saveUser(updatedUser);

      return updatedUser;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi cập nhật thông tin");
    }
  }

  @override
  Future<void> updateUserLocal(User user) async {
    try {
      await AppStorage.saveUser(user);
      AppEventBus().emit(UserUpdatedEvent(user));
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi cập nhật thông tin");
    }
  }

  @override
  Future<void> logOut() async{
    try{
      await AppStorage.clearAll();
    }on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi cập nhật thông tin");
    }
  }
}
