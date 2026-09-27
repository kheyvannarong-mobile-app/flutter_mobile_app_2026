import 'dart:convert';
import 'package:flutter_mobile_app_2026/core/data/local/user_access_token.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_response.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'package:http/http.dart' as http;

import '../../../constants/constant_uri.dart';
import '../models/register/Register_request.dart';

class ApiServiceImpl implements ApiService {
  var headers = {"Content-Type": "application/json"};

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    LoginResponse loginResponse = LoginResponse();
    var url = Uri.parse(ConstantUri.loginPath);

    try {
      var response = await http.post(
        url,
        body: jsonEncode(request.toJson()),
        headers: headers, // ត្រូវបន្ថែមបន្ទាត់នេះទើប Server ព្រមទទួលយកទិន្នន័យ
      );

      // Print ទុកមើលក្រែងលោមានបញ្ហាផ្សេងទៀត
      print("Status Code ត្រឡប់មកពី API: ${response.statusCode}");
      print("ទិន្នន័យ Response: ${response.body}");

      if (response.statusCode == 200) {
        loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
        UserAccessToken.setAccess(loginResponse.accessToken ?? "");
        UserAccessToken.setRefreshAccess(loginResponse.refreshToken ?? "");
      }
    } catch (e) {
      print("API Error: $e");
    }

    return loginResponse;
  }
  @override
  Future<bool> register(RegisterRequest request) async {
    var url = Uri.parse(ConstantUri.registerPath); // ត្រូវប្រាកដថាមាន registerPath ក្នុង constant_uri.dart
    try {
      var response = await http.post(
        url,
        body: jsonEncode(request.toJson()),
        headers: headers,
      );
      print("Register Status: ${response.statusCode}");
      print("Register Response: ${response.body}");

      if (response.statusCode == 200) {
        return true; // បង្កើតជោគជ័យ
      }
    } catch (e) {
      print("Register API Error: $e");
    }
    return false;
  }
}