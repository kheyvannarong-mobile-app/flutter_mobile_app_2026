import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'package:flutter_mobile_app_2026/moduls/admin/controller/admin_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository.dart';
import 'package:flutter_mobile_app_2026/moduls/home/conttroller/home_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/hotels/controller/hotels_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/posts/controller/posts_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/products/controller/products_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<PostsController>(() => PostsController(apiService: Get.find<ApiService>()), fenix: true);
    Get.lazyPut<ProductsController>(() => ProductsController(apiService: Get.find<ApiService>()), fenix: true);
    Get.lazyPut<HotelsController>(() => HotelsController(apiService: Get.find<ApiService>()), fenix: true);
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        apiService: Get.find<ApiService>(),
        authRepository: Get.find<AuthRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut<AdminController>(() => AdminController(apiService: Get.find<ApiService>()), fenix: true);
  }
}