import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/User.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final ApiService apiService;

  AdminController({required this.apiService});

  var users = <User>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final list = await apiService.getAdminUsers(status: "ALL");
      users.assignAll(list);
    } catch (e) {
      debugPrint("Error fetching admin users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteUser(int id) async {
    final success = await apiService.deleteAdminUser(id);
    if (success) {
      users.removeWhere((u) => u.id == id);
      Get.snackbar("Success", "User account removed",
          backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      return true;
    } else {
      Get.snackbar("Error", "Could not remove user account",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return false;
    }
  }
}
