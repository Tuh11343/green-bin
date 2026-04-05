import 'package:equatable/equatable.dart';
import '../../models/user.dart';

enum AuthStatus { initial, loading, success, failure }

enum AuthAction {
  login,
  register,
  google,
  forgotPassword,
  verifyOtp,
  resetPassword,
  updateUser,
  logout,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthAction? action;
  final User? user;
  final String? message;

  const AuthState({
    this.status = AuthStatus.initial,
    this.action,
    this.user,
    this.message,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthAction? action,
    User? user,
    String? message,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      action: action ?? this.action,
      user: user ?? this.user,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, action, user, message];
}