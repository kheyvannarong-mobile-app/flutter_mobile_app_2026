import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/login/conttroller/login_controller.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/button_custom_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:flutter_mobile_app_2026/widgets/input_custom_widget.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BotanicalBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top App Logo Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 18,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.eco_rounded,
                          size: 44,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title & Subtitle
                  const Text(
                    "Leafora",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Sign in to your botanical lifestyle space",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Frosted Glass Form Container
                  FrostedGlassContainer(
                    borderRadius: BorderRadius.circular(28),
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        // Phone / Username Input
                        InputCustomWidgets(
                          controller: controller.usernameController,
                          labelText: "Username or Phone Number",
                          hintText: "Enter your registered credentials",
                          errorValidate: "Username is required",
                          prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(height: 18),

                        // Password Input
                        InputCustomWidgets(
                          controller: controller.passwordController,
                          labelText: "Password",
                          hintText: "Enter account password",
                          errorValidate: "Password is required",
                          isPassword: true,
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                        ),

                        // Forgot Password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Get.toNamed(AppRouteName.forgot),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Login Pill Button
                        SizedBox(
                          width: double.infinity,
                          child: Obx(() => ButtonCustomWidget(
                                label: "Sign In",
                                backgroundColor: AppColors.primary,
                                textColor: Colors.white,
                                onPressed: controller.onLogin,
                                loading: controller.loading.value,
                                icon: Icons.login_rounded,
                              )),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRouteName.register),
                        child: const Text(
                          "Register Now",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}