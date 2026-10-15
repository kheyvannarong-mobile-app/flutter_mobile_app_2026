import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/core/data/local/user_access_token.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/auth/forgot_password_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/User.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ApiService apiService;
  final AuthRepository authRepository;

  ProfileController({
    required this.apiService,
    required this.authRepository,
  });

  var currentUser = Rxn<User>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    currentUser.value = UserAccessToken.getUser();
    if (currentUser.value?.id != null) {
      refreshUserFromServer(currentUser.value!.id!);
    }
  }

  Future<void> refreshUserFromServer(int userId) async {
    try {
      final user = await apiService.getUserById(userId);
      if (user != null) {
        currentUser.value = user;
        UserAccessToken.setUser(user);
      }
    } catch (e) {
      debugPrint("Error fetching user from server: $e");
    }
  }

  bool get isAdmin {
    final user = currentUser.value;
    if (user != null && user.roles != null) {
      return user.roles!.any((r) => r.name == 'ROLE_ADMIN' || r.name == 'ADMIN');
    }
    return UserAccessToken.isAdmin();
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
  }) async {
    final current = currentUser.value;
    if (current == null) return false;

    isLoading.value = true;
    final updated = User(
      id: current.id,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      status: current.status ?? "ACT",
      roles: current.roles,
      profile: current.profile,
    );

    final success = await authRepository.updateProfile(updated);
    isLoading.value = false;

    if (success) {
      currentUser.value = updated;
      UserAccessToken.setUser(updated);
      Get.snackbar("Success", "Profile updated successfully!",
          backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      return true;
    } else {
      Get.snackbar("Error", "Could not update profile. Username or phone may already be in use.",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      Get.snackbar("Validation Error", "New passwords do not match",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return false;
    }

    isLoading.value = true;
    final req = ChangePasswordRequest(
      oldPassword: oldPassword,
      password: newPassword,
      confirmPassword: confirmPassword,
    );

    final success = await authRepository.changePassword(req);
    isLoading.value = false;

    if (success) {
      Get.snackbar("Success", "Password changed successfully!",
          backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      return true;
    } else {
      Get.snackbar("Error", "Old password incorrect or invalid request",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return false;
    }
  }

  Future<void> onLogout() async {
    await authRepository.logout();
    UserAccessToken.remove();
    Get.offAllNamed(AppRouteName.login);
  }
}
