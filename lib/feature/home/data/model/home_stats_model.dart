import 'package:e4uflutter/feature/home/domain/entity/home_stats_entity.dart';

class HomeStatsModel extends HomeStatsEntity {
  const HomeStatsModel({
    required super.homeworkCount,
    required super.documentCount,
    required super.scheduleCount,
    required super.studentCount,
    required super.classCount,
  });

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    return HomeStatsModel(
      homeworkCount: json['homeworkCount'] ?? 0,
      documentCount: json['documentCount'] ?? 0,
      scheduleCount: json['scheduleCount'] ?? 0,
      studentCount: json['studentCount'] ?? 0,
      classCount: json['classCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'homeworkCount': homeworkCount,
      'documentCount': documentCount,
      'scheduleCount': scheduleCount,
      'studentCount': studentCount,
      'classCount': classCount,
    };
  }
}

