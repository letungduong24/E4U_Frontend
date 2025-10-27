class ScheduleEntity {
  final String id;
  final String classCode;
  final String? className;
  final String subject;
  final String teacherId;
  final String? teacherName;
  final DateTime startTime;
  final DateTime endTime;
  final String dayOfWeek;
  final String room;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduleEntity({
    required this.id,
    required this.classCode,
    this.className,
    required this.subject,
    required this.teacherId,
    this.teacherName,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    required this.room,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper method to format time for display
  String get formattedTime {
    final startHour = startTime.hour.toString().padLeft(2, '0');
    final startMinute = startTime.minute.toString().padLeft(2, '0');
    final endHour = endTime.hour.toString().padLeft(2, '0');
    final endMinute = endTime.minute.toString().padLeft(2, '0');
    
    return '$startHour:$startMinute - $endHour:$endMinute';
  }

  // Helper method to get duration in minutes
  int get durationMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  // Helper method to check if schedule is today
  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
           startTime.month == now.month &&
           startTime.day == now.day;
  }

  // Helper method to check if schedule is in the past
  bool get isPast {
    return startTime.isBefore(DateTime.now());
  }

  // Helper method to check if schedule is upcoming (within next 24 hours)
  bool get isUpcoming {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    return startTime.isAfter(now) && startTime.isBefore(tomorrow);
  }
}
