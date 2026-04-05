import 'package:equatable/equatable.dart';
import '../../models/user.dart';

enum UserStatus { initial, loading, success, failure ,updating}

class UserState extends Equatable {
  final UserStatus status;
  final User? user;
  final String? token;

  final String? message;

  const UserState({
    this.status = UserStatus.initial,
    this.token,
    this.user,
    this.message,
  });

  UserState copyWith({
    UserStatus? status,
    User? user,
    String? message,
    String? token,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message,
      token: token,
    );
  }

  @override
  List<Object?> get props => [status, user, message,token];
}