import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e4uflutter/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:e4uflutter/feature/schedule/presentation/controller/student_schedule_controller.dart';

class StudentScheduleList extends StatelessWidget {
  final DateTime selectedDate;

  const StudentScheduleList({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentScheduleController>();
    
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
        children: controller.schedules.map((schedule) => _buildScheduleItem(schedule, context)).toList(),
      );
    });
  }

  Widget _buildScheduleItem(ScheduleEntity schedule, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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

          SizedBox(width: 5,),
          
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
        ],
      ),
    );
  }
}
