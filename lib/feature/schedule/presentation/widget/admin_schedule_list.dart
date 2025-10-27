import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/presentation/controller/admin_schedule_controller.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/update_schedule_dialog.dart';
import 'package:e4uflutter/shared/presentation/dialog/success_dialog.dart';
import 'package:e4uflutter/shared/presentation/dialog/delete_confirmation_dialog.dart';

class AdminScheduleList extends StatelessWidget {
  final DateTime selectedDate;

  const AdminScheduleList({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminScheduleController>();
    
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.error.value.isNotEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(height: 8),
              Text(
                'Lỗi tải dữ liệu: ${controller.error.value}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => controller.loadSchedules(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        );
      }

      if (controller.schedules.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'Không có lịch học trong ngày này',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        );
      }

      return Column(
        children: controller.schedules.map((schedule) => _buildScheduleItem(schedule, context, controller)).toList(),
      );
    });
  }

  Widget _buildScheduleItem(ScheduleEntity schedule, BuildContext context, AdminScheduleController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA), // Lighter gray background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Class code
          Expanded(
            child: Text(
              schedule.classCode,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(width: 12),
          
          // Time badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3396D3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              schedule.formattedTime,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Edit button
          GestureDetector(
            onTap: () => _showEditScheduleModal(context, schedule, controller),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFFF9500), // Orange color
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Delete button
          GestureDetector(
            onTap: () => _showDeleteConfirmModal(context, schedule, controller),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFE74C3C), // Red color
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _parseErrorMessage(String error) {
    if (error.contains('conflict') || error.contains('Conflict')) {
      return 'Lịch học đã bị trùng. Vui lòng chọn thời gian khác.';
    }
    if (error.contains('not found')) {
      return 'Không tìm thấy lịch học. Vui lòng thử lại.';
    }
    if (error.contains('500') || error.contains('Server error')) {
      return 'Lỗi máy chủ. Vui lòng thử lại sau.';
    }
    return 'Thao tác thất bại. Vui lòng thử lại.';
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showEditScheduleModal(BuildContext context, ScheduleEntity schedule, AdminScheduleController controller) async {
    showDialog(
      context: context,
      builder: (context) => ScheduleUpdateDialog(
        initialClassCode: schedule.classCode,
        initialTime: schedule.formattedTime,
        onSave: (time) async {
          try {
            // Handle update schedule - only update period
            await controller.updateSchedule(schedule.id, {
              'period': time,
            });
            if (context.mounted) {
              Navigator.of(context).pop();
              // Show success popup
              showDialog(
                context: context,
                builder: (context) => const SuccessDialog(
                  title: 'Cập nhật lịch học thành công',
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.of(context).pop();
              _showErrorDialog(context, _parseErrorMessage(e.toString()));
            }
          }
        },
      ),
    );
  }

    void _showDeleteConfirmModal(BuildContext context, ScheduleEntity schedule, AdminScheduleController controller) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        objectName: 'lịch học',
        deleteFunction: () => controller.deleteSchedule(schedule.id),
        controller: controller,
      ),
    );
  }

}
