import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      // Show loading state
      AuthController.isLoading.value = true;
      
      // Check authentication
      await Get.find<AuthController>().getCurrentUser();
      
      // Wait a bit for smooth transition
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Navigate based on auth state and role
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
    } catch (e) {
      // If auth check fails, go to login
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed('/login');
    } finally {
      AuthController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3396D3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            const Text(
              'English For You',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
