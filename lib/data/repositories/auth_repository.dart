import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../datasources/local_storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final LocalStorageService _localStorageService;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._localStorageService)
      : _firebaseAuth = firebase_auth.FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final firebaseUser = userCredential.user!;
        final user = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? email.split('@')[0],
          email: firebaseUser.email ?? email,
          avatarPath: 'assets/avatars/avatar1.png',
        );

        await _localStorageService.saveUser(user);
        return user;
      }
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<User?> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String avatarPath,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final firebaseUser = userCredential.user!;

        // Update display name
        await firebaseUser.updateDisplayName(name);

        // Send email verification
        await firebaseUser.sendEmailVerification();

        final user = User(
          id: firebaseUser.uid,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          avatarPath: avatarPath,
        );

        await _localStorageService.saveUser(user);
        return user;
      }
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _firebaseAuth.signInWithCredential(credential);

        if (userCredential.user != null) {
          final firebaseUser = userCredential.user!;
          final user = User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? googleUser.displayName ?? '',
            email: firebaseUser.email ?? googleUser.email,
            avatarPath: 'assets/avatars/avatar1.png',
          );

          await _localStorageService.saveUser(user);
          return user;
        }
      }
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<bool> updateProfile({
    required String name,
    String? phoneNumber,
    required String avatarPath,
  }) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(name);

        final currentUser = _localStorageService.getUser();
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            name: name,
            phoneNumber: phoneNumber,
            avatarPath: avatarPath,
          );
          return await _localStorageService.saveUser(updatedUser);
        }
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.delete();
        await _localStorageService.logout();
        return true;
      }
      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _localStorageService.logout();
  }

  User? getCurrentUser() {
    return _localStorageService.getUser();
  }

  bool isLoggedIn() {
    return _localStorageService.isLoggedIn();
  }

  // Helper method to handle Firebase Auth exceptions
  Exception _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email.');
      case 'wrong-password':
        return Exception('Wrong password provided.');
      case 'email-already-in-use':
        return Exception('An account already exists with this email.');
      case 'weak-password':
        return Exception('Password is too weak. Use at least 6 characters.');
      case 'invalid-email':
        return Exception('Email address is not valid.');
      case 'user-disabled':
        return Exception('This account has been disabled.');
      case 'too-many-requests':
        return Exception('Too many requests. Please try again later.');
      case 'operation-not-allowed':
        return Exception('This operation is not allowed.');
      case 'requires-recent-login':
        return Exception('Please login again to perform this action.');
      default:
        return Exception('Authentication error: ${e.message}');
    }
  }
}
