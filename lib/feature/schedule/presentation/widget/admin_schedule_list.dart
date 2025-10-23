import 'package:flutter/material.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/schedule_modal.dart';
import 'package:e4uflutter/feature/schedule/presentation/widget/delete_confirm_modal.dart';

class AdminScheduleList extends StatelessWidget {
  final DateTime selectedDate;

  const AdminScheduleList({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual data from API
    final schedules = _getMockSchedules(selectedDate);

    if (schedules.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Không có tiết học trong ngày này',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Column(
      children: schedules.map((schedule) => _buildScheduleItem(schedule, context)).toList(),
    );
  }

  Widget _buildScheduleItem(Map<String, dynamic> schedule, BuildContext context) {
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
              schedule['classCode'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          
          // Time badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3396D3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              schedule['time'],
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
            onTap: () => _showEditScheduleModal(context, schedule),
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
            onTap: () => _showDeleteConfirmModal(context, schedule),
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

  void _showEditScheduleModal(BuildContext context, Map<String, dynamic> schedule) {
    showDialog(
      context: context,
      builder: (context) => ScheduleModal(
        mode: ScheduleModalMode.update,
        initialClassCode: schedule['classCode'],
        initialTime: schedule['time'],
        onSave: (classCode, time) {
          // Handle update schedule
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã cập nhật lịch học thành công')),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmModal(BuildContext context, Map<String, dynamic> schedule) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmModal(
        scheduleName: schedule['classCode'],
        onConfirm: () {
          // Handle delete schedule
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa lịch học thành công')),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getMockSchedules(DateTime date) {
    // Mock data - replace with actual API call
    final today = DateTime.now();
    final selectedDate = DateTime(date.year, date.month, date.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    
    // Hiển thị lịch dạy cho ngày hôm nay và một số ngày khác
    if (selectedDate.isAtSameMomentAs(todayDate)) {
      return [
        {
          'classCode': 'TA1',
          'time': '18:30 - 20:30',
        },
        {
          'classCode': 'TA2',
          'time': '18:30 - 20:30',
        },
        {
          'classCode': 'TA3',
          'time': '18:30 - 20:30',
        },
      ];
    } else if (date.day == 10) {
      return [
        {
          'classCode': 'TA1',
          'time': '14:00 - 16:00',
        },
        {
          'classCode': 'TA2',
          'time': '16:30 - 18:30',
        },
      ];
    } else if (date.day == 11) {
      return [
        {
          'classCode': 'TA1',
          'time': '09:00 - 11:00',
        },
        {
          'classCode': 'TA3',
          'time': '13:00 - 15:00',
        },
      ];
    }
    return [];
  }
}
