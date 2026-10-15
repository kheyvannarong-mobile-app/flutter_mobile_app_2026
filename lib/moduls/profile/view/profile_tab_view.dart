import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/moduls/profile/controller/profile_controller.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:get/get.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.8,
                    ),
                  ),
                  FrostedGlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary, size: 20),
                      onPressed: () => Get.toNamed(AppRouteName.editProfile),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // User Profile Glassmorphism Card
              Obx(() {
                final user = controller.currentUser.value;
                final fullName = "${user?.firstName ?? ''} ${user?.lastName ?? ''}".trim();
                final rolesStr = (user?.roles ?? []).map((r) => r.name ?? '').join(', ');

                return FrostedGlassContainer(
                  borderRadius: BorderRadius.circular(28),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      // Avatar with glowing ring
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            (fullName.isNotEmpty ? fullName[0] : (user?.username?[0] ?? 'U')).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        fullName.isNotEmpty ? fullName : (user?.username ?? 'Plant Parent'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "@${user?.username ?? 'user'}",
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      if (rolesStr.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.badgeGreenBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            rolesStr,
                            style: const TextStyle(
                              color: AppColors.badgeGreenText,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withValues(alpha: 0.6), height: 1),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProfileStat(Icons.phone_outlined, user?.phoneNumber ?? "N/A"),
                          Container(width: 1, height: 22, color: Colors.white.withValues(alpha: 0.6)),
                          _buildProfileStat(Icons.email_outlined, user?.email ?? "N/A"),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Profile Options Menu (Frosted Glass Container)
              FrostedGlassContainer(
                borderRadius: BorderRadius.circular(24),
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: "Edit Profile Information",
                      subtitle: "Update name, phone number & email",
                      onTap: () => Get.toNamed(AppRouteName.editProfile),
                    ),
                    Divider(height: 1, color: Colors.white.withValues(alpha: 0.5)),
                    _buildMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: "Change Password",
                      subtitle: "Update account security credentials",
                      onTap: () => Get.toNamed(AppRouteName.changePassword),
                    ),
                    Obx(() {
                      final user = controller.currentUser.value;
                      final isAdmin = (user?.roles?.any((r) => r.name == 'ROLE_ADMIN' || r.name == 'ADMIN') ?? false) || controller.isAdmin;
                      if (isAdmin) {
                        return Column(
                          children: [
                            Divider(height: 1, color: Colors.white.withValues(alpha: 0.5)),
                            _buildMenuItem(
                              icon: Icons.admin_panel_settings_outlined,
                              title: "Admin Portal",
                              subtitle: "Manage all system users and roles",
                              iconColor: const Color(0xFFC07020),
                              onTap: () => Get.toNamed(AppRouteName.adminUsers),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    Divider(height: 1, color: Colors.white.withValues(alpha: 0.5)),
                    _buildMenuItem(
                      icon: Icons.spa_outlined,
                      title: "About This Application",
                      subtitle: "Leafora • BBU Mobile App II 2026",
                      onTap: () => _showAboutDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Logout Button (Sleek Frosted Glass with Red Accent)
              AnimatedGlassCard(
                borderRadius: BorderRadius.circular(22),
                onTap: () => _confirmLogout(context, controller),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Sign out of your active session",
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColors.badgeGreenBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    Get.defaultDialog(
      title: "About Leafora",
      titleStyle: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
      backgroundColor: Colors.white.withValues(alpha: 0.95),
      radius: 20,
      contentPadding: const EdgeInsets.all(20),
      content: const Column(
        children: [
          Icon(Icons.spa_rounded, color: AppColors.primary, size: 48),
          SizedBox(height: 12),
          Text(
            "Leafora Botanical Lifestyle",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
          ),
          SizedBox(height: 4),
          Text("Course: Mobile Application II (2026)", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text("University: Build Bright University (BBU)", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          SizedBox(height: 12),
          Text(
            "Full-Stack Integration with Spring Boot JWT REST API, featuring posts, plant catalog, eco-resort stays, and complete user security.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () => Get.back(),
        child: const Text("Close"),
      ),
    );
  }

  void _confirmLogout(BuildContext context, ProfileController controller) {
    Get.defaultDialog(
      title: "Log Out?",
      titleStyle: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      backgroundColor: Colors.white.withValues(alpha: 0.95),
      middleText: "Are you sure you want to end your current session?",
      middleTextStyle: const TextStyle(color: AppColors.textSecondary),
      radius: 18,
      textConfirm: "Log Out",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      textCancel: "Cancel",
      cancelTextColor: AppColors.textPrimary,
      onConfirm: () {
        Get.back();
        controller.onLogout();
      },
    );
  }
}
