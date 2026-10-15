import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/forgot/conttroller/forgot_controller.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/button_custom_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:flutter_mobile_app_2026/widgets/input_custom_widget.dart';
import 'package:get/get.dart';

class ForgotView extends GetView<ForgotController> {
  const ForgotView({super.key});

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
            "Reset Password",
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
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Step Indicator
                  _buildStepIndicator(controller.currentStep.value),
                  const SizedBox(height: 24),

                  // Step 1: Input Phone
                  if (controller.currentStep.value == 1) ...[
                    FrostedGlassContainer(
                      borderRadius: BorderRadius.circular(28),
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Step 1: Enter Phone",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Enter your registered phone number to receive a one-time verification code (OTP).",
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          InputCustomWidgets(
                            controller: controller.phoneController,
                            labelText: "Phone Number",
                            hintText: "e.g. 012345678",
                            prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.primary),
                          ),
                          const SizedBox(height: 24),
                          ButtonCustomWidget(
                            label: "Send OTP Code",
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            loading: controller.loading.value,
                            onPressed: controller.onRequestOtp,
                            icon: Icons.send_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Step 2: Verify OTP
                  if (controller.currentStep.value == 2) ...[
                    FrostedGlassContainer(
                      borderRadius: BorderRadius.circular(28),
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Step 2: Verify OTP",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "We have sent an OTP code to ${controller.phoneController.text}. Please enter the 6-digit code below.",
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          InputCustomWidgets(
                            controller: controller.otpController,
                            labelText: "6-Digit OTP Code",
                            hintText: "Enter OTP",
                            prefixIcon: const Icon(Icons.pin_rounded, color: AppColors.primary),
                          ),
                          const SizedBox(height: 24),
                          ButtonCustomWidget(
                            label: "Verify OTP Code",
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            loading: controller.loading.value,
                            onPressed: controller.onVerifyOtp,
                            icon: Icons.verified_user_rounded,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => controller.currentStep.value = 1,
                            child: const Text("Change phone number", style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Step 3: Set New Password
                  if (controller.currentStep.value == 3) ...[
                    FrostedGlassContainer(
                      borderRadius: BorderRadius.circular(28),
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Step 3: New Password",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Enter your old password (or temporary verification key) and specify your new password.",
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          InputCustomWidgets(
                            controller: controller.oldPasswordController,
                            labelText: "Old Password / Verification Key",
                            hintText: "Enter old password",
                            isPassword: true,
                            prefixIcon: const Icon(Icons.key_rounded, color: AppColors.primary),
                          ),
                          const SizedBox(height: 16),
                          InputCustomWidgets(
                            controller: controller.newPasswordController,
                            labelText: "New Password",
                            hintText: "Enter new password",
                            isPassword: true,
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                          ),
                          const SizedBox(height: 16),
                          InputCustomWidgets(
                            controller: controller.confirmPasswordController,
                            labelText: "Confirm New Password",
                            hintText: "Repeat new password",
                            isPassword: true,
                            prefixIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.primary),
                          ),
                          const SizedBox(height: 24),
                          ButtonCustomWidget(
                            label: "Reset & Save Password",
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            loading: controller.loading.value,
                            onPressed: controller.onFinishReset,
                            icon: Icons.check_circle_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepCircle(1, "Phone", current >= 1, current == 1),
        _stepDivider(current >= 2),
        _stepCircle(2, "Verify", current >= 2, current == 2),
        _stepDivider(current >= 3),
        _stepCircle(3, "Reset", current >= 3, current == 3),
      ],
    );
  }

  Widget _stepCircle(int step, String label, bool active, bool isCurrent) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.white.withValues(alpha: 0.6),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? AppColors.primary : Colors.white,
              width: 2,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              "$step",
              style: TextStyle(
                color: active ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider(bool active) {
    return Container(
      width: 44,
      height: 2.5,
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}