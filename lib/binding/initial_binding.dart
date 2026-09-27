import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service_impl.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository_impl.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ApiService>(() => ApiServiceImpl(), fenix: true);
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(apiService: Get.find()),
      fenix: true,
    );
  }
}
