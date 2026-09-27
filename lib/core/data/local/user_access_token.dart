import 'package:get_storage/get_storage.dart';

class UserAccessToken {
  UserAccessToken._();
  static const String _accessToken = "ACCESS_TOKEN";
  static const String _refreshToken = "REFRESH_TOKEN";
  static final _storage = GetStorage();

  static setAccess(String token) {
    _storage.write(_accessToken, token);
  }

  static setRefreshAccess(String refreshToken) {
    _storage.write(_accessToken, refreshToken);
  }

  static getAccessToken() => _storage.read(_accessToken) ?? "";
  static getRefreshToken() => _storage.read(_refreshToken) ?? "";
  static remove() {
    _storage.remove(_accessToken);
    _storage.remove(_refreshToken);
  }
}
