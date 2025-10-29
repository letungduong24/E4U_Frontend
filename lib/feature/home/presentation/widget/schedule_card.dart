import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e4uflutter/feature/home/domain/entity/upcoming_schedule_entity.dart';

class ScheduleCard extends StatelessWidget {
  final UpcomingScheduleEntity schedule;

  const ScheduleCard({
    super.key,
    required this.schedule,
  });

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Thứ 2';
      case 2:
        return 'Thứ 3';
      case 3:
        return 'Thứ 4';
      case 4:
        return 'Thứ 5';
      case 5:
        return 'Thứ 6';
      case 6:
        return 'Thứ 7';
      case 7:
        return 'Chủ nhật';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = _getDayOfWeek(schedule.day.weekday);
    final formattedDate = DateFormat('dd/MM/yyyy').format(schedule.day);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$dayOfWeek - Ngày $formattedDate',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  schedule.classInfo.name.isNotEmpty 
                      ? schedule.classInfo.name 
                      : 'Chưa có lớp',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              schedule.period,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

