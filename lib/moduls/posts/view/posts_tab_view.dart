import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/core/data/local/user_access_token.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_model.dart';
import 'package:flutter_mobile_app_2026/moduls/home/conttroller/home_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/posts/controller/posts_controller.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:flutter_mobile_app_2026/utils/date_formatter.dart';
import 'package:flutter_mobile_app_2026/widgets/category_chip_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/empty_state_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:get/get.dart';

class PostsTabView extends StatelessWidget {
  const PostsTabView({super.key});

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 24),
                          SizedBox(width: 8),
                          Text(
                            "Notifications",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.snackbar(
                            "Notifications",
                            "All notifications marked as read",
                            backgroundColor: Colors.white.withValues(alpha: 0.9),
                            colorText: AppColors.textPrimary,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        child: const Text("Clear All", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationTile(
                    icon: Icons.check_circle_rounded,
                    iconColor: AppColors.primary,
                    title: "Welcome to App Portal",
                    subtitle: "Your account session is active and verified.",
                    time: "Just now",
                  ),
                  _buildNotificationTile(
                    icon: Icons.article_rounded,
                    iconColor: AppColors.primary,
                    title: "New Featured Articles",
                    subtitle: "Explore 100+ knowledge stories across Tech, Travel & Business.",
                    time: "15m ago",
                  ),
                  _buildNotificationTile(
                    icon: Icons.inventory_2_rounded,
                    iconColor: const Color(0xFF2563EB),
                    title: "Products Catalog Online",
                    subtitle: "Explore new electronics, hardware, and inventory items.",
                    time: "1h ago",
                  ),
                  _buildNotificationTile(
                    icon: Icons.hotel_rounded,
                    iconColor: const Color(0xFFD97706),
                    title: "Hotel Suites & Rooms",
                    subtitle: "Rooms and suites available for instant reservations.",
                    time: "Yesterday",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildNotificationTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostsController>();
    final user = UserAccessToken.getUser();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Icon Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Hamburger Menu (Clickable to open Navigation Drawer)
                        GestureDetector(
                          onTap: () {
                            Get.find<HomeController>().openDrawer();
                          },
                          child: FrostedGlassContainer(
                            borderRadius: BorderRadius.circular(16),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.notes_rounded,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 24),
                              onPressed: () => controller.fetchPosts(refresh: true),
                            ),
                            // Notification Button (Clickable!)
                            GestureDetector(
                              onTap: () => _showNotificationSheet(context),
                              child: FrostedGlassContainer(
                                borderRadius: BorderRadius.circular(16),
                                padding: const EdgeInsets.all(8),
                                child: Stack(
                                  children: [
                                    const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 24),
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Greeting
                    const Text(
                      "Good Morning,",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user?.username != null && user!.username!.isNotEmpty
                                ? user.username!
                                : "Explorer",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.bolt_rounded, color: AppColors.primary, size: 28),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Explore trending articles, product catalog & stays",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Search Pill Container (Frosted Glass)
                    FrostedGlassContainer(
                      borderRadius: BorderRadius.circular(30),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: controller.searchController,
                        onSubmitted: controller.onSearch,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Search articles, technology, business...",
                          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                          suffixIcon: controller.searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.onSearch('');
                                  },
                                )
                              : const Icon(Icons.tune_rounded, color: AppColors.textMuted, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Consumer-Friendly Daily Knowledge Highlights Card (Frosted Glass)
                    AnimatedGlassCard(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        controller.selectCategory(0);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.badgeGreenBg,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.auto_stories_rounded,
                                color: AppColors.primary,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Daily Knowledge Digest",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text("✨", style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Discover top stories in Tech, Business & Lifestyle",
                                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.textPrimary,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section Title: Articles & Feed
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Articles & Feed",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final res = await Get.toNamed(AppRouteName.postCreate);
                            if (res == true) {
                              controller.fetchPosts(refresh: true);
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.add_circle_outline_rounded, size: 16, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text(
                                "New Post",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Categories Horizontal Bar
                    SizedBox(
                      height: 44,
                      child: Obx(() {
                        if (controller.isCategoryLoading.value) {
                          return const Center(child: LinearProgressIndicator(color: AppColors.primary));
                        }
                        final categories = controller.categories;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: categories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              final isSelected = controller.selectedCategoryId.value == 0;
                              return CategoryChipWidget(
                                label: "All Feed",
                                isSelected: isSelected,
                                icon: Icons.all_inclusive_rounded,
                                onTap: () => controller.selectCategory(0),
                              );
                            }
                            final cat = categories[index - 1];
                            final isSelected = controller.selectedCategoryId.value == cat.id;
                            return CategoryChipWidget(
                              label: cat.name ?? '',
                              isSelected: isSelected,
                              onTap: () => controller.selectCategory(cat.id ?? 0),
                            );
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Posts List
            Obx(() {
              if (controller.isLoading.value && controller.posts.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              if (controller.posts.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyStateWidget(
                    icon: Icons.article_outlined,
                    title: "No Articles Found",
                    subtitle: "No articles match the selected category.",
                    buttonText: "Refresh Feed",
                    onRetry: () => controller.fetchPosts(refresh: true),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == controller.posts.length) {
                        controller.fetchPosts();
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        );
                      }

                      final post = controller.posts[index];
                      return _buildPostCard(context, post, controller);
                    },
                    childCount: controller.posts.length + (controller.hasMore.value ? 1 : 0),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, PostModel post, PostsController controller) {
    return AnimatedGlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      borderRadius: BorderRadius.circular(24),
      onTap: () => Get.toNamed(AppRouteName.postDetail, arguments: post),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Category Overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Image.network(
                  post.image ?? 'https://picsum.photos/seed/${post.id ?? 1}/600/350',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: AppColors.badgeGreenBg,
                    child: const Center(
                      child: Icon(Icons.article_rounded, size: 48, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    post.postCategory?.name ?? "General",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content Area
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title ?? 'Untitled Post',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                if (post.description != null && post.description!.isNotEmpty) ...[
                  Text(
                    post.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Footer
                Row(
                  children: [
                    const Icon(Icons.visibility_outlined, size: 15, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      "${post.views}",
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 14),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => controller.onLike(post.id ?? 0),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite_rounded, size: 15, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text(
                            "${post.reactions.likes}",
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => controller.onDislike(post.id ?? 0),
                      child: Row(
                        children: [
                          const Icon(Icons.thumb_down_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            "${post.reactions.dislikes}",
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormatter.formatShort(post.createdAt),
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
