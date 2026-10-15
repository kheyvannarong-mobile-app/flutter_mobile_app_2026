import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/constants/constant_uri.dart';
import 'package:flutter_mobile_app_2026/core/data/local/user_access_token.dart';
import 'package:flutter_mobile_app_2026/moduls/home/conttroller/home_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/hotels/view/hotels_tab_view.dart';
import 'package:flutter_mobile_app_2026/moduls/posts/view/posts_tab_view.dart';
import 'package:flutter_mobile_app_2026/moduls/products/view/products_tab_view.dart';
import 'package:flutter_mobile_app_2026/moduls/profile/view/profile_tab_view.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const tabs = [
      PostsTabView(),
      ProductsTabView(),
      HotelsTabView(),
      ProfileTabView(),
    ];

    return BotanicalBackgroundWidget(
      child: Obx(() {
        final currentIndex = controller.selectedTab.value;

        return Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: Colors.transparent,
          extendBody: true, // Allows floating frosted bar over content!
          drawer: _buildFrostedDrawer(context),
          body: IndexedStack(
            index: currentIndex,
            children: tabs,
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1B3D28).withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.9),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            index: 0,
                            icon: Icons.article_outlined,
                            selectedIcon: Icons.article_rounded,
                            label: "Feed",
                            isSelected: currentIndex == 0,
                            onTap: () => controller.changeTab(0),
                          ),
                          _buildNavItem(
                            index: 1,
                            icon: Icons.inventory_2_outlined,
                            selectedIcon: Icons.inventory_2_rounded,
                            label: "Products",
                            isSelected: currentIndex == 1,
                            onTap: () => controller.changeTab(1),
                          ),
                          _buildNavItem(
                            index: 2,
                            icon: Icons.hotel_outlined,
                            selectedIcon: Icons.hotel_rounded,
                            label: "Hotels",
                            isSelected: currentIndex == 2,
                            onTap: () => controller.changeTab(2),
                          ),
                          _buildNavItem(
                            index: 3,
                            icon: Icons.person_outline_rounded,
                            selectedIcon: Icons.person_rounded,
                            label: "Profile",
                            isSelected: currentIndex == 3,
                            onTap: () => controller.changeTab(3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.badgeGreenBg.withValues(alpha: 0.8) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.15 : 1.0,
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                size: 23,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrostedDrawer(BuildContext context) {
    final user = UserAccessToken.getUser();
    final isAdmin = UserAccessToken.isAdmin();

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            color: Colors.white.withValues(alpha: 0.88),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                          ),
                          child: Center(
                            child: Text(
                              (user?.username != null && user!.username!.isNotEmpty)
                                  ? user.username![0].toUpperCase()
                                  : "U",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.username ?? "Explorer",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user?.email ?? "springboot.api@bbu.edu",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isAdmin ? AppColors.primary : AppColors.badgeGreenBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isAdmin ? "ADMINISTRATOR" : "AUTHORIZED USER",
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: isAdmin ? Colors.white : AppColors.badgeGreenText,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Color(0x1F000000)),

                  // Backend Connection Status Badge Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.dns_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Spring Boot API",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text("🟢 Online", style: TextStyle(fontSize: 10, color: Color(0xFF2E7D32))),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Host: ${ConstantUri.hostIp}:${ConstantUri.port} • PostgreSQL",
                                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Navigation Links
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _buildDrawerTile(
                          icon: Icons.article_rounded,
                          title: "News & Article Feed",
                          subtitle: "Articles, comments & likes",
                          onTap: () {
                            Get.back();
                            controller.changeTab(0);
                          },
                        ),
                        _buildDrawerTile(
                          icon: Icons.inventory_2_rounded,
                          title: "Product Catalog",
                          subtitle: "Stock quantity, SKU & pricing",
                          onTap: () {
                            Get.back();
                            controller.changeTab(1);
                          },
                        ),
                        _buildDrawerTile(
                          icon: Icons.hotel_rounded,
                          title: "Hotels & Stays",
                          subtitle: "Accommodations, floors & rooms",
                          onTap: () {
                            Get.back();
                            controller.changeTab(2);
                          },
                        ),
                        _buildDrawerTile(
                          icon: Icons.person_rounded,
                          title: "User Profile",
                          subtitle: "Account settings & password",
                          onTap: () {
                            Get.back();
                            controller.changeTab(3);
                          },
                        ),
                        if (isAdmin)
                          _buildDrawerTile(
                            icon: Icons.admin_panel_settings_rounded,
                            title: "Admin Portal",
                            subtitle: "User management & roles",
                            highlight: true,
                            onTap: () {
                              Get.back();
                              Get.toNamed(AppRouteName.adminUsers);
                            },
                          ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0x1F000000)),
                        const SizedBox(height: 12),
                        _buildDrawerTile(
                          icon: Icons.info_outline_rounded,
                          title: "About Project",
                          subtitle: "BBU Mobile App II 2026",
                          onTap: () {
                            Get.back();
                            Get.defaultDialog(
                              title: "Spring Boot JWT Mobile",
                              middleText:
                                  "BBU Mobile App II Course 2026\n\nBackend: Spring Boot 3 + PostgreSQL + Flyway\nFrontend: Flutter 3.x + GetX State Management\nUI: 3D Light Frosted Glassmorphism",
                              textConfirm: "OK",
                              confirmTextColor: Colors.white,
                              buttonColor: AppColors.primary,
                              onConfirm: () => Get.back(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.logout_rounded, color: Colors.red),
                        title: const Text(
                          "Sign Out",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          Get.back();
                          Get.defaultDialog(
                            title: "Sign Out",
                            middleText: "Are you sure you want to sign out?",
                            textConfirm: "Sign Out",
                            textCancel: "Cancel",
                            confirmTextColor: Colors.white,
                            cancelTextColor: AppColors.textSecondary,
                            buttonColor: Colors.red,
                            onConfirm: () {
                              UserAccessToken.remove();
                              Get.offAllNamed(AppRouteName.login);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: highlight ? AppColors.badgeGreenBg.withValues(alpha: 0.5) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: highlight ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: highlight ? Colors.white : AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }
}