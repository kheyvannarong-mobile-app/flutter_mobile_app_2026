import 'package:flutter_mobile_app_2026/moduls/auth/forgot/conttroller/forgot_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository.dart';
import 'package:get/get.dart';

class ForgotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotController>(
      () => ForgotController(authRepository: Get.find<AuthRepository>()),
    );
  }
}