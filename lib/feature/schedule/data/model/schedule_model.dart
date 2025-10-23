class ScheduleModel {
  final String id;
  final String day;
  final String period;
  final bool isDone;
  final String classId;
  final String? className;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduleModel({
    required this.id,
    required this.day,
    required this.period,
    required this.isDone,
    required this.classId,
    this.className,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['_id'] ?? json['id'] ?? '',
      day: json['day'] ?? '',
      period: json['period'] ?? '',
      isDone: json['isDone'] ?? false,
      classId: json['class']?['_id'] ?? json['class']?['id'] ?? '',
      className: json['class']?['name'] ?? json['class']?['code'],
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
}
