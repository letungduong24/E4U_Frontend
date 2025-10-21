import 'package:e4uflutter/shared/presentation/drawer/admin_drawer.dart';
import 'package:e4uflutter/shared/presentation/drawer/student_drawer.dart';
import 'package:e4uflutter/shared/presentation/drawer/teacher_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';


class HeaderScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? floatingButton;
  const HeaderScaffold({
    super.key,
    required this.body,
    required this.title,
    this.floatingButton
  });

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
                      Container(
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
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
      floatingActionButton: floatingButton,
    );
  }
}
