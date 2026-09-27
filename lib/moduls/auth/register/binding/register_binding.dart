import 'package:get/get.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/register/conttroller/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    // បង្កើត RegisterController និងទាញយក AuthRepository មកប្រើ
    Get.lazyPut(() => RegisterController(authRepository: Get.find()));
  }
}