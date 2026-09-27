import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_response.dart';

import '../models/register/Register_request.dart';

abstract class ApiService {
  Future<LoginResponse> login(LoginRequest request);
  Future<bool> register(RegisterRequest request);
}