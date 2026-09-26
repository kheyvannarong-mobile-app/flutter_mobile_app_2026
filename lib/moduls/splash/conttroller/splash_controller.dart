import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  var loading = false.obs;
  @override
  void onInit(){
    super.onInit();
  }
  checkLogin() async{
    loading.value = true;
    await Future.delayed(Duration(seconds: 2));
    loading.value = false;
    Get.offNamed(AppRouteName.login);
  }

}