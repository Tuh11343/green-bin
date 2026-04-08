import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../configs/exception.dart';
import '../models/user.dart';
import '../services/api/app_api.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../services/app_secure_storage.dart';

abstract class IAuthRepository {
  Future<User?> signInWithGoogle();

  Future<User> signIn({required String email, required String password});

  Future<User> register(
      {required String email, required String password, required String name});

  Future<void> forgotPassword(String email);

  Future<void> verifyOTP({required String email, required String otp});

  Future<void> resetPassword(
      {required String email,
      required String otp,
      required String newPassword});
}

class AuthRepository implements IAuthRepository {
  final _api = AppApi().auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "822885468920-quuokp2d571bca8ruo33vfdfjn9ud09u.apps.googleusercontent.com",
    scopes: ['email'],
  );
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _api.login(email: email, password: password);

      await AppStorage.saveUser(user);
      await AppStorage.saveToken(user.token!);

      return user;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await _api.register(
        email: email,
        password: password,
        name: name,
      );

      await AppStorage.saveUser(user);
      await AppStorage.saveToken(user.token!);

      return user;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _firebaseAuth.signInWithCredential(credential);

      final firebaseIdToken = await userCredential.user?.getIdToken();

      if (firebaseIdToken == null) {
        throw UnknownException("Không thể lấy Firebase ID Token");
      }

      final user =
      await _api.googleSignIn(firebaseIdToken: firebaseIdToken);

      debugPrint("Token nguồi dùng:${user.token}");

      await AppStorage.saveUser(user);
      await AppStorage.saveToken(user.token!);


      return user;
    } on AppException {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi không xác định ở repository");
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    return _api.forgotPassword(email: email);
  }

  @override
  Future<void> verifyOTP({
    required String email,
    required String otp,
  }) async {
    return _api.verifyOTP(email: email, otp: otp);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    return _api.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
  }

  Future<void> logout() async {
    await AppStorage.clearAll();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

}
