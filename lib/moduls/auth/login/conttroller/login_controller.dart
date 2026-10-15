import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepository authRepository;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var loading = false.obs;

  LoginController({required this.authRepository});

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> onLogin() async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    if (username.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Phone number or username is required",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }
    if (password.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Password is required",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    loading.value = true;

    try {
      final success = await authRepository.login(
        username: username,
        password: password,
      );

      if (success) {
        Get.snackbar(
          "Welcome",
          "Login successful!",
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          duration: const Duration(seconds: 2),
        );
        Get.offAllNamed(AppRouteName.home);
      } else {
        Get.snackbar(
          "Login Failed",
          "Invalid phone number or password. Please try again.",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Connection Error",
        "Could not connect to API server: $e",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      loading.value = false;
    }
  }
}