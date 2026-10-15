import 'package:flutter_mobile_app_2026/core/remote/models/api_base_response.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/page_response.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/auth/forgot_password_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/hotel/category_hotel_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/hotel/hotel_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_response.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/User.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_category_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_create_req.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/reactions_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_category_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/register/Register_request.dart';

abstract class ApiService {
  // Auth
  Future<LoginResponse> login(LoginRequest request);
  Future<bool> register(RegisterRequest request);
  Future<bool> logout(int? userId);
  Future<ApiBaseResponse> forgotPassword(String phoneNumber, String deviceId);
  Future<ApiBaseResponse> forgotPasswordVerify(String phoneNumber, String deviceId, String otp);
  Future<ApiBaseResponse> forgotPasswordFinish(String phoneNumber, String oldPassword, String password, String confirmPassword);
  Future<bool> refreshToken();

  // Posts
  Future<PageResponse<PostModel>> getPosts({int page = 0, int size = 10, String status = 'ACT', int? categoryId, String? keyword});
  Future<PostModel?> getPostById(int id);
  Future<ReactionsModel?> likePost(int id);
  Future<ReactionsModel?> dislikePost(int id);
  Future<bool> createPost(PostCreateReq req);
  Future<bool> updatePost(int id, PostCreateReq req);
  Future<bool> deletePost(int id);

  // Post Categories
  Future<List<PostCategoryModel>> getPostCategories({String status = 'ACT'});
  Future<bool> createPostCategory(String name, {String? imageUrl});
  Future<bool> deletePostCategory(int id);

  // Products
  Future<List<ProductModel>> getProducts({String status = 'ACT'});
  Future<ProductModel?> getProductById(int id);
  Future<bool> createProduct(ProductModel product);
  Future<bool> updateProduct(ProductModel product);
  Future<bool> deleteProduct(ProductModel product);

  // Product Categories
  Future<List<ProductCategoryModel>> getProductCategories();
  Future<bool> createProductCategory(String name);
  Future<bool> deleteProductCategory(int id);

  // Hotels
  Future<List<HotelModel>> getHotels({String type = 'ALL', int? categoryHotelId});
  Future<HotelModel?> getHotelById(int id);
  Future<List<CategoryHotelModel>> getHotelCategories();

  // User Profile & Admin
  Future<bool> updateUserProfile(User user);
  Future<bool> changePassword(ChangePasswordRequest req);
  Future<User?> getUserById(int id);
  Future<List<User>> getAdminUsers({String status = 'ACT'});
  Future<bool> deleteAdminUser(int id);
}