import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/login/conttroller/login_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/home/conttroller/home_controller.dart';
import 'package:flutter_mobile_app_2026/moduls/splash/conttroller/splash_controller.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
 Widget build(BuildContext context){
   return Scaffold(
     backgroundColor: Colors.white,
     appBar: AppBar(
       backgroundColor: Colors.cyan ,
       title:Text("Login", style: TextStyle(color: Colors.white)),
     ),
   );
 }
}