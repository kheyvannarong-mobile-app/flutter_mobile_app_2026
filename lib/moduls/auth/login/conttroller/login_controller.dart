import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepository authRepository;

  LoginController({required this.authRepository});
}