import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenbin/bloc/user_setting/user_profile_state.dart';

import '../../repositories/app_repository.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final AppRepository _repo;

  UserProfileCubit(this._repo) : super(const UserProfileState());

  // chọn ảnh
  void imageChanged(Uint8List imageBytes) {
    emit(state.copyWith(imageBytes: imageBytes));
  }

  // reset ảnh (nếu cần)
  void clearImage() {
    emit(state.copyWith(imageBytes: null));
  }

  Future<void> updateProfile({
    required String name,
    Uint8List? imageBytes,
    String? currentPass,
    String? newPass,
  }) async {
    try {
      emit(state.copyWith(status: UserProfileStatus.loading));

      final updatedUser = await _repo.user.updateProfile(
        name: name,
        imageBytes: imageBytes,
        currentPassword: currentPass,
        newPassword: newPass,
      );

      await _repo.user.updateUserLocal(updatedUser);

      emit(state.copyWith(
          status: UserProfileStatus.success,
          message: 'Cập nhật thành công',
          user: updatedUser));
    } catch (e) {
      emit(state.copyWith(
        status: UserProfileStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
