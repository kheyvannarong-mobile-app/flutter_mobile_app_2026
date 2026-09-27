import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/login/conttroller/login_controller.dart';
import 'package:flutter_mobile_app_2026/widgets/button_custom_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/input_custom_widget.dart';

import '../../../../routes/app_route_name.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text("Login", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ១. ប្រអប់ Username
            InputCustomWidgets(
              controller: controller.usernameController, // ដកពាក្យ .value ចេញ
              labelText: "Username",
              hintText: "Enter your username",
              errorValidate: "Username is required",
              prefixIcon: const Icon(Icons.person_outline, color: Colors.cyan),
            ),

            const SizedBox(height: 20),

            // ២. ប្រអប់ Password
            InputCustomWidgets(
              controller: controller.passwordController, // ដកពាក្យ .value ចេញ
              labelText: "Password",
              hintText: "Enter your password",
              errorValidate: "Password is required",
              isPassword: true,
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.cyan),
            ),

            const SizedBox(height: 32),

            // ៣. ប៊ូតុង Login (រុំជាមួយ Obx ដើម្បីឲ្យដំណើរការមុខងារ Loading)
            // ៣. ប៊ូតុង Login (កូដចាស់)
            Obx(() => ButtonCustomWidget(
              label: "Login",
              backgroundColor: Colors.cyan,
              onPressed: controller.onLogin,
              loading: controller.loading.value,
            )),

            // ៤. បន្ថែមប៊ូតុងសម្រាប់ទៅកាន់ទំព័រ Register នៅត្រង់នេះ!
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    // បញ្ជាឲ្យលោតទៅកាន់ទំព័រ Register
                    Get.toNamed(AppRouteName.register);
                  },
                  child: const Text(
                    "Register Now",
                    style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}