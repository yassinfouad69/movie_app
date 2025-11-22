import '../datasources/local_storage_service.dart';
import '../models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final LocalStorageService _localStorageService;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._localStorageService)
      : _googleSignIn = GoogleSignIn();

  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: email.split('@')[0],
      email: email,
      avatarPath: 'assets/avatars/avatar1.png',
    );

    await _localStorageService.saveUser(user);
    return user;
  }

  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String avatarPath,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      avatarPath: avatarPath,
    );

    await _localStorageService.saveUser(user);
    return user;
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final user = User(
          id: googleUser.id,
          name: googleUser.displayName ?? '',
          email: googleUser.email,
          avatarPath: 'assets/avatars/avatar1.png',
        );

        await _localStorageService.saveUser(user);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> updateProfile({
    required String name,
    String? phoneNumber,
    required String avatarPath,
  }) async {
    try {
      final currentUser = _localStorageService.getUser();
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          name: name,
          phoneNumber: phoneNumber,
          avatarPath: avatarPath,
        );
        return await _localStorageService.saveUser(updatedUser);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    return await _localStorageService.logout();
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _localStorageService.logout();
  }

  User? getCurrentUser() {
    return _localStorageService.getUser();
  }

  bool isLoggedIn() {
    return _localStorageService.isLoggedIn();
  }
}
