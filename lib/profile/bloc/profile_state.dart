part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileStateLoading extends ProfileState {}

final class ProfileStateDetailsReady extends ProfileState {
  final UserData userData;
  final bool isUploading;

  ProfileStateDetailsReady({required this.userData, this.isUploading = false});
}
