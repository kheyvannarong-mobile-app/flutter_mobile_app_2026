import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/respository/auth_repository.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart'; // ត្រូវបន្ថែម Import នេះសម្រាប់ស្គាល់ AppRouteName

import '../../../../core/remote/models/register/Register_request.dart';

class RegisterController extends GetxController {
  final AuthRepository authRepository;

  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var loading = false.obs;

  RegisterController({required this.authRepository});

  void onRegister() async {
    // ចាប់យកអត្ថបទ
    String username = usernameController.text.trim();
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // ត្រួតពិនិត្យ (Validation) ខ្លីៗ
    if (username.isEmpty || firstName.isEmpty || password.isEmpty || phone.isEmpty) {
      Get.snackbar("Error", "សូមបំពេញព័ត៌មានឲ្យបានគ្រប់ជ្រុងជ្រោយ!");
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar("Error", "ពាក្យសម្ងាត់ទាំងពីរមិនត្រូវគ្នាទេ!");
      return;
    }

    loading.value = true;

    // បង្កើតកញ្ចប់ទិន្នន័យដើម្បីផ្ញើទៅ API
    RegisterRequest request = RegisterRequest(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phone,
      password: password,
      confirmPassword: confirmPassword,
      role: "USER", // តម្លៃដើម (Default)
      profile: "",
    );

    // ១. បាញ់ API ទៅកាន់ Server ដើម្បី Register
    bool isSuccess = await authRepository.register(request);

    if (isSuccess) {
      // ២. ប្រសិនបើ Register ជោគជ័យ ធ្វើការបាញ់ API ទៅ Login យក Token ដោយស្វ័យប្រវត្តិ
      bool loginSuccess = await authRepository.login(
        username: phone, // ផ្អែកតាម API Login របស់មិត្តប្រើប្រាស់លេខទូរស័ព្ទ
        password: password,
      );

      loading.value = false;

      if (loginSuccess) {
        Get.snackbar(
            "Success",
            "បង្កើតគណនីបានជោគជ័យ!",
            backgroundColor: Colors.green,
            colorText: Colors.white
        );
        // ៣. លោតហោះទៅកាន់ទំព័រ Home តែម្ដង ហើយមិនអាចថយក្រោយមក Register វិញបានទេ
        Get.offAllNamed(AppRouteName.home);
      } else {
        // ប្រសិនបើ Login Auto មិនបាន ឲ្យត្រឡប់ទៅទំព័រ Login ដើម្បីវាយបញ្ចូលខ្លួនឯង
        Get.offAllNamed(AppRouteName.login);
      }
    } else {
      loading.value = false;
      Get.snackbar("Error", "បរាជ័យក្នុងការបង្កើតគណនី សូមសាកល្បងម្ដងទៀត ឬប្តូរលេខទូរស័ព្ទថ្មី!");
    }
  }
}