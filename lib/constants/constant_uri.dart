import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ConstantUri {
  ConstantUri._();

  /// PC Local IP for Real Device: "192.168.1.6"
  /// For USB Cable with ADB reverse (`adb reverse tcp:30033 tcp:30033`): "127.0.0.1" or "localhost"
  /// For Android Emulator: "10.0.2.2"
  static const String hostIp = "10.0.2.2";
  static const String port = "30033";

  static String get baseUri {
    if (kIsWeb) return "http://localhost:$port";
    try {
      if (Platform.isAndroid) {
        // 192.168.1.6 connects to PC Spring Boot over Wi-Fi
        // (or use "127.0.0.1" if using USB with adb reverse)
        return "http://$hostIp:$port";
      }
    } catch (_) {}
    return "http://localhost:$port";
  }

  // Auth endpoints
  static String get loginPath => "$baseUri/api/oauth/token";
  static String get logoutPath => "$baseUri/api/oauth/logout";
  static String get registerPath => "$baseUri/api/oauth/register";
  static String get forgotPasswordPath => "$baseUri/api/oauth/forgot/password";
  static String get forgotPasswordVerifyPath => "$baseUri/api/oauth/forgot/password/verify";
  static String get forgotPasswordFinishPath => "$baseUri/api/oauth/forgot/password/finish";
  static String get refreshTokenPath => "$baseUri/api/oauth/refresh";
  static String get uploadImagePath => "$baseUri/api/oauth/image/upload";
  static String get viewImagePath => "$baseUri/api/public/view/image";

  // Post & Post Category endpoints
  static String get postPath => "$baseUri/api/app/post";
  static String get publicPostPath => "$baseUri/api/public/post";
  static String get postCategoryPath => "$baseUri/api/app/post/category";
  static String get publicPostCategoryPath => "$baseUri/api/public/post-category";

  // Product endpoints
  static String get productListPath => "$baseUri/api/app/product/list";
  static String get productCreatePath => "$baseUri/api/app/product/create";
  static String get productUpdatePath => "$baseUri/api/app/product/update";
  static String get productDeletePath => "$baseUri/api/app/product/delete";
  static String get productCategoryListPath => "$baseUri/api/app/product/category/list";
  static String get productCategoryCreatePath => "$baseUri/api/app/product/category/create";
  static String get productCategoryUpdatePath => "$baseUri/api/app/product/category/update";
  static String get productCategoryDeletePath => "$baseUri/api/app/product/category/delete";

  // Hotel endpoints
  static String get hotelListPath => "$baseUri/api/public/hotels/list";
  static String get hotelByIdPath => "$baseUri/api/public/hotels/getById";
  static String get hotelCategoryListPath => "$baseUri/api/public/hotels/category/list";

  // User endpoints
  static String get userUpdatePath => "$baseUri/api/app/user/update";
  static String get changePasswordPath => "$baseUri/api/app/user/change/password";
  static String get userByIdPath => "$baseUri/api/app/user";

  // Admin endpoints
  static String get adminUserListPath => "$baseUri/api/app/admin/user/list";
  static String get adminUserCreatePath => "$baseUri/api/app/admin/user/create";
  static String get adminUserUpdatePath => "$baseUri/api/app/admin/user/update";
  static String get adminUserDeletePath => "$baseUri/api/app/admin/user/delete";
}
