import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/moduls/profile/controller/profile_controller.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/button_custom_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:flutter_mobile_app_2026/widgets/input_custom_widget.dart';
import 'package:get/get.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final ProfileController controller = Get.find<ProfileController>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "All password fields are required",
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        colorText: AppColors.error,
      );
      return;
    }

    final success = await controller.changePassword(
      oldPassword: oldPass,
      newPassword: newPass,
      confirmPassword: confirmPass,
    );

    if (success) {
      Get.back();
    }
  }

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
            "Change Password",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: -0.4,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FrostedGlassContainer(
                  borderRadius: BorderRadius.circular(28),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Update Account Security",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Ensure your new password has sufficient complexity.",
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      const SizedBox(height: 22),
                      InputCustomWidgets(
                        controller: oldPasswordController,
                        labelText: "Current Password",
                        hintText: "Enter current password",
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_open_outlined, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),
                      InputCustomWidgets(
                        controller: newPasswordController,
                        labelText: "New Password",
                        hintText: "Enter new password",
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),
                      InputCustomWidgets(
                        controller: confirmPasswordController,
                        labelText: "Confirm New Password",
                        hintText: "Repeat new password",
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() => ButtonCustomWidget(
                              label: "Update Password",
                              backgroundColor: AppColors.primary,
                              textColor: Colors.white,
                              loading: controller.isLoading.value,
                              onPressed: _onSubmit,
                              icon: Icons.security_rounded,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
