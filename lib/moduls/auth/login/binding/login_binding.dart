import 'package:get/get.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/login/conttroller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(authRepository: Get.find()));
  }
}