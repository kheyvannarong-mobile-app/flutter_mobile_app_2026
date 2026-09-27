import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_mobile_app_2026/moduls/auth/register/conttroller/register_controller.dart';
import 'package:flutter_mobile_app_2026/widgets/button_custom_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/input_custom_widget.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        elevation: 0, // ដកស្រមោលចេញឲ្យមើលទៅរលោង
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0), // បង្កើនគម្លាតសងខាងឲ្យទូលាយបន្តិច
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // បន្ថែមអត្ថបទស្វាគមន៍ផ្នែកខាងលើ
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Please fill in the details below to continue.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // រៀបចំ First Name និង Last Name ឲ្យនៅជួរតែមួយ (Row)
              Row(
                children: [
                  Expanded(
                    child: InputCustomWidgets(
                      controller: controller.firstNameController,
                      labelText: "First Name",
                      hintText: "First Name",
                      prefixIcon: const Icon(Icons.person, color: Colors.cyan),
                    ),
                  ),
                  const SizedBox(width: 16), // គម្លាតរវាងប្រអប់ទាំងពីរ
                  Expanded(
                    child: InputCustomWidgets(
                      controller: controller.lastNameController,
                      labelText: "Last Name",
                      hintText: "Last Name",
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.cyan), // ដូរ icon បន្តិចកុំឲ្យជាន់គ្នា
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              InputCustomWidgets(
                controller: controller.usernameController,
                labelText: "Username",
                hintText: "Choose a username",
                prefixIcon: const Icon(Icons.account_circle, color: Colors.cyan),
              ),
              const SizedBox(height: 16),

              InputCustomWidgets(
                controller: controller.phoneController,
                labelText: "Phone Number",
                hintText: "Enter your phone number",
                prefixIcon: const Icon(Icons.phone, color: Colors.cyan),
              ),
              const SizedBox(height: 16),

              InputCustomWidgets(
                controller: controller.emailController,
                labelText: "Email",
                hintText: "Enter your email",
                prefixIcon: const Icon(Icons.email, color: Colors.cyan),
              ),
              const SizedBox(height: 16),

              InputCustomWidgets(
                controller: controller.passwordController,
                labelText: "Password",
                hintText: "Enter your password",
                isPassword: true,
                prefixIcon: const Icon(Icons.lock, color: Colors.cyan),
              ),
              const SizedBox(height: 16),

              InputCustomWidgets(
                controller: controller.confirmPasswordController,
                labelText: "Confirm Password",
                hintText: "Re-enter your password",
                isPassword: true,
                prefixIcon: const Icon(Icons.lock_clock, color: Colors.cyan),
              ),
              const SizedBox(height: 40), // គម្លាតធំបន្តិចមុនដល់ប៊ូតុង

              Obx(() => ButtonCustomWidget(
                label: "Create Account",
                backgroundColor: Colors.cyan,
                onPressed: controller.onRegister,
                loading: controller.loading.value,
              )),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}