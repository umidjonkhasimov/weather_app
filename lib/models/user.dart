import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String email;
  final String id;
  final String? phoneNumber;
  final String? photoUrl;

  UserData({
    required this.email,
    required this.id,
    required this.phoneNumber,
    required this.photoUrl,
  });

  static UserData? fromFirebaseUser(User? user) {
    if (user == null) return null;
    return UserData(
      email: user.email ?? '',
      id: user.uid,
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL,
    );
  }
}
