import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/forgot/conttroller/forgot_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/home/conttroller/home_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/splash/conttroller/splash_controller.dart';
import 'package:get/get.dart';

class ForgotView extends GetView<ForgotController> {
  const ForgotView({super.key});
  @override
 Widget build(BuildContext context){
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.cyan ,
       title:Text("Home", style: TextStyle(color: Colors.white)),
     ),
   );
 }
}