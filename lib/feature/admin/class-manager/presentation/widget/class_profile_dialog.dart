import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_management_entity.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/controller/class_management_controller.dart';
import 'package:e4uflutter/feature/admin/class-manager/presentation/widget/assign_teacher_dialog.dart';
import 'package:e4uflutter/shared/presentation/dialog/delete_confirmation_dialog.dart';

class ClassProfileDialog extends StatelessWidget {
  final ClassManagementEntity classItem;

  const ClassProfileDialog({
    super.key,
    required this.classItem,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassManagementController>();
    
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxHeight: 600,
          minHeight: 400,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Chi tiết lớp học",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Class information
                _buildInfoRow("Tên lớp", classItem.name),
                _buildInfoRow("Mã lớp", classItem.code),
                _buildInfoRow("Mô tả", classItem.description.isNotEmpty ? classItem.description : "Không có mô tả"),
                _buildInfoRow("Giáo viên chủ nhiệm", classItem.homeroomTeacherName ?? "Chưa có giáo viên"),
                _buildInfoRow("Số học viên tối đa", classItem.maxStudents.toString()),
                _buildInfoRow("Số học viên hiện tại", classItem.studentIds.length.toString()),

                const SizedBox(height: 24),
                const SizedBox(height: 12),
                // View students button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _handleViewStudents(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: const Text(
                            "Xem danh sách học sinh",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Teacher management button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: classItem.homeroomTeacherName != null ? Colors.orange : Colors.green,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _handleTeacherManagement(context, controller),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            classItem.homeroomTeacherName != null ? "Xóa giáo viên chủ nhiệm" : "Chọn giáo viên chủ nhiệm",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTeacherManagement(BuildContext context, ClassManagementController controller) {
    if (classItem.homeroomTeacherName != null) {
      // Remove teacher
      showDialog(
        context: context,
        builder: (context) => DeleteConfirmationDialog(
          objectName: "giáo viên chủ nhiệm",
          controller: controller,
          deleteFunction: () async {
            Navigator.pop(context); // Close confirmation dialog
            Navigator.pop(context); // Close profile dialog
            await controller.removeHomeroomTeacher(
              classItem.id,
              classItem.homeroomTeacherId,
            );
          },
        ),
      );
    } else {
      // Select teacher
      Navigator.pop(context); // Close profile dialog
      _showTeacherSelectionDialog(context, controller);
    }
  }

  void _showTeacherSelectionDialog(BuildContext context, ClassManagementController controller) {
    showDialog(
      context: context,
      builder: (context) => AssignTeacherDialog(
        controller: controller,
        classItem: classItem,
      ),
    );
  }

  void _handleViewStudents(BuildContext context) {
    Navigator.pop(context); // Close profile dialog
    Get.toNamed('/class-students', arguments: {
      'classId': classItem.id,
      'className': classItem.name,
      'classCode': classItem.code,
    });
  }
}
