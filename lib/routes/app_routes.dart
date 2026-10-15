import 'package:flutter_mobile_app_2026/moduls/admin/view/admin_user_list_view.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/forgot/binding/forgot_binding.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/forgot/view/forgot_view.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/login/binding/login_binding.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/login/view/login_view.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/register/binding/register_binding.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/register/view/register_view.dart';
import 'package:flutter_mobile_app_2026/moduls/home/binding/home_binding.dart';
import 'package:flutter_mobile_app_2026/moduls/home/view/home_view.dart';
import 'package:flutter_mobile_app_2026/moduls/hotels/view/hotel_detail_view.dart';
import 'package:flutter_mobile_app_2026/moduls/posts/view/post_create_edit_view.dart';
import 'package:flutter_mobile_app_2026/moduls/posts/view/post_detail_view.dart';
import 'package:flutter_mobile_app_2026/moduls/products/view/product_create_edit_view.dart';
import 'package:flutter_mobile_app_2026/moduls/products/view/product_detail_view.dart';
import 'package:flutter_mobile_app_2026/moduls/profile/view/change_password_view.dart';
import 'package:flutter_mobile_app_2026/moduls/profile/view/edit_profile_view.dart';
import 'package:flutter_mobile_app_2026/moduls/splash/binding/splash_binding.dart';
import 'package:flutter_mobile_app_2026/moduls/splash/view/splash_view.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();

  static List<GetPage> getAllRoutes() {
    return [
      GetPage(
        name: AppRouteName.splash,
        page: () => const SplashView(),
        binding: SplashBinding(),
      ),
      GetPage(
        name: AppRouteName.login,
        page: () => const LoginView(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: AppRouteName.register,
        page: () => const RegisterView(),
        binding: RegisterBinding(),
      ),
      GetPage(
        name: AppRouteName.forgot,
        page: () => const ForgotView(),
        binding: ForgotBinding(),
      ),
      GetPage(
        name: AppRouteName.home,
        page: () => const HomeView(),
        binding: HomeBinding(),
      ),
      GetPage(
        name: AppRouteName.postDetail,
        page: () => const PostDetailView(),
      ),
      GetPage(
        name: AppRouteName.postCreate,
        page: () => const PostCreateEditView(),
      ),
      GetPage(
        name: AppRouteName.productDetail,
        page: () => const ProductDetailView(),
      ),
      GetPage(
        name: AppRouteName.productCreate,
        page: () => const ProductCreateEditView(),
      ),
      GetPage(
        name: AppRouteName.hotelDetail,
        page: () => const HotelDetailView(),
      ),
      GetPage(
        name: AppRouteName.editProfile,
        page: () => const EditProfileView(),
      ),
      GetPage(
        name: AppRouteName.changePassword,
        page: () => const ChangePasswordView(),
      ),
      GetPage(
        name: AppRouteName.adminUsers,
        page: () => const AdminUserListView(),
      ),
    ];
  }
}