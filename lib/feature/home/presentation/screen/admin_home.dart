import 'package:e4uflutter/shared/presentation/scaffold/profile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/home/presentation/controller/home_controller.dart';
import 'package:e4uflutter/feature/home/presentation/widget/nav_button.dart';
import 'package:e4uflutter/feature/home/presentation/widget/small_stat_card.dart';
import 'package:e4uflutter/feature/home/presentation/widget/large_stat_card.dart';
import 'package:e4uflutter/feature/home/presentation/widget/home_header.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    
    return ProfileScaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshStats();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (controller.error.value.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        "Có lỗi xảy ra: ${controller.error.value}",
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.refreshStats,
                        child: const Text("Thử lại"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final stats = controller.stats.value;
            if (stats == null) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header với gradient
                const HomeHeader(),
                const SizedBox(height: 20),
                
                // Navigation buttons
                Row(
                  children: [
                    Expanded(
                      child: NavButton(
                        title: 'Quản lý người dùng',
                        onTap: () => Get.toNamed('/user-management'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NavButton(
                        title: 'Quản lý lớp',
                        onTap: () => Get.toNamed('/class-management'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NavButton(
                        title: 'Quản lý lịch học',
                        onTap: () => Get.toNamed('/admin-schedule'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Card Học sinh lớn
                LargeStatCard(
                  value: stats.studentCount.toString(),
                  title: 'Học sinh',
                ),
                const SizedBox(height: 20),
                
                // Grid các card nhỏ
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.3,
                  children: [
                    SmallStatCard(
                      value: stats.classCount.toString(),
                      title: 'Lớp',
                    ),
                    SmallStatCard(
                      value: stats.scheduleCount.toString(),
                      title: 'Tiết học',
                    ),
                    SmallStatCard(
                      value: stats.homeworkCount.toString(),
                      title: 'Bài tập',
                    ),
                    SmallStatCard(
                      value: stats.documentCount.toString(),
                      title: 'Tài liệu',
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}