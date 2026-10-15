import 'package:flutter_mobile_app_2026/core/data/local/user_access_token.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/api_base_response.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/auth/forgot_password_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/User.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/register/Register_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  AuthRepositoryImpl({required this.apiService});

  @override
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final response = await apiService.login(
      LoginRequest(phoneNumber: username, password: password),
    );
    return response.accessToken != null && response.accessToken!.isNotEmpty;
  }

  @override
  Future<bool> register(RegisterRequest request) async {
    return await apiService.register(request);
  }

  @override
  Future<bool> logout() async {
    final user = UserAccessToken.getUser();
    return await apiService.logout(user?.id);
  }

  @override
  Future<ApiBaseResponse> requestOtp(String phoneNumber) async {
    return await apiService.forgotPassword(phoneNumber, "MOBILE-DEVICE-01");
  }

  @override
  Future<ApiBaseResponse> verifyOtp(String phoneNumber, String otp) async {
    return await apiService.forgotPasswordVerify(phoneNumber, "MOBILE-DEVICE-01", otp);
  }

  @override
  Future<ApiBaseResponse> finishPasswordReset({
    required String phoneNumber,
    required String oldPassword,
    required String password,
    required String confirmPassword,
  }) async {
    return await apiService.forgotPasswordFinish(
      phoneNumber,
      oldPassword,
      password,
      confirmPassword,
    );
  }

  @override
  Future<bool> updateProfile(User user) async {
    return await apiService.updateUserProfile(user);
  }

  @override
  Future<bool> changePassword(ChangePasswordRequest req) async {
    return await apiService.changePassword(req);
  }
}
