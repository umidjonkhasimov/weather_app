import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/models/user.dart';

import '../../authentication/auth_repository/auth_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(AuthRepository authRepository) : super(ProfileStateLoading()) {
    on<ProfileEventGetProfileDetails>(
      (event, emit) {
        final user = authRepository.currentUser;
        emit(ProfileStateDetailsReady(userData: user!));
      },
    );

    on<ProfileEventChangeProfileImage>(
      (event, emit) async {
        emit(ProfileStateDetailsReady(
            userData: authRepository.currentUser!, isUploading: true));
        await authRepository.setProfilePic(event.imagePath);
        emit(ProfileStateDetailsReady(userData: authRepository.currentUser!));
      },
    );
  }
}
