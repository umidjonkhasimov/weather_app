part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileEventGetProfileDetails extends ProfileEvent {}

final class ProfileEventChangeProfileImage extends ProfileEvent {
  final String imagePath;

  ProfileEventChangeProfileImage({required this.imagePath});
}
