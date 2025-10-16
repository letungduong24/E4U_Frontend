import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading while auth state is being initialized
      if (!AuthController.isInitialized.value) {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "English For You",
                  style: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        );
      }

      // Auto navigate based on auth state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (AuthController.user.value != null) {
          final userRole = AuthController.user.value!.role;
          switch (userRole) {
            case 'admin':
              Get.offAllNamed('/admin-home');
              break;
            case 'teacher':
              Get.offAllNamed('/teacher-home');
              break;
            case 'student':
            default:
              Get.offAllNamed('/home');
              break;
          }
        } else {
          Get.offAllNamed('/login');
        }
      });

      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    });
  }
}
