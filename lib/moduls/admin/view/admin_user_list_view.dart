import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/User.dart';
import 'package:flutter_mobile_app_2026/moduls/admin/controller/admin_controller.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/empty_state_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:get/get.dart';

class AdminUserListView extends StatelessWidget {
  const AdminUserListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

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
            "User Management",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: -0.4,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
              onPressed: () => controller.fetchUsers(),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.users.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.users.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.people_outline,
              title: "No Users Found",
              subtitle: "User records in the system will be displayed here.",
              buttonText: "Reload Users",
              onRetry: () => controller.fetchUsers(),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: Colors.white,
            onRefresh: () => controller.fetchUsers(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return _buildUserCard(user, controller);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUserCard(User user, AdminController controller) {
    final rolesStr = (user.roles ?? []).map((r) => r.name ?? '').join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FrostedGlassContainer(
        borderRadius: BorderRadius.circular(22),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary,
              child: Text(
                (user.firstName ?? user.username ?? "U").substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstName ?? ''} ${user.lastName ?? ''}".trim().isNotEmpty
                        ? "${user.firstName ?? ''} ${user.lastName ?? ''}".trim()
                        : (user.username ?? 'User'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "@${user.username ?? ''} • ${user.phoneNumber ?? ''}",
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: user.status == "ACT" ? AppColors.badgeGreenBg : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          user.status ?? "ACT",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: user.status == "ACT" ? AppColors.badgeGreenText : AppColors.error,
                          ),
                        ),
                      ),
                      if (rolesStr.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            rolesStr,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete User",
                  backgroundColor: Colors.white.withValues(alpha: 0.95),
                  titleStyle: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  middleTextStyle: const TextStyle(color: AppColors.textSecondary),
                  middleText: "Are you sure you want to delete user @${user.username}?",
                  textConfirm: "Delete",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  cancelTextColor: AppColors.textSecondary,
                  buttonColor: AppColors.error,
                  onConfirm: () {
                    Get.back();
                    if (user.id != null) {
                      controller.deleteUser(user.id!);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
