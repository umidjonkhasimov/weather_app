import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/result_model.dart';
import '../../models/user.dart';
import '../exceptions/firebase_auth_exceptions.dart';
import 'auth_repository.dart';
import 'auth_status.dart';

class FirebaseAuthRepository extends AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  UserData? get currentUser => UserData.fromFirebaseUser(_firebaseAuth.currentUser);

  @override
  Stream<AuthenticationStatus> get authState async* {
    yield* _firebaseAuth.authStateChanges().map(
      (user) {
        if (user != null) {
          return AuthenticationStatus.authenticated;
        }
        return AuthenticationStatus.unAuthenticated;
      },
    );
  }

  @override
  Future<ResultModel> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return ResultSuccess(data: Object);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return ResultFailure(InvalidEmailException());
      } else if (e.code == 'user-disabled') {
        return ResultFailure(UserDisabledException());
      } else if (e.code == 'user-not-found') {
        return ResultFailure(UserNotFoundException());
      } else if (e.code == 'wrong-password') {
        return ResultFailure(WrongPasswordException());
      } else if (e.code == 'invalid-credential') {
        return ResultFailure(InvalidCredentialsException());
      } else {
        return ResultFailure(GenericException());
      }
    } catch (e) {
      return ResultFailure(GenericException());
    }
  }

  @override
  Future<ResultModel> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return ResultSuccess(data: Object);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return ResultFailure(InvalidEmailException());
      } else if (e.code == 'operation-not-allowed') {
        return ResultFailure(OperationNotAllowedException());
      } else if (e.code == 'email-already-in-use') {
        return ResultFailure(EmailAlreadyInUse());
      } else if (e.code == 'weak-password') {
        return ResultFailure(WeakPassword());
      } else {
        return ResultFailure(GenericException());
      }
    } catch (e) {
      return ResultFailure(GenericException());
    }
  }

  @override
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  @override
  Future<void> setProfilePic(String imagePath) async {
    try {
      final taskSnapshot = await _firebaseStorage
          .ref()
          .child('profile_pics/${currentUser!.id}.jpg')
          .putFile(
            File(imagePath),
          );
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      await _firebaseAuth.currentUser?.updatePhotoURL(imageUrl);
    } on FirebaseException catch (e) {
      print('GGG: ${e.code}');
    }
  }
}
