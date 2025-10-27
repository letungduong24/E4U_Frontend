class ScheduleModel {
  final String id;
  final String day;
  final String period;
  final bool isDone;
  final String classId;
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

  ScheduleModel({
    required this.id,
    required this.day,
    required this.period,
    required this.isDone,
    required this.classId,
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

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse period to extract start and end time
      final period = json['period'] ?? '';
      final (start, end) = _parsePeriod(period);
      
      return ScheduleModel(
        id: _parseId(json['_id']) ?? _parseId(json['id']) ?? '',
        day: json['day'] ?? '',
        period: period,
        isDone: json['isDone'] ?? false,
        classId: _parseId(json['class']?['_id']) ?? _parseId(json['classId']) ?? _parseId(json['class']) ?? '',
        className: json['class']?['name'] ?? json['class']?['code'] ?? '',
        subject: json['subject'] ?? 'No Subject',
        teacherId: _parseId(json['teacher']?['_id']) ?? _parseId(json['teacherId']) ?? '',
        teacherName: json['teacher']?['name'] ?? json['teacherName'],
        startTime: start,
        endTime: end,
        dayOfWeek: _getDayOfWeekFromDate(json['day'] ?? ''),
        room: json['room'] ?? 'No Room',
        description: json['description'],
        createdAt: _parseDateTime(json['createdAt']),
        updatedAt: _parseDateTime(json['updatedAt']),
      );
    } catch (e) {
      // Return a default model if parsing fails
      return ScheduleModel(
        id: _parseId(json['_id']) ?? _parseId(json['id']) ?? DateTime.now().millisecondsSinceEpoch.toString(),
        day: json['day'] ?? '',
        period: json['period'] ?? '',
        isDone: false,
        classId: '',
        className: '',
        subject: 'No Subject',
        teacherId: '',
        teacherName: '',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        dayOfWeek: '',
        room: 'No Room',
        description: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
  
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
  
  static String _getDayOfWeekFromDate(String day) {
    try {
      final date = DateTime.parse(day);
      final weekdays = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
      final weekday = date.weekday % 7;
      return weekdays[weekday];
    } catch (e) {
      return '';
    }
  }
  
  static (DateTime, DateTime) _parsePeriod(String period) {
    // Parse period like "08:00-09:00" into start and end times
    try {
      final parts = period.split('-');
      if (parts.length != 2) {
        return (DateTime.now(), DateTime.now().add(const Duration(hours: 1)));
      }
      
      final startParts = parts[0].trim().split(':');
      final endParts = parts[1].trim().split(':');
      
      if (startParts.length != 2 || endParts.length != 2) {
        return (DateTime.now(), DateTime.now().add(const Duration(hours: 1)));
      }
      
      final now = DateTime.now();
      final start = DateTime(
        now.year,
        now.month,
        now.day,
        int.tryParse(startParts[0]) ?? now.hour,
        int.tryParse(startParts[1]) ?? now.minute,
      );
      final end = DateTime(
        now.year,
        now.month,
        now.day,
        int.tryParse(endParts[0]) ?? now.add(const Duration(hours: 1)).hour,
        int.tryParse(endParts[1]) ?? now.minute,
      );
      
      return (start, end);
    } catch (e) {
      return (DateTime.now(), DateTime.now().add(const Duration(hours: 1)));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'period': period,
      'isDone': isDone,
      'class': {
        '_id': classId,
        'name': className,
      },
      'subject': subject,
      'teacher': {
        '_id': teacherId,
        'name': teacherName,
      },
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'dayOfWeek': dayOfWeek,
      'room': room,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method to get class code for display
  String get classCode => className ?? classId;

  // Helper method to format time for display
  String get formattedTime => period;

  // Helper method to check if schedule is today
  bool get isToday {
    final now = DateTime.now();
    final scheduleDate = DateTime.parse(day);
    return now.year == scheduleDate.year &&
           now.month == scheduleDate.month &&
           now.day == scheduleDate.day;
  }

  static String? _parseId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is int) return value.toString();
    return value.toString();
  }
}
