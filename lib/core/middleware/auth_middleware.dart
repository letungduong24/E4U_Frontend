import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      // Use static state instead of instance
      final isAuthenticated = AuthController.user.value != null;
      final userRole = AuthController.user.value?.role;
      
      // If trying to access login page and already authenticated, redirect to appropriate home
      if (route == '/login' && isAuthenticated) {
        switch (userRole) {
          case 'admin':
            return const RouteSettings(name: '/admin-home');
          case 'teacher':
            return const RouteSettings(name: '/teacher-home');
          case 'student':
          default:
            return const RouteSettings(name: '/home');
        }
      }
      
      // If trying to access protected routes and not authenticated, redirect to login
      if (route != '/login' && route != '/splash' && !isAuthenticated) {
        return const RouteSettings(name: '/login');
      }
      
      // Allow navigation
      return null;
    } catch (e) {
      return const RouteSettings(name: '/login');
    }
  }
}
