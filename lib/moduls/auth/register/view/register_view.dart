import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/register/conttroller/register_controller.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/button_custom_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:flutter_mobile_app_2026/widgets/input_custom_widget.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BotanicalBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            child: FrostedGlassContainer(
              borderRadius: BorderRadius.circular(20),
              padding: EdgeInsets.zero,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          title: const Text(
            "Create Account",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: -0.4,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Join Leafora",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Create an account to explore botanical catalog & plant care.",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Frosted Glass Form Container
              FrostedGlassContainer(
                borderRadius: BorderRadius.circular(28),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InputCustomWidgets(
                            controller: controller.firstNameController,
                            labelText: "First Name",
                            hintText: "First Name",
                            prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InputCustomWidgets(
                            controller: controller.lastNameController,
                            labelText: "Last Name",
                            hintText: "Last Name",
                            prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InputCustomWidgets(
                      controller: controller.usernameController,
                      labelText: "Username",
                      hintText: "Choose a username",
                      prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    InputCustomWidgets(
                      controller: controller.phoneController,
                      labelText: "Phone Number",
                      hintText: "Enter phone number",
                      prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    InputCustomWidgets(
                      controller: controller.emailController,
                      labelText: "Email Address",
                      hintText: "Enter email address",
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    InputCustomWidgets(
                      controller: controller.passwordController,
                      labelText: "Password",
                      hintText: "Create a password",
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    InputCustomWidgets(
                      controller: controller.confirmPasswordController,
                      labelText: "Confirm Password",
                      hintText: "Re-enter password",
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: Obx(() => ButtonCustomWidget(
                            label: "Register Account",
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            onPressed: controller.onRegister,
                            loading: controller.loading.value,
                            icon: Icons.person_add_alt_1_rounded,
                          )),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}