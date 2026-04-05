import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enums.dart';
import '../models/user.dart';

class AppStorage {
  AppStorage._(); // Singleton

  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'GreenBinStorage',
      publicKey: 'GreenBinKey', // Tùy chọn
    ),
  );
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // // Lưu thông tin người dùng
  // static Future<void> saveUserAuthentication(User user) async {
  //   try {
  //     if (user.token == null) throw Exception('Token is null');
  //     if (user.id == null) throw Exception('User ID is null');
  //
  //     await Future.wait([
  //       _storage.write(key: 'token', value: user.token!),
  //       _storage.write(key: 'id', value: user.id.toString()),
  //       _storage.write(key: 'name', value: user.name),
  //       _storage.write(key: 'email', value: user.email),
  //       _storage.write(key: 'role', value: user.role.name),
  //       _storage.write(key: 'isSocialLogin', value: user.isSocialLogin.toString()),
  //       _storage.write(key: 'points', value: user.points.toString()),
  //       _storage.write(key: 'imageUrl', value: user.imageUrl ?? ''),
  //       _storage.write(key: 'token', value: user.token ?? ''),
  //       _storage.write(key: 'fcmToken', value: user.fcmToken ?? ''),
  //     ]);
  //
  //     await _sharedPreferences.setBool('isLogin', true);
  //   } catch (e) {
  //     throw Exception('Failed to save user: $e');
  //   }
  // }

  static Future<void> saveUser(User user) async {
    try {
      // if (user.token == null) throw Exception('Token is null');
      if (user.id == null) throw Exception('User ID is null');

      if (kIsWeb) {
        // 👉 Web dùng SharedPreferences
        await _sharedPreferences.setString('id', user.id.toString());
        // await _sharedPreferences.setString('token', user.token!);
        await _sharedPreferences.setString('name', user.name);
        await _sharedPreferences.setString('email', user.email);
        await _sharedPreferences.setString('role', user.role.name);
        await _sharedPreferences.setString(
            'isSocialLogin', user.isSocialLogin.toString());
        await _sharedPreferences.setString('points', user.points.toString());
        await _sharedPreferences.setString('imageUrl', user.imageUrl ?? '');
        await _sharedPreferences.setString(
            'publicImageUrl', user.publicImageUrl ?? '');
        await _sharedPreferences.setString('fcmToken', user.fcmToken ?? '');
      } else {
        await Future.wait([
          // _storage.write(key: 'token', value: user.token!),
          _storage.write(key: 'id', value: user.id.toString()),
          _storage.write(key: 'name', value: user.name),
          _storage.write(key: 'email', value: user.email),
          _storage.write(key: 'role', value: user.role.name),
          _storage.write(
              key: 'isSocialLogin', value: user.isSocialLogin.toString()),
          _storage.write(key: 'points', value: user.points.toString()),
          _storage.write(key: 'imageUrl', value: user.imageUrl ?? ''),
          _storage.write(
              key: 'publicImageUrl', value: user.publicImageUrl ?? ''),
          _storage.write(key: 'fcmToken', value: user.fcmToken ?? ''),
        ]);
      }

      await _sharedPreferences.setBool('isLogin', true);
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  // Cập nhật thông tin (ví dụ sau khi sửa profile)
  static Future<void> updateUser(User user) async {
    try {
      if (kIsWeb) {
        await _sharedPreferences.setString('name', user.name);
        await _sharedPreferences.setString(
            'isSocialLogin', user.isSocialLogin.toString());
        await _sharedPreferences.setString('points', user.points.toString());
        await _sharedPreferences.setString('imageUrl', user.imageUrl ?? '');
        await _sharedPreferences.setString(
            'publicImageUrl', user.publicImageUrl ?? '');
        await _sharedPreferences.setString('fcmToken', user.fcmToken ?? '');
      } else {
        await Future.wait([
          _storage.write(key: 'name', value: user.name),
          _storage.write(key: 'points', value: user.points.toString()),
          _storage.write(key: 'imageUrl', value: user.imageUrl ?? ''),
          _storage.write(
              key: 'publicImageUrl', value: user.publicImageUrl ?? ''),
          _storage.write(key: 'fcmToken', value: user.fcmToken ?? ''),
          _storage.write(
              key: 'isSocialLogin', value: user.isSocialLogin.toString()),
        ]);
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Lấy đối tượng User hoàn chỉnh
  // static Future<User?> getUser() async {
  //   try {
  //     final token = await _storage.read(key: 'token');
  //     final idStr = await _storage.read(key: 'id');
  //     final name = await _storage.read(key: 'name');
  //     final email = await _storage.read(key: 'email');
  //     final roleStr = await _storage.read(key: 'role');
  //     final pointsStr = await _storage.read(key: 'points');
  //     final imageUrl = await _storage.read(key: 'imageUrl');
  //     final fcmToken = await _storage.read(key: 'fcmToken');
  //     final isSocialLogin = await _storage.read(key: 'isSocialLogin');
  //
  //     if (idStr != null && email != null && name != null) {
  //       return User(
  //         id: int.tryParse(idStr),
  //         email: email,
  //         name: name,
  //         token: token,
  //         role: UserRoleExtension.fromJson(roleStr ?? 'resident'),
  //         points: int.tryParse(pointsStr ?? '0') ?? 0,
  //         imageUrl: imageUrl?.isEmpty == true ? null : imageUrl,
  //         fcmToken: fcmToken?.isEmpty == true ? null : fcmToken,
  //         passwordHash: null,
  //         isSocialLogin: isSocialLogin == 'true',
  //       );
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception('Loi get user:${e.toString()}');
  //   }
  // }

  static Future<User?> getUser() async {
    try {
      String? token, idStr, name, email, roleStr;
      String? pointsStr, imageUrl, publicImageUrl, fcmToken, isSocialLogin;

      if (kIsWeb) {
        token = _sharedPreferences.getString('token');
        idStr = _sharedPreferences.getString('id');
        name = _sharedPreferences.getString('name');
        email = _sharedPreferences.getString('email');
        roleStr = _sharedPreferences.getString('role');
        pointsStr = _sharedPreferences.getString('points');
        imageUrl = _sharedPreferences.getString('imageUrl');
        publicImageUrl = _sharedPreferences.getString('publicImageUrl');
        fcmToken = _sharedPreferences.getString('fcmToken');
        isSocialLogin = _sharedPreferences.getString('isSocialLogin');
      } else {
        token = await _storage.read(key: 'token');
        idStr = await _storage.read(key: 'id');
        name = await _storage.read(key: 'name');
        email = await _storage.read(key: 'email');
        roleStr = await _storage.read(key: 'role');
        pointsStr = await _storage.read(key: 'points');
        imageUrl = await _storage.read(key: 'imageUrl');
        publicImageUrl = await _storage.read(key: 'publicImageUrl');
        fcmToken = await _storage.read(key: 'fcmToken');
        isSocialLogin = await _storage.read(key: 'isSocialLogin');
      }

      /// 🔥 check thêm token (rất quan trọng)
      if (token == null || idStr == null || email == null || name == null) {
        return null;
      }

      return User(
        id: int.tryParse(idStr),
        email: email,
        name: name,
        token: token,
        role: UserRoleExtension.fromJson(roleStr ?? 'resident'),
        points: int.tryParse(pointsStr ?? '0') ?? 0,
        imageUrl: imageUrl?.isEmpty == true ? null : imageUrl,
        publicImageUrl: publicImageUrl?.isEmpty == true ? null : publicImageUrl,
        fcmToken: fcmToken?.isEmpty == true ? null : fcmToken,
        passwordHash: null,
        isSocialLogin: isSocialLogin == 'false' ? false : true,
      );
    } catch (e) {
      /// ❗ KHÔNG throw nữa (tránh crash GoRouter)
      print('GET USER ERROR: $e');
      return null;
    }
  }

  // // Xóa sạch dữ liệu (Logout)
  // static Future<void> clearAll() async {
  //   await _storage.deleteAll();
  //   await _sharedPreferences.clear();
  // }
  static Future<void> clearAll() async {
    if (!kIsWeb) {
      await _storage.deleteAll();
    }
    await _sharedPreferences.clear();
  }

  // // Các hàm lấy nhanh giá trị lẻ
  // static Future<String?> getToken() async => await _storage.read(key: 'token');
  //
  // static Future<String?> getFcmToken() async =>
  //     await _storage.read(key: 'fcmToken');
  //
  // static Future<bool> isLogin() async =>
  //     _sharedPreferences.getBool('isLogin') ?? false;
  //
  // static Future<bool> isSocialLogin() async {
  //   final result = await _storage.read(key: 'isSocialLogin');
  //   return result == 'true';
  // }

  static Future<void> saveToken(String token) async {
    if (kIsWeb) {
      await _sharedPreferences.setString('token', token);
    } else {
      await _storage.write(key: 'token', value: token);
    }
  }

  static Future<String?> getToken() async {
    if (kIsWeb) return _sharedPreferences.getString('token');
    return await _storage.read(key: 'token');
  }

  static Future<String?> getUserRole() async {
    if (kIsWeb) return _sharedPreferences.getString('role');
    return await _storage.read(key: 'role');
  }

  static Future<String?> getFcmToken() async {
    if (kIsWeb) return _sharedPreferences.getString('fcmToken');
    return await _storage.read(key: 'fcmToken');
  }
}
