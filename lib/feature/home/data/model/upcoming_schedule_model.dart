import 'package:e4uflutter/feature/home/domain/entity/upcoming_schedule_entity.dart';

class UpcomingScheduleModel extends UpcomingScheduleEntity {
  const UpcomingScheduleModel({
    required super.id,
    required super.day,
    required super.period,
    required super.isDone,
    required super.classInfo,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UpcomingScheduleModel.fromJson(Map<String, dynamic> json) {
    // Debug: In toàn bộ JSON để kiểm tra
    print('Parsing schedule - Full JSON: $json');
    print('Available keys: ${json.keys.toList()}');
    
    DateTime day;
    try {
      day = DateTime.parse(json['day']);
    } catch (e) {
      day = DateTime.now();
    }

    DateTime createdAt;
    try {
      createdAt = DateTime.parse(json['createdAt']);
    } catch (e) {
      createdAt = DateTime.now();
    }

    DateTime updatedAt;
    try {
      updatedAt = DateTime.parse(json['updatedAt']);
    } catch (e) {
      updatedAt = DateTime.now();
    }

    // Thử nhiều cách để lấy class data
    Map<String, dynamic>? classData;
    
    // Thử các key khác nhau
    if (json.containsKey('class') && json['class'] != null) {
      classData = json['class'] is Map ? Map<String, dynamic>.from(json['class']) : null;
    } else if (json.containsKey('classId') || json.containsKey('class_id')) {
      // Nếu chỉ có classId, có thể cần fetch thêm thông tin
      print('Warning: Only classId found, class object is missing');
    }
    
    print('Parsing schedule - classData: $classData');
    
    // Xử lý trường hợp class có thể là null hoặc không có dữ liệu
    String className = '';
    String classCode = '';
    String classId = '';
    
    if (classData != null && classData.isNotEmpty) {
      className = classData['name']?.toString() ?? classData['className']?.toString() ?? '';
      classCode = classData['code']?.toString() ?? classData['classCode']?.toString() ?? '';
      classId = classData['_id']?.toString() ?? classData['id']?.toString() ?? '';
    }
    
    // Nếu không có name, dùng code làm fallback
    if (className.isEmpty && classCode.isNotEmpty) {
      className = classCode;
    }
    
    print('Parsed class info: id=$classId, name=$className, code=$classCode');
    
    return UpcomingScheduleModel(
      id: json['_id'] ?? json['id'] ?? '',
      day: day,
      period: json['period'] ?? '',
      isDone: json['isDone'] ?? false,
      classInfo: ScheduleClassInfo(
        id: classId,
        name: className.isNotEmpty ? className : 'Chưa có lớp',
        code: classCode,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'day': day.toIso8601String(),
      'period': period,
      'isDone': isDone,
      'class': {
        '_id': classInfo.id,
        'name': classInfo.name,
        'code': classInfo.code,
      },
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

