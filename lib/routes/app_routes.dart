import 'package:flutter_mobile_app_2026/moduls/auth/forgot/binding/forgot_binding.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/forgot/view/forgot_view.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/login/binding/login_binding.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/login/view/login_view.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/register/binding/register_binding.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/register/view/register_view.dart';
import 'package:flutter_mobile_app_2026/moduls/home/binding/home_binding.dart';
import 'package:flutter_mobile_app_2026/moduls/home/view/home_view.dart';
import 'package:flutter_mobile_app_2026/moduls/splash/binding/splash_binding.dart';
import 'package:flutter_mobile_app_2026/moduls/splash/view/splash_view.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();

  static List<GetPage> getAllRoutes(){
    return [
      GetPage(name: AppRouteName.splash, page: ()=> SplashView(), binding: SplashBinding()),
      GetPage(name: AppRouteName.home, page: ()=> HomeView(), binding: Homebinding()),
      GetPage(name: AppRouteName.login, page: ()=> LoginView(), binding: LoginBinding()),
      GetPage(name: AppRouteName.register, page: ()=> RegisterView(), binding: RegisterBinding()),
      GetPage(name: AppRouteName.forgot, page: ()=> ForgotView(), binding: ForgotBinding()),


    ];
  }

}