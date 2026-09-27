import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/core/data/local/user_access_token.dart';
import 'package:flutter_mobile_app_2026/moduls/home/conttroller/home_controller.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
 Widget build(BuildContext context){
   return Scaffold(
     appBar: AppBar(
       iconTheme: IconThemeData(
         color: Colors.white
       ),
       backgroundColor: Colors.cyan ,
       title:Text("Home", style: TextStyle(color: Colors.white)),
       actions: [
         IconButton(onPressed: (){}, icon: Icon(Icons.language)),
         IconButton(onPressed: (){
           UserAccessToken.remove();
           Get.offNamed(AppRouteName.login);
         }, icon: Icon(Icons.logout))
       ],
     ),
   );
 }
}