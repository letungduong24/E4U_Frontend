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
    return ScheduleModel(
      id: _parseId(json['_id']) ?? _parseId(json['id']) ?? '',
      day: json['day'] ?? '',
      period: json['period'] ?? '',
      isDone: json['isDone'] ?? false,
      classId: _parseId(json['class']?['_id']) ?? _parseId(json['class']?['id']) ?? '',
      className: json['class']?['name'] ?? json['class']?['code'],
      subject: json['subject'] ?? 'Tiếng Anh',
      teacherId: _parseId(json['teacher']?['_id']) ?? _parseId(json['teacherId']) ?? '',
      teacherName: json['teacher']?['name'] ?? json['teacherName'],
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['endTime'] ?? DateTime.now().toIso8601String()),
      dayOfWeek: json['dayOfWeek'] ?? 'Monday',
      room: json['room'] ?? 'Room 101',
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
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
