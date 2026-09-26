import 'package:flutter_mobile_app_2026/moduls/home/conttroller/home_controller.dart';
import 'package:get/get.dart';

class Homebinding extends Bindings {
  @override
  void dependencies(){
    Get.lazyPut(()=> HomeController());
  }

}