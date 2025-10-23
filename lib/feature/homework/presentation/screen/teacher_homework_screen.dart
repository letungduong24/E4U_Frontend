import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/shared/presentation/widget/header_actions.dart';
import 'package:e4uflutter/shared/presentation/widget/success_popup.dart';
import 'package:e4uflutter/shared/presentation/drawer/teacher_drawer.dart';
import 'package:e4uflutter/feature/homework/presentation/controller/homework_controller.dart';
import 'package:e4uflutter/feature/homework/presentation/widget/homework_list.dart';
import 'package:e4uflutter/feature/homework/presentation/widget/homework_modal.dart';

class TeacherHomeworkScreen extends StatelessWidget {
  const TeacherHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already initialized
    final controller = Get.put(HomeworkController());

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const TeacherDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with Header Actions
            Container(
              margin: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: Row(
                children: [
                  const Text(
                    'Quản lý bài tập',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const HeaderActions(),
                ],
              ),
            ),

            // Class Information (no border)
            Obx(() => Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lớp ${controller.selectedClass.value}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Giáo viên phụ trách: ${controller.teacherName.value}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )),

            // Main content - White card with homework list
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() => HomeworkList(classId: controller.selectedClass.value)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddHomeworkModal(context, controller);
        },
        backgroundColor: const Color(0xFF3396D3),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddHomeworkModal(BuildContext context, HomeworkController controller) {
    showDialog(
      context: context,
      builder: (context) => HomeworkModal(
        mode: HomeworkModalMode.create,
        onSave: (title, description, deadline) async {
          await controller.createHomework({
            'title': title,
            'description': description,
            'deadline': DateTime.parse(deadline).toIso8601String(),
            'classId': controller.selectedClass.value,
          });
          
          Navigator.of(context).pop();
          _showSuccessPopup(
            context,
            'Tạo bài tập thành công',
            'Bài tập đã được tạo thành công',
            'Xem bài',
            'Đóng',
          );
        },
      ),
    );
  }

  void _showSuccessPopup(
    BuildContext context,
    String title,
    String message,
    String primaryButtonText,
    String secondaryButtonText,
  ) {
    showDialog(
      context: context,
      builder: (context) => SuccessPopup(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          // Navigate to homework detail or refresh list
        },
        onSecondaryPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
