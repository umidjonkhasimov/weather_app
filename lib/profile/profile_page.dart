import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weather_app/authentication/auth_repository/firebase_auth_repository.dart';

import 'bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(FirebaseAuthRepository()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView({super.key});

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileEventGetProfileDetails());
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileStateDetailsReady) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: state.isUploading
                                ? const Padding(
                                    padding: EdgeInsets.all(56),
                                    child: CircularProgressIndicator(),
                                  )
                                : CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surfaceVariant,
                                    foregroundImage:
                                        NetworkImage(state.userData.photoUrl ?? ''),
                                  ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                              onPressed: () async {
                                final imagePicker = ImagePicker();
                                final image = await imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                if (image != null) {
                                  if (context.mounted) {
                                    context.read<ProfileBloc>().add(
                                          ProfileEventChangeProfileImage(
                                            imagePath: image.path,
                                          ),
                                        );
                                  }
                                }
                              },
                              icon: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  Icons.edit_rounded,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Email address:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    state.userData.email,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your phone number',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    state.userData.phoneNumber ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (state is ProfileStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}
