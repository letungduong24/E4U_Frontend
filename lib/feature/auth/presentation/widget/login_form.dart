import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:e4uflutter/shared/presentation/dialog/error_dialog.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isPasswordVisible = false.obs;

    // Handle login
    void handleLogin() {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            message: "Vui lòng nhập đầy đủ thông tin",
          ),
        );
        return;
      }

      Get.find<AuthController>().login(email, password);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Error message - hiển thị ErrorDialog khi có lỗi
          Obx(() {
            if (AuthController.error.value.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    message: AuthController.error.value,
                  ),
                ).then((_) {
                  Get.find<AuthController>().clearError();
                });
              });
            }
            return const SizedBox.shrink();
          }),

          // Email field
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                hintText: 'Email',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Password field
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() => TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                ),
                hintText: 'Mật khẩu',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            )),
          ),

          const SizedBox(height: 24),

          // Login button
          Obx(() => SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: AuthController.isLoading.value ? null : handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3396D3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: AuthController.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Đăng nhập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )),

          const SizedBox(height: 16),

          // Forgot password
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text("Thông báo"),
                  content: const Text("Tính năng đang phát triển"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Quên mật khẩu?', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}