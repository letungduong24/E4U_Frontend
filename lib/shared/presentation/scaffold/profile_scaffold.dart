import 'package:e4uflutter/shared/presentation/drawer/admin_drawer.dart';
import 'package:e4uflutter/shared/presentation/drawer/student_drawer.dart';
import 'package:e4uflutter/shared/presentation/drawer/teacher_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';


class ProfileScaffold extends StatelessWidget {
  final Widget body;
  const ProfileScaffold({
    super.key,
    required this.body,
  });

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Quản trị viên';
      case 'teacher':
        return 'Giáo viên';
      case 'student':
        return 'Học viên';
      default:
        return 'Người dùng';
    }
  }

  Widget _getDrawerByRole() {
    final userRole = AuthController.user.value?.role;
    switch (userRole) {
      case 'admin':
        return const AdminDrawer();
      case 'teacher':
        return const TeacherDrawer();
      case 'student':
      default:
        return const StudentDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _getDrawerByRole(),
      body: Builder(
        builder: (context) => Column(
          children: [
            SafeArea(
                bottom: false,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      Obx(() {
                        final user = AuthController.user.value;
                        final avatarUrl = user?.profile?.avatar;
                        
                        return CircleAvatar(
                          radius: 20,
                          backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : const AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
                        );
                      }),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            AuthController.user.value?.fullName ?? "User",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                          Obx(() => Text(
                            _getRoleDisplayName(AuthController.user.value?.role ?? 'student'),
                            style: const TextStyle(fontSize: 12),
                          )),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey[100], shape: BoxShape.circle),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Scaffold.of(context).openEndDrawer(),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[100], shape: BoxShape.circle),
                          child: Icon(
                            Icons.apps,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
