import 'dart:convert';
import 'package:flutter_mobile_app_2026/core/remote/models/login/User.dart';
import 'package:get_storage/get_storage.dart';

class UserAccessToken {
  UserAccessToken._();

  static const String _accessTokenKey = "ACCESS_TOKEN";
  static const String _refreshTokenKey = "REFRESH_TOKEN";
  static const String _userKey = "CURRENT_USER";

  static final GetStorage _storage = GetStorage();

  /// Set the JWT Access Token
  static void setAccess(String token) {
    _storage.write(_accessTokenKey, token);
  }

  /// Set the Refresh Token
  static void setRefreshAccess(String refreshToken) {
    _storage.write(_refreshTokenKey, refreshToken);
  }

  /// Get the Access Token
  static String getAccessToken() {
    return _storage.read<String>(_accessTokenKey) ?? "";
  }

  /// Get the Refresh Token
  static String getRefreshToken() {
    return _storage.read<String>(_refreshTokenKey) ?? "";
  }

  /// Store the serialized User object
  static void setUser(User user) {
    _storage.write(_userKey, jsonEncode(user.toJson()));
  }

  /// Retrieve the current logged-in User
  static User? getUser() {
    final String? userStr = _storage.read<String>(_userKey);
    if (userStr != null && userStr.isNotEmpty) {
      try {
        return User.fromJson(jsonDecode(userStr));
      } catch (_) {}
    }
    return null;
  }

  /// Check if the user is authenticated
  static bool isLoggedIn() {
    return getAccessToken().isNotEmpty;
  }

  /// Check if the current user has ROLE_ADMIN
  static bool isAdmin() {
    final user = getUser();
    if (user != null && user.roles != null) {
      return user.roles!.any((r) => r.name == 'ROLE_ADMIN' || r.name == 'ADMIN');
    }
    return false;
  }

  /// Clear all stored credentials and user session
  static void remove() {
    _storage.remove(_accessTokenKey);
    _storage.remove(_refreshTokenKey);
    _storage.remove(_userKey);
  }
}
