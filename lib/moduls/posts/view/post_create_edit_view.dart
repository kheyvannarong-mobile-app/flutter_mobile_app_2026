import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_create_req.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_model.dart';
import 'package:flutter_mobile_app_2026/moduls/posts/controller/posts_controller.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/button_custom_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:flutter_mobile_app_2026/widgets/input_custom_widget.dart';
import 'package:get/get.dart';

class PostCreateEditView extends StatefulWidget {
  const PostCreateEditView({super.key});

  @override
  State<PostCreateEditView> createState() => _PostCreateEditViewState();
}

class _PostCreateEditViewState extends State<PostCreateEditView> {
  final PostsController controller = Get.find<PostsController>();

  PostModel? existingPost;
  bool isEditing = false;

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final bodyController = TextEditingController();
  final imageController = TextEditingController();
  final tagsController = TextEditingController();

  int? selectedCategoryId;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is PostModel) {
      existingPost = Get.arguments as PostModel;
      isEditing = true;
      titleController.text = existingPost!.title ?? '';
      descController.text = existingPost!.description ?? '';
      bodyController.text = existingPost!.body ?? '';
      imageController.text = existingPost!.image ?? '';
      tagsController.text = existingPost!.tags.join(', ');
      selectedCategoryId = existingPost!.postCategory?.id;
    } else {
      if (controller.categories.isNotEmpty) {
        selectedCategoryId = controller.categories.first.id;
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    bodyController.dispose();
    imageController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final title = titleController.text.trim();
    final desc = descController.text.trim();
    final body = bodyController.text.trim();
    final image = imageController.text.trim().isNotEmpty
        ? imageController.text.trim()
        : "https://picsum.photos/seed/${title.toLowerCase().replaceAll(' ', '')}/800/600";
    final tags = tagsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    if (title.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Title is required",
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        colorText: AppColors.error,
      );
      return;
    }

    if (selectedCategoryId == null) {
      Get.snackbar(
        "Validation Error",
        "Please select a category",
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        colorText: AppColors.error,
      );
      return;
    }

    setState(() => loading = true);

    final req = PostCreateReq(
      title: title,
      description: desc.isNotEmpty ? desc : title,
      body: body.isNotEmpty ? body : desc,
      image: image,
      categoryId: selectedCategoryId!,
      tags: tags,
    );

    bool success;
    if (isEditing) {
      success = await controller.updatePost(existingPost!.id ?? 0, req);
    } else {
      success = await controller.createPost(req);
    }

    setState(() => loading = false);

    if (success) {
      Get.back(result: true);
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
          title: Text(
            isEditing ? "Edit Article Post" : "Create Article Post",
            style: const TextStyle(
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
                      InputCustomWidgets(
                        controller: titleController,
                        labelText: "Article Title *",
                        hintText: "Enter an engaging title",
                        prefixIcon: const Icon(Icons.title_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),

                      // Category Selector
                      Obx(() {
                        final categories = controller.categories;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 1.2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              value: selectedCategoryId,
                              hint: const Text("Select Category *", style: TextStyle(color: AppColors.textMuted)),
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                              items: categories.map((cat) {
                                return DropdownMenuItem<int>(
                                  value: cat.id,
                                  child: Text(cat.name ?? "General"),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() => selectedCategoryId = val);
                              },
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),

                      InputCustomWidgets(
                        controller: imageController,
                        labelText: "Cover Image URL",
                        hintText: "https://example.com/image.jpg",
                        prefixIcon: const Icon(Icons.image_outlined, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: descController,
                        maxLines: 3,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: "Short Summary",
                          labelStyle: const TextStyle(color: AppColors.textSecondary),
                          hintText: "Brief summary of this article...",
                          hintStyle: const TextStyle(color: AppColors.textMuted),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: bodyController,
                        maxLines: 6,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: "Full Article Content",
                          labelStyle: const TextStyle(color: AppColors.textSecondary),
                          hintText: "Write the full story here...",
                          hintStyle: const TextStyle(color: AppColors.textMuted),
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      InputCustomWidgets(
                        controller: tagsController,
                        labelText: "Tags (Comma separated)",
                        hintText: "nature, plants, botanical",
                        prefixIcon: const Icon(Icons.tag_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(height: 26),

                      ButtonCustomWidget(
                        label: isEditing ? "Update Article" : "Publish Article",
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                        loading: loading,
                        onPressed: _onSubmit,
                        icon: Icons.check_circle_rounded,
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
