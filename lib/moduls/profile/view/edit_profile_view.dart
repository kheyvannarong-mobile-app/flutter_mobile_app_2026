import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/moduls/profile/controller/profile_controller.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/button_custom_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:flutter_mobile_app_2026/widgets/input_custom_widget.dart';
import 'package:get/get.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final ProfileController controller = Get.find<ProfileController>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = controller.currentUser.value;
    if (user != null) {
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      usernameController.text = user.username ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final success = await controller.updateProfile(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phoneController.text.trim(),
    );
    if (success) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BotanicalBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            child: FrostedGlassContainer(
              borderRadius: BorderRadius.circular(20),
              padding: EdgeInsets.zero,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          title: const Text(
            "Edit Profile",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: -0.4,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FrostedGlassContainer(
                  borderRadius: BorderRadius.circular(28),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InputCustomWidgets(
                              controller: firstNameController,
                              labelText: "First Name",
                              hintText: "First Name",
                              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InputCustomWidgets(
                              controller: lastNameController,
                              labelText: "Last Name",
                              hintText: "Last Name",
                              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      InputCustomWidgets(
                        controller: usernameController,
                        labelText: "Username",
                        hintText: "Username",
                        prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),
                      InputCustomWidgets(
                        controller: phoneController,
                        labelText: "Phone Number",
                        hintText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),
                      InputCustomWidgets(
                        controller: emailController,
                        labelText: "Email Address",
                        hintText: "Email Address",
                        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() => ButtonCustomWidget(
                              label: "Save Changes",
                              backgroundColor: AppColors.primary,
                              textColor: Colors.white,
                              loading: controller.isLoading.value,
                              onPressed: _onSubmit,
                              icon: Icons.check_rounded,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
