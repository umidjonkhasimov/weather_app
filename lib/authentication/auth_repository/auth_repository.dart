import '../../models/result_model.dart';
import '../../models/user.dart';
import 'auth_status.dart';

abstract class AuthRepository {
  UserData? get currentUser;

  Stream<AuthenticationStatus> get authState;

  Future<ResultModel> signIn(String email, String password);

  Future<ResultModel> signUp(String email, String password);

  Future<void> signOut();

  Future<void> setProfilePic(String imagePath);
}
