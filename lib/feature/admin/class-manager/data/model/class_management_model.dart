import 'package:e4uflutter/feature/admin/class-manager/domain/entity/class_management_entity.dart';

class ClassManagementModel extends ClassManagementEntity {
  const ClassManagementModel({
    required super.id,
    required super.name,
    required super.code,
    required super.description,
    required super.homeroomTeacherId,
    super.homeroomTeacherName,
    required super.studentIds,
    required super.enrollmentIds,
    required super.maxStudents,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ClassManagementModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing class: ${json['name']} (${json['code']})');
      print('Full JSON data: $json');
      
      // Parse timestamps with fallback
      DateTime createdAt;
      try {
        createdAt = DateTime.parse(json['createdAt']);
      } catch (e) {
        print('Error parsing createdAt: $e, using current time');
        createdAt = DateTime.now();
      }
      
      DateTime updatedAt;
      try {
        updatedAt = DateTime.parse(json['updatedAt']);
      } catch (e) {
        print('Error parsing updatedAt: $e, using current time');
        updatedAt = DateTime.now();
      }
      
      return ClassManagementModel(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        code: json['code'] ?? '',
        description: json['description'] ?? '',
        homeroomTeacherId: json['homeroomTeacher'] != null ? json['homeroomTeacher']['_id'] ?? json['homeroomTeacher']['id'] ?? '' : '',
        homeroomTeacherName: json['homeroomTeacher'] != null ? _buildTeacherName(json['homeroomTeacher']) : null,
        studentIds: json['students'] != null ? (json['students'] as List).cast<String>() : [],
        enrollmentIds: json['enrollments'] != null ? (json['enrollments'] as List).cast<String>() : [],
        maxStudents: json['maxStudents'] ?? 30,
        isActive: json['isActive'] ?? true,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      print('Error parsing class JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'description': description,
      'homeroomTeacher': homeroomTeacherId,
      'students': studentIds,
      'enrollments': enrollmentIds,
      'maxStudents': maxStudents,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static String? _buildTeacherName(Map<String, dynamic> teacherData) {
    // Try different possible formats for teacher name
    if (teacherData['fullName'] != null) {
      return teacherData['fullName'];
    }
    if (teacherData['name'] != null) {
      return teacherData['name'];
    }
    
    // Build from firstName and lastName
    final firstName = teacherData['firstName']?.toString() ?? '';
    final lastName = teacherData['lastName']?.toString() ?? '';
    
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    }
    
    return null;
  }
}

class StudentClassModel extends StudentClassEntity {
  const StudentClassModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.classId,
    required super.className,
    required super.enrolledAt,
    required super.isActive,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    try {
      DateTime enrolledAt;
      try {
        enrolledAt = DateTime.parse(json['enrolledAt']);
      } catch (e) {
        print('Error parsing enrolledAt: $e, using current time');
        enrolledAt = DateTime.now();
      }
      
      return StudentClassModel(
        id: json['_id'] ?? json['id'] ?? '',
        studentId: json['studentId'] ?? json['student']?['_id'] ?? json['student']?['id'] ?? '',
        studentName: json['studentName'] ?? json['student']?['fullName'] ?? json['student']?['name'] ?? '',
        classId: json['classId'] ?? json['class']?['_id'] ?? json['class']?['id'] ?? '',
        className: json['className'] ?? json['class']?['name'] ?? '',
        enrolledAt: enrolledAt,
        isActive: json['isActive'] ?? true,
      );
    } catch (e) {
      print('Error parsing student class JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'studentId': studentId,
      'studentName': studentName,
      'classId': classId,
      'className': className,
      'enrolledAt': enrolledAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
