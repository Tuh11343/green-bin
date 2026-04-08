import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import '../../repositories/app_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AppRepository _repository;

  AuthCubit(this._repository) : super(const AuthState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.login,
      clearMessage: true,
    ));

    try {
      final user = await _repository.auth.signIn(
        email: email,
        password: password,
      );

      await _repository.user.updateUserLocal(user);

      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.login,
        user: user,
        message: 'Đăng nhập thành công',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.login,
        message: e.toString(),
      ));
    }
  }

  Future<void> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.register,
      clearMessage: true,
    ));

    try {
      final user = await _repository.auth.register(
        email: email,
        password: password,
        name: name,
      );

      await _repository.user.updateUserLocal(user);

      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.register,
        user: user,
        message: 'Đăng ký thành công',
      ));
    } catch (e) {
      debugPrint('Emit loi');
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.register,
        message: e.toString(),
      ));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.login,
      clearMessage: true,
    ));

    try {
      final user = await _repository.auth.signInWithGoogle();

      if (user == null) {
        emit(state.copyWith(
          status: AuthStatus.initial,
          action: AuthAction.login,
        ));
        return;
      }

      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.login,
        user: user,
        message: 'Đăng nhập Google thành công',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.login,
        message: e.toString(),
      ));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.forgotPassword,
      clearMessage: true,
    ));

    try {
      await _repository.auth.forgotPassword(email);

      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.forgotPassword,
        message: 'Mã OTP đã được gửi',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.forgotPassword,
        message: e.toString(),
      ));
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.verifyOtp,
      clearMessage: true,
    ));

    try {
      await _repository.auth.verifyOTP(email: email, otp: otp);

      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.verifyOtp,
        message: 'Xác thực OTP thành công'
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.verifyOtp,
        message: e.toString(),
      ));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.resetPassword,
      clearMessage: true,
    ));

    try {
      await _repository.auth.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );

      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.resetPassword,
        message: 'Đổi mật khẩu thành công',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.resetPassword,
        message: e.toString(),
      ));
    }
  }

  Future<void> logout() async {
    await _repository.auth.logout();

    emit(const AuthState(
      status: AuthStatus.initial,
      action: AuthAction.logout,
    ));
  }

  Future<void> updateUser(User updatedUser) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      action: AuthAction.updateUser,
    ));

    try {
      await _repository.user.updateUserLocal(updatedUser);

      emit(state.copyWith(
        status: AuthStatus.success,
        action: AuthAction.updateUser,
        user: updatedUser,
        message: 'Cập nhật thành công',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        action: AuthAction.updateUser,
        message: e.toString(),
      ));
    }
  }


}