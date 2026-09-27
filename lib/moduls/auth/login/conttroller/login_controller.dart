import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepository authRepository;

  // ១. ដក .obs ចេញពី TextEditingController
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var loading = false.obs;

  LoginController({required this.authRepository});

  @override
  void onClose() {
    // ត្រូវមានការ dispose ដើម្បីសន្សំសំចៃ Memory ពេលបិទទំព័រ Login
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  onLogin() async {
    // ២. ទាញយកអក្សរដោយផ្ទាល់ (លែងប្រើ .value)
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty) {
      Get.snackbar("Error", "Username is required");
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Error", "Password is required");
      return;
    }

    loading.value = true;

    // ៣. បន្ថែម Try-Catch ដើម្បីចាប់មើលថា Error ដោយសារអ្វីពិតប្រាកដ
    try {
      var loginResponse = await authRepository.login(
        username: username,
        password: password,
      );

      if (loginResponse == true) {
        Get.offNamed(AppRouteName.home);
      } else {
        Get.snackbar("Error", "Your username and password are incorrect!");
      }
    } catch (e) {
      Get.snackbar("Server Error", "មិនអាចភ្ជាប់ទៅកាន់ API បានទេ");
      print("========== ចាប់បាន Error: $e ==========");
    } finally {
      loading.value = false; // បញ្ឈប់ការវិល Loading មិនថាមុនឬខុស
    }
  }
}