import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'package:e4uflutter/feature/auth/presentation/screen/login_screen.dart';
import 'package:e4uflutter/feature/auth/presentation/screen/profile_screen.dart';
import 'package:e4uflutter/feature/home/presentation/screen/student_home.dart';
import 'package:e4uflutter/feature/home/presentation/screen/admin_home.dart';
import 'package:e4uflutter/feature/home/presentation/screen/teacher_home.dart';
import 'package:e4uflutter/feature/admin/user-manager/presentation/screen/user_list.dart';
import 'package:e4uflutter/core/middleware/auth_middleware.dart';
import 'package:e4uflutter/shared/presentation/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  Get.put(AuthController(), permanent: true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E4U Flutter',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/home',
          page: () => const StudentHome(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/admin-home',
          page: () => const AdminHome(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/teacher-home',
          page: () => const TeacherHome(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfileScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/user-management',
          page: () => const UserListScreen(),
          middlewares: [AuthMiddleware()],
        ),
      ],
      // initialBinding: InitialBinding(), // Removed - AuthController initialized in main()
    );
  }
}


