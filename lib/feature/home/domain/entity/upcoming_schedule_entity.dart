class UpcomingScheduleEntity {
  final String id;
  final DateTime day;
  final String period; // Format: "08:00-09:00"
  final bool isDone;
  final ScheduleClassInfo classInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UpcomingScheduleEntity({
    required this.id,
    required this.day,
    required this.period,
    required this.isDone,
    required this.classInfo,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ScheduleClassInfo {
  final String id;
  final String name;
  final String code;

  const ScheduleClassInfo({
    required this.id,
    required this.name,
    required this.code,
  });
}

