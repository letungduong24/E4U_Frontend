import 'package:e4uflutter/shared/presentation/scaffold/profile_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/home/presentation/widget/nav_button.dart';
import 'package:e4uflutter/feature/home/presentation/widget/home_header.dart';
import 'package:e4uflutter/feature/home/presentation/widget/schedule_card.dart';
import 'package:e4uflutter/feature/home/presentation/controller/home_controller.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    
    // Load upcoming schedules khi init
    if (controller.upcomingSchedules.isEmpty && !controller.isLoadingSchedules.value) {
      controller.loadUpcomingSchedules();
    }

    return ProfileScaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshSchedules();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header với gradient
              const HomeHeader(),
              const SizedBox(height: 20),
              
              // Navigation buttons cho student
              Row(
                children: [
                  Expanded(
                    child: NavButton(
                      title: 'Xem lịch học',
                      onTap: () => Get.toNamed('/student-schedule'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: NavButton(
                      title: 'Xem bài tập',
                      onTap: () => Get.toNamed('/homework-management'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: NavButton(
                      title: 'Xem điểm',
                      onTap: () => Get.toNamed('/grade-list'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Tiêu đề Lịch học sắp tới
              const Text(
                'Lịch học sắp tới',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Danh sách lịch học
              Obx(() {
                if (controller.isLoadingSchedules.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.scheduleError.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(
                            "Có lỗi xảy ra: ${controller.scheduleError.value}",
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.refreshSchedules,
                            child: const Text("Thử lại"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.upcomingSchedules.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            "Không có lịch học sắp tới",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: controller.upcomingSchedules
                      .map((schedule) => ScheduleCard(schedule: schedule))
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
