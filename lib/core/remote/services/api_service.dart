import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_response.dart';

abstract class ApiService {
  Future<LoginResponse> login(LoginRequest request);
}