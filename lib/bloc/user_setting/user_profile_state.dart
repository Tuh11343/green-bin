import 'dart:io';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import '../../models/user.dart';

enum UserProfileStatus { initial, loading, success, failure }

class UserProfileState extends Equatable {
  final Uint8List? imageBytes;
  final User? user;
  final UserProfileStatus status;
  final String? message;

  const UserProfileState({
    this.imageBytes,
    this.status = UserProfileStatus.initial,
    this.user,
    this.message,
  });

  UserProfileState copyWith({
    Uint8List? imageBytes,
    UserProfileStatus? status,
    String? message,
    User? user,
  }) {
    return UserProfileState(
      imageBytes: imageBytes ?? this.imageBytes,
      status: status ?? this.status,
      user: user ?? this.user,
      message: message,
    );
  }

  @override
  List<Object?> get props => [imageBytes, status, user, message];
}
