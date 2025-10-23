import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/presentation/controller/auth_controller.dart';
import 'drawer_item.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                ),
              ),
              child: const ListTile(
                title: Text(
                  'E4U Education',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: () {
                Get.toNamed('/profile');
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() {
                      final user = AuthController.user.value;
                      final avatarUrl = user?.profile?.avatar;
                      
                      return CircleAvatar(
                        radius: 14,
                        backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                            ? NetworkImage(avatarUrl)
                            : const AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
                      );
                    }),
                    const SizedBox(width: 10),
                    Obx(() => Text(
                      AuthController.user.value?.fullName ?? "Student",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            DrawerItem(
              icon: MaterialSymbols.home_outline_rounded,
              title: 'Trang chủ',
              iconColor: Colors.white,
              backgroundColor: const Color(0xFF002055),
              textColor: Colors.white,
              onTap: () => Get.toNamed('/home'),
            ),
            const SizedBox(height: 15),
            DrawerItem(
              icon: Uil.schedule,
              title: 'Lịch học',
              onTap: () => Get.toNamed('/student-schedule'),
            ),
            const SizedBox(height: 15),
            DrawerItem(
              icon: Mdi.file_document_outline,
              title: 'Tài liệu',
              onTap: () {},
            ),
            const SizedBox(height: 15),
            DrawerItem(
              icon: Mdi.numeric_9_plus_box_outline,
              title: 'Xem điểm',
              onTap: () {},
            ),
            const SizedBox(height: 15),
            DrawerItem(
              icon: Ic.outline_settings,
              title: 'Cài đặt',
              onTap: () {},
            ),
            const SizedBox(height: 15),
            DrawerItem(
              icon: MaterialSymbols.logout,
              title: 'Đăng xuất',
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () => authController.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
