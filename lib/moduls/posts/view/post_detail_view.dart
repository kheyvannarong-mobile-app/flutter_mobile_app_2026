import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_model.dart';
import 'package:flutter_mobile_app_2026/moduls/posts/controller/posts_controller.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:flutter_mobile_app_2026/utils/date_formatter.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:get/get.dart';

class PostDetailView extends StatefulWidget {
  const PostDetailView({super.key});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  late PostModel post;
  final PostsController controller = Get.find<PostsController>();

  @override
  void initState() {
    super.initState();
    post = Get.arguments as PostModel;
  }

  void _onLike() async {
    await controller.onLike(post.id ?? 0);
    setState(() {
      post.reactions.likes++;
    });
  }

  void _onDislike() async {
    await controller.onDislike(post.id ?? 0);
    setState(() {
      post.reactions.dislikes++;
    });
  }

  void _confirmDelete() {
    Get.defaultDialog(
      title: "Delete Article",
      backgroundColor: Colors.white.withValues(alpha: 0.95),
      titleStyle: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      middleTextStyle: const TextStyle(color: AppColors.textSecondary),
      middleText: "Are you sure you want to delete this article?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      cancelTextColor: AppColors.textSecondary,
      buttonColor: AppColors.error,
      onConfirm: () async {
        Get.back();
        final success = await controller.deletePost(post.id ?? 0);
        if (success) {
          Get.back();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BotanicalBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Sliver App Bar with Image
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
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
              actions: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: FrostedGlassContainer(
                    borderRadius: BorderRadius.circular(20),
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary, size: 20),
                      onPressed: () async {
                        final result = await Get.toNamed(AppRouteName.postCreate, arguments: post);
                        if (result == true) {
                          Get.back();
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  child: FrostedGlassContainer(
                    borderRadius: BorderRadius.circular(20),
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                      onPressed: _confirmDelete,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      post.image ?? 'https://picsum.photos/seed/${post.id ?? 1}/800/600',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.badgeGreenBg,
                        child: const Center(
                          child: Icon(Icons.eco_rounded, size: 72, color: AppColors.primary),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.transparent,
                            AppColors.background.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge & Date
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.badgeGreenBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            post.postCategory?.name ?? "General",
                            style: const TextStyle(
                              color: AppColors.badgeGreenText,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          DateFormatter.format(post.createdAt),
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Post Title
                    Text(
                      post.title ?? "Untitled Story",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Author info Frosted Card
                    FrostedGlassContainer(
                      borderRadius: BorderRadius.circular(20),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: 18,
                            child: Text(
                              (post.user?.firstName ?? "U").substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${post.user?.firstName ?? 'Leafora'} ${post.user?.lastName ?? ''}".trim(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  "@${post.user?.username ?? 'author'}",
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.visibility_outlined, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text("${post.views} views",
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Description callout
                    if (post.description != null && post.description!.isNotEmpty) ...[
                      FrostedGlassContainer(
                        borderRadius: BorderRadius.circular(16),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          post.description!,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            height: 1.45,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Post Body
                    Text(
                      post.body ?? post.description ?? "",
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.7,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tags
                    if (post.tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: post.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.badgeGreenBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "#$tag",
                              style: const TextStyle(fontSize: 12, color: AppColors.badgeGreenText, fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),
                    ],

                    Divider(color: Colors.white.withValues(alpha: 0.6)),
                    const SizedBox(height: 16),

                    // Like & Dislike Interactive Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _onLike,
                          icon: const Icon(Icons.favorite_rounded, size: 20),
                          label: Text("Like (${post.reactions.likes})"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _onDislike,
                          icon: const Icon(Icons.thumb_down_outlined, size: 18),
                          label: Text("Dislike (${post.reactions.dislikes})"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.8),
                            foregroundColor: AppColors.textSecondary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.9)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
