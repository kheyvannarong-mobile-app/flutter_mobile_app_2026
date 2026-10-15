import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_category_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_create_req.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  final ApiService apiService;

  PostsController({required this.apiService});

  var posts = <PostModel>[].obs;
  var categories = <PostCategoryModel>[].obs;
  var selectedCategoryId = 0.obs; // 0 means ALL
  var searchKeyword = ''.obs;

  var isLoading = false.obs;
  var isCategoryLoading = false.obs;
  var currentPage = 0.obs;
  var hasMore = true.obs;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    await fetchCategories();
    await fetchPosts(refresh: true);
  }

  Future<void> fetchCategories() async {
    isCategoryLoading.value = true;
    try {
      final list = await apiService.getPostCategories();
      categories.assignAll(list);
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      isCategoryLoading.value = false;
    }
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
      // Keep existing posts while loading to avoid UI flicker/stutter
    }

    if (!hasMore.value && !refresh) return;

    isLoading.value = true;
    try {
      final pageRes = await apiService.getPosts(
        page: currentPage.value,
        size: 10,
        categoryId: selectedCategoryId.value > 0 ? selectedCategoryId.value : null,
        keyword: searchKeyword.value.isNotEmpty ? searchKeyword.value : null,
      );

      if (refresh) {
        posts.assignAll(pageRes.content);
      } else {
        posts.addAll(pageRes.content);
      }

      hasMore.value = !pageRes.last && pageRes.content.isNotEmpty;
      if (hasMore.value) {
        currentPage.value++;
      }
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(int id) {
    if (selectedCategoryId.value == id) return;
    selectedCategoryId.value = id;
    fetchPosts(refresh: true);
  }

  void onSearch(String value) {
    searchKeyword.value = value.trim();
    fetchPosts(refresh: true);
  }

  Future<void> onLike(int postId) async {
    final updatedReactions = await apiService.likePost(postId);
    if (updatedReactions != null) {
      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        posts[index].reactions = updatedReactions;
        posts.refresh();
      }
    }
  }

  Future<void> onDislike(int postId) async {
    final updatedReactions = await apiService.dislikePost(postId);
    if (updatedReactions != null) {
      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        posts[index].reactions = updatedReactions;
        posts.refresh();
      }
    }
  }

  Future<bool> deletePost(int postId) async {
    final success = await apiService.deletePost(postId);
    if (success) {
      posts.removeWhere((p) => p.id == postId);
      Get.snackbar("Deleted", "Post was deleted successfully",
          backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      return true;
    } else {
      Get.snackbar("Error", "Could not delete post",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return false;
    }
  }

  Future<bool> createPost(PostCreateReq req) async {
    final success = await apiService.createPost(req);
    if (success) {
      Get.snackbar("Success", "New post created successfully!",
          backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      await fetchPosts(refresh: true);
      return true;
    } else {
      Get.snackbar("Error", "Failed to create post. Please check fields.",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return false;
    }
  }

  Future<bool> updatePost(int id, PostCreateReq req) async {
    final success = await apiService.updatePost(id, req);
    if (success) {
      Get.snackbar("Success", "Post updated successfully!",
          backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      await fetchPosts(refresh: true);
      return true;
    } else {
      Get.snackbar("Error", "Failed to update post",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return false;
    }
  }
}
