import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_mobile_app_2026/constants/constant_uri.dart';
import 'package:flutter_mobile_app_2026/core/data/local/user_access_token.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/api_base_response.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/auth/forgot_password_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/hotel/category_hotel_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/hotel/hotel_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/Login_response.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/login/User.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/page_response.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_category_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_create_req.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/reactions_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_category_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/register/Register_request.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'package:http/http.dart' as http;

class ApiServiceImpl implements ApiService {
  Map<String, String> _getHeaders({bool requireAuth = false}) {
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    final token = UserAccessToken.getAccessToken();
    if (requireAuth || token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  // ==================== AUTH ====================

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    LoginResponse loginResponse = LoginResponse();
    final url = Uri.parse(ConstantUri.loginPath);

    try {
      final response = await http
          .post(
            url,
            body: jsonEncode(request.toJson()),
            headers: _getHeaders(),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint("Login Status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        loginResponse = LoginResponse.fromJson(decoded);

        if (loginResponse.accessToken != null && loginResponse.accessToken!.isNotEmpty) {
          UserAccessToken.setAccess(loginResponse.accessToken!);
          if (loginResponse.refreshToken != null) {
            UserAccessToken.setRefreshAccess(loginResponse.refreshToken!);
          }
          if (loginResponse.user != null) {
            UserAccessToken.setUser(loginResponse.user!);
          }
        }
      }
    } catch (e) {
      debugPrint("Login API Error: $e");
    }

    return loginResponse;
  }

  @override
  Future<bool> register(RegisterRequest request) async {
    final url = Uri.parse(ConstantUri.registerPath);
    try {
      final reqMap = request.toJson();
      if (reqMap['role'] == null || reqMap['role'] == '') {
        reqMap['role'] = 'ROLE_USER';
      }
      final response = await http.post(
        url,
        body: jsonEncode(reqMap),
        headers: _getHeaders(),
      );
      debugPrint("Register Status: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Register API Error: $e");
      return false;
    }
  }

  @override
  Future<bool> logout(int? userId) async {
    final url = Uri.parse(ConstantUri.logoutPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"userId": userId ?? 0}),
        headers: _getHeaders(requireAuth: true),
      );
      UserAccessToken.remove();
      return response.statusCode == 200;
    } catch (e) {
      UserAccessToken.remove();
      return true;
    }
  }

  @override
  Future<ApiBaseResponse> forgotPassword(String phoneNumber, String deviceId) async {
    final url = Uri.parse(ConstantUri.forgotPasswordPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"phoneNumber": phoneNumber, "deviceId": deviceId}),
        headers: _getHeaders(),
      );
      return ApiBaseResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiBaseResponse(code: "ERR-001", message: e.toString());
    }
  }

  @override
  Future<ApiBaseResponse> forgotPasswordVerify(String phoneNumber, String deviceId, String otp) async {
    final url = Uri.parse(ConstantUri.forgotPasswordVerifyPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"phoneNumber": phoneNumber, "deviceId": deviceId, "otp": otp}),
        headers: _getHeaders(),
      );
      return ApiBaseResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiBaseResponse(code: "ERR-001", message: e.toString());
    }
  }

  @override
  Future<ApiBaseResponse> forgotPasswordFinish(
      String phoneNumber, String oldPassword, String password, String confirmPassword) async {
    final url = Uri.parse(ConstantUri.forgotPasswordFinishPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "phoneNumber": phoneNumber,
          "oldPassword": oldPassword,
          "password": password,
          "confirmPassword": confirmPassword,
        }),
        headers: _getHeaders(),
      );
      return ApiBaseResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiBaseResponse(code: "ERR-001", message: e.toString());
    }
  }

  @override
  Future<bool> refreshToken() async {
    final refreshToken = UserAccessToken.getRefreshToken();
    if (refreshToken.isEmpty) return false;

    final url = Uri.parse(ConstantUri.refreshTokenPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"refreshToken": refreshToken}),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final loginRes = LoginResponse.fromJson(decoded);
        if (loginRes.accessToken != null) {
          UserAccessToken.setAccess(loginRes.accessToken!);
          return true;
        }
      }
    } catch (e) {
      debugPrint("Refresh token error: $e");
    }
    return false;
  }

  // ==================== POSTS ====================

  @override
  Future<PageResponse<PostModel>> getPosts({
    int page = 0,
    int size = 10,
    String status = 'ACT',
    int? categoryId,
    String? keyword,
  }) async {
    // We use the public post endpoint (accessible without login) or app post endpoint
    final queryParams = <String, String>{
      'page': page.toString(),
      'size': size.toString(),
      'status': status,
    };
    if (categoryId != null && categoryId > 0) {
      queryParams['categoryId'] = categoryId.toString();
    }
    if (keyword != null && keyword.trim().isNotEmpty) {
      queryParams['keyword'] = keyword.trim();
    }

    final uri = Uri.parse(ConstantUri.publicPostPath).replace(queryParameters: queryParams);
    try {
      final response = await http.get(uri, headers: _getHeaders());
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final dynamic rawData = decoded['data'];
        if (rawData is Map<String, dynamic>) {
          return PageResponse<PostModel>.fromJson(
            rawData,
            (json) => PostModel.fromJson(json),
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    }

    return PageResponse<PostModel>(
      content: [],
      page: page,
      size: size,
      totalElements: 0,
      totalPages: 0,
      last: true,
    );
  }

  @override
  Future<PostModel?> getPostById(int id) async {
    final url = Uri.parse("${ConstantUri.publicPostPath}/$id");
    try {
      final response = await http.get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          return PostModel.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      debugPrint("Error getPostById: $e");
    }
    return null;
  }

  @override
  Future<ReactionsModel?> likePost(int id) async {
    final url = Uri.parse("${ConstantUri.publicPostPath}/$id/like");
    try {
      final response = await http.post(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          return ReactionsModel.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      debugPrint("Error likePost: $e");
    }
    return null;
  }

  @override
  Future<ReactionsModel?> dislikePost(int id) async {
    final url = Uri.parse("${ConstantUri.publicPostPath}/$id/dislike");
    try {
      final response = await http.post(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          return ReactionsModel.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      debugPrint("Error dislikePost: $e");
    }
    return null;
  }

  @override
  Future<bool> createPost(PostCreateReq req) async {
    final url = Uri.parse(ConstantUri.postPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode(req.toJson()),
        headers: _getHeaders(requireAuth: true),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("Error createPost: $e");
      return false;
    }
  }

  @override
  Future<bool> updatePost(int id, PostCreateReq req) async {
    final url = Uri.parse("${ConstantUri.postPath}/$id");
    try {
      final response = await http.put(
        url,
        body: jsonEncode(req.toJson()),
        headers: _getHeaders(requireAuth: true),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error updatePost: $e");
      return false;
    }
  }

  @override
  Future<bool> deletePost(int id) async {
    final url = Uri.parse("${ConstantUri.postPath}/$id");
    try {
      final response = await http.delete(url, headers: _getHeaders(requireAuth: true));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error deletePost: $e");
      return false;
    }
  }

  // ==================== POST CATEGORIES ====================

  @override
  Future<List<PostCategoryModel>> getPostCategories({String status = 'ACT'}) async {
    final uri = Uri.parse(ConstantUri.postCategoryPath).replace(queryParameters: {'status': status});
    try {
      final response = await http.get(uri, headers: _getHeaders());
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null && decoded['data'] is List) {
          return (decoded['data'] as List).map((c) => PostCategoryModel.fromJson(c)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error getPostCategories: $e");
    }
    return [];
  }

  @override
  Future<bool> createPostCategory(String name, {String? imageUrl}) async {
    final url = Uri.parse(ConstantUri.postCategoryPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          "name": name,
          "imageUrl": imageUrl ?? "https://picsum.photos/seed/${name.toLowerCase()}/400/300",
          "status": "ACT",
        }),
        headers: _getHeaders(requireAuth: true),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("Error createPostCategory: $e");
      return false;
    }
  }

  @override
  Future<bool> deletePostCategory(int id) async {
    final url = Uri.parse("${ConstantUri.postCategoryPath}/$id");
    try {
      final response = await http.delete(url, headers: _getHeaders(requireAuth: true));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error deletePostCategory: $e");
      return false;
    }
  }

  // ==================== PRODUCTS ====================

  @override
  Future<List<ProductModel>> getProducts({String status = 'ALL'}) async {
    final url = Uri.parse(ConstantUri.productListPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"status": status.isEmpty ? "ALL" : status}),
        headers: _getHeaders(requireAuth: true),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null && decoded['data'] is List) {
          return (decoded['data'] as List).map((p) => ProductModel.fromJson(p)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error getProducts: $e");
    }
    return [];
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    final url = Uri.parse("${ConstantUri.productListPath.replaceAll('/list', '')}/$id");
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"status": "ALL"}),
        headers: _getHeaders(requireAuth: true),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          return ProductModel.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      debugPrint("Error getProductById: $e");
    }
    return null;
  }

  @override
  Future<bool> createProduct(ProductModel product) async {
    final url = Uri.parse(ConstantUri.productCreatePath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode(product.toJson()),
        headers: _getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error createProduct: $e");
      return false;
    }
  }

  @override
  Future<bool> updateProduct(ProductModel product) async {
    final url = Uri.parse(ConstantUri.productUpdatePath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode(product.toJson()),
        headers: _getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error updateProduct: $e");
      return false;
    }
  }

  @override
  Future<bool> deleteProduct(ProductModel product) async {
    final url = Uri.parse(ConstantUri.productDeletePath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode(product.toJson()),
        headers: _getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error deleteProduct: $e");
      return false;
    }
  }

  // ==================== PRODUCT CATEGORIES ====================

  @override
  Future<List<ProductCategoryModel>> getProductCategories() async {
    final url = Uri.parse(ConstantUri.productCategoryListPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"status": "ALL"}),
        headers: _getHeaders(requireAuth: true),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null && decoded['data'] is List) {
          return (decoded['data'] as List).map((c) => ProductCategoryModel.fromJson(c)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error getProductCategories: $e");
    }
    return [];
  }

  @override
  Future<bool> createProductCategory(String name) async {
    final url = Uri.parse(ConstantUri.productCategoryCreatePath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"name": name}),
        headers: _getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error createProductCategory: $e");
      return false;
    }
  }

  @override
  Future<bool> deleteProductCategory(int id) async {
    final url = Uri.parse(ConstantUri.productCategoryDeletePath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"id": id}),
        headers: _getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error deleteProductCategory: $e");
      return false;
    }
  }

  // ==================== HOTELS ====================

  @override
  Future<List<HotelModel>> getHotels({String type = 'ALL', int? categoryHotelId}) async {
    final url = Uri.parse(ConstantUri.hotelListPath);
    try {
      final body = <String, dynamic>{
        "type": type,
      };
      if (categoryHotelId != null && categoryHotelId > 0) {
        body["type"] = "BY_CATEGORY";
        body["categoryHotelId"] = categoryHotelId;
      }
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null && decoded['data'] is List) {
          return (decoded['data'] as List).map((h) => HotelModel.fromJson(h)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error getHotels: $e");
    }
    return [];
  }

  @override
  Future<HotelModel?> getHotelById(int id) async {
    final url = Uri.parse("${ConstantUri.hotelByIdPath}/$id");
    try {
      final response = await http.post(
        url,
        body: jsonEncode({}),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          return HotelModel.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      debugPrint("Error getHotelById: $e");
    }
    return null;
  }

  @override
  Future<List<CategoryHotelModel>> getHotelCategories() async {
    final url = Uri.parse(ConstantUri.hotelCategoryListPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({}),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null && decoded['data'] is List) {
          return (decoded['data'] as List).map((c) => CategoryHotelModel.fromJson(c)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error getHotelCategories: $e");
    }
    return [];
  }

  // ==================== USER PROFILE & ADMIN ====================

  @override
  Future<bool> updateUserProfile(User user) async {
    final url = Uri.parse(ConstantUri.userUpdatePath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode(user.toJson()),
        headers: _getHeaders(requireAuth: true),
      );
      if (response.statusCode == 200) {
        UserAccessToken.setUser(user);
        return true;
      }
    } catch (e) {
      debugPrint("Error updateUserProfile: $e");
    }
    return false;
  }

  @override
  Future<bool> changePassword(ChangePasswordRequest req) async {
    final url = Uri.parse(ConstantUri.changePasswordPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode(req.toJson()),
        headers: _getHeaders(requireAuth: true),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error changePassword: $e");
      return false;
    }
  }

  @override
  Future<User?> getUserById(int id) async {
    final url = Uri.parse("${ConstantUri.userByIdPath}/$id");
    try {
      final response = await http.post(
        url,
        body: jsonEncode({}),
        headers: _getHeaders(requireAuth: true),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null) {
          return User.fromJson(decoded['data']);
        }
      }
    } catch (e) {
      debugPrint("Error getUserById: $e");
    }
    return null;
  }

  @override
  Future<List<User>> getAdminUsers({String status = 'ACT'}) async {
    final url = Uri.parse(ConstantUri.adminUserListPath);
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"status": status}),
        headers: _getHeaders(requireAuth: true),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['data'] != null && decoded['data'] is List) {
          return (decoded['data'] as List).map((u) => User.fromJson(u)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error getAdminUsers: $e");
    }
    return [];
  }

  @override
  Future<bool> deleteAdminUser(int id) async {
    final url = Uri.parse("${ConstantUri.adminUserDeletePath}/$id");
    try {
      final response = await http.post(
        url,
        body: jsonEncode({}),
        headers: _getHeaders(requireAuth: true),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error deleteAdminUser: $e");
      return false;
    }
  }
}