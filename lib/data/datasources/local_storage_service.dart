import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _onboardingKey = 'onboarding_completed';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  Future<bool> saveUser(User user) async {
    try {
      final userJson = json.encode(user.toJson());
      await _prefs.setString(_userKey, userJson);
      await _prefs.setBool(_isLoggedInKey, true);
      return true;
    } catch (e) {
      return false;
    }
  }

  User? getUser() {
    try {
      final userJson = _prefs.getString(_userKey);
      if (userJson != null) {
        return User.fromJson(json.decode(userJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<bool> logout() async {
    try {
      await _prefs.remove(_userKey);
      await _prefs.setBool(_isLoggedInKey, false);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setOnboardingCompleted() async {
    return await _prefs.setBool(_onboardingKey, true);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  Future<bool> addToWatchlist(int movieId) async {
    try {
      final user = getUser();
      if (user != null) {
        final updatedWatchlist = List<int>.from(user.watchlist);
        if (!updatedWatchlist.contains(movieId)) {
          updatedWatchlist.add(movieId);
          final updatedUser = user.copyWith(watchlist: updatedWatchlist);
          return await saveUser(updatedUser);
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromWatchlist(int movieId) async {
    try {
      final user = getUser();
      if (user != null) {
        final updatedWatchlist = List<int>.from(user.watchlist);
        updatedWatchlist.remove(movieId);
        final updatedUser = user.copyWith(watchlist: updatedWatchlist);
        return await saveUser(updatedUser);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addToHistory(int movieId) async {
    try {
      final user = getUser();
      if (user != null) {
        final updatedHistory = List<int>.from(user.history);
        if (updatedHistory.contains(movieId)) {
          updatedHistory.remove(movieId);
        }
        updatedHistory.insert(0, movieId);
        final updatedUser = user.copyWith(history: updatedHistory);
        return await saveUser(updatedUser);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool isInWatchlist(int movieId) {
    final user = getUser();
    return user?.watchlist.contains(movieId) ?? false;
  }
}
