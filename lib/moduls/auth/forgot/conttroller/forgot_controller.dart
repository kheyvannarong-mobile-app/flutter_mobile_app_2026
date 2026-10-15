import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController {
  final AuthRepository authRepository;

  ForgotController({required this.authRepository});

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Step 1: Request OTP, Step 2: Verify OTP, Step 3: Reset Password
  var currentStep = 1.obs;
  var loading = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Step 1: Request OTP
  Future<void> onRequestOtp() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar("Validation Error", "Please enter your registered phone number",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return;
    }

    loading.value = true;
    try {
      final res = await authRepository.requestOtp(phone);
      if (res.isSuccess || res.code == "SUC-000") {
        Get.snackbar("Success", res.messageKh ?? "OTP has been sent to your phone number!",
            backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
        currentStep.value = 2;
      } else {
        Get.snackbar("Error", res.message ?? "Phone number not found in system",
            backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar("Server Error", "Could not connect to server: $e",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      loading.value = false;
    }
  }

  /// Step 2: Verify OTP
  Future<void> onVerifyOtp() async {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      Get.snackbar("Validation Error", "Please enter the OTP code received",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return;
    }

    loading.value = true;
    try {
      final res = await authRepository.verifyOtp(phone, otp);
      if (res.isSuccess || res.code == "SUC-000") {
        Get.snackbar("OTP Verified", "Please enter your new password",
            backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
        currentStep.value = 3;
      } else {
        Get.snackbar("Error", res.message ?? "Invalid or expired OTP code",
            backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar("Server Error", "Could not verify OTP: $e",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      loading.value = false;
    }
  }

  /// Step 3: Finish Reset Password
  Future<void> onFinishReset() async {
    final phone = phoneController.text.trim();
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Validation Error", "Please enter new password and confirmation",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar("Validation Error", "New passwords do not match",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return;
    }

    loading.value = true;
    try {
      final res = await authRepository.finishPasswordReset(
        phoneNumber: phone,
        oldPassword: oldPassword,
        password: newPassword,
        confirmPassword: confirmPassword,
      );
      if (res.isSuccess || res.code == "SUC-000") {
        Get.snackbar("Password Reset Success", "You can now log in with your new password!",
            backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
        Get.offNamed(AppRouteName.login);
      } else {
        Get.snackbar("Reset Failed", res.message ?? "Failed to reset password. Please check your inputs.",
            backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar("Server Error", "Could not complete password reset: $e",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      loading.value = false;
    }
  }
}