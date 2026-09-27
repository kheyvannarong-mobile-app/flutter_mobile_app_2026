import 'dart:convert';

import 'package:flutter_mobile_app_2026/core/data/local/user_access_token.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_response.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'package:http/http.dart' as http;

import '../../../constants/constant_uri.dart';

class ApiServiceImpl implements ApiService {
  var headers = {"Content-Type": "application/json"};
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    LoginResponse loginResponse = LoginResponse();
    var url = Uri.parse(ConstantUri.loginPath);
    var response = await http.post(url, body: jsonEncode(request.toJson()));
    if (response.statusCode == 200) {
      loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
      UserAccessToken.setAccess(loginResponse.accessToken ?? "");
      UserAccessToken.setRefreshAccess(loginResponse.refreshToken ?? "");
    }
    return loginResponse;
  }
}
