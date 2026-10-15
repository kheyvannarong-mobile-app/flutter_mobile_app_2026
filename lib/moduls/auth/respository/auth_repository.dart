import 'package:flutter_mobile_app_2026/core/remote/models/api_base_response.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/auth/forgot_password_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/User.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/register/Register_request.dart';

abstract class AuthRepository {
  Future<bool> login({required String username, required String password});
  Future<bool> register(RegisterRequest request);
  Future<bool> logout();
  Future<ApiBaseResponse> requestOtp(String phoneNumber);
  Future<ApiBaseResponse> verifyOtp(String phoneNumber, String otp);
  Future<ApiBaseResponse> finishPasswordReset({
    required String phoneNumber,
    required String oldPassword,
    required String password,
    required String confirmPassword,
  });
  Future<bool> updateProfile(User user);
  Future<bool> changePassword(ChangePasswordRequest req);
}