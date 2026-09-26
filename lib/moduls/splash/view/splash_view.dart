import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/moduls/home/conttroller/home_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/splash/conttroller/splash_controller.dart';
import 'package:get/get.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
 Widget build(BuildContext context){
   return Scaffold(
     backgroundColor: Colors.white,
     body: Center(
       child: Obx((){
         return controller.loading.value == true
             ? CircularProgressIndicator(color: Colors.cyan,)
             : Text("");
       }),
     ),

   );
 }
}