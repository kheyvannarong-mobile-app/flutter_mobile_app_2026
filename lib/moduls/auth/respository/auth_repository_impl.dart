import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';

import '../../../core/remote/models/register/Register_request.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  AuthRepositoryImpl({required this.apiService});
  @override
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    var response = await apiService.login(
      LoginRequest(phoneNumber: username, password: password),
    );
    if (response.accessToken != null) {
      return true;
    } else {
      return false;
    }
  }
  @override
  Future<bool> register(RegisterRequest request) async {
    return await apiService.register(request);
  }
}
