import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e4uflutter/core/config/api_config.dart';
import 'package:e4uflutter/feature/schedule/data/model/schedule_model.dart';

class ScheduleDataSource {
  final http.Client _client;

  ScheduleDataSource({http.Client? client}) : _client = client ?? http.Client();

  // Get my schedule for a specific day
  Future<List<ScheduleModel>> getMySchedule(String day, String? token) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.mySchedule(day)}'),
        headers: ApiConfig.getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['data']?['schedules'] != null) {
          final List<dynamic> schedulesJson = data['data']['schedules'];
          return schedulesJson.map((json) => ScheduleModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch schedule: $e');
    }
  }

  // Get upcoming schedules
  Future<List<ScheduleModel>> getUpcomingSchedules(String? token) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.upcomingSchedules}'),
        headers: ApiConfig.getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['data']?['schedules'] != null) {
          final List<dynamic> schedulesJson = data['data']['schedules'];
          return schedulesJson.map((json) => ScheduleModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch upcoming schedules: $e');
    }
  }

  // Create new schedule (Admin only)
  Future<ScheduleModel> createSchedule(Map<String, dynamic> scheduleData, String? token) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.schedules}'),
        headers: ApiConfig.getHeaders(token),
        body: json.encode(scheduleData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['data']?['schedule'] != null) {
          return ScheduleModel.fromJson(data['data']['schedule']);
        }
      }
      throw Exception('Failed to create schedule');
    } catch (e) {
      throw Exception('Failed to create schedule: $e');
    }
  }

  // Update schedule (Admin only)
  Future<ScheduleModel> updateSchedule(String scheduleId, Map<String, dynamic> updates, String? token) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.scheduleById(scheduleId)}'),
        headers: ApiConfig.getHeaders(token),
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['data']?['schedule'] != null) {
          return ScheduleModel.fromJson(data['data']['schedule']);
        }
      }
      throw Exception('Failed to update schedule');
    } catch (e) {
      throw Exception('Failed to update schedule: $e');
    }
  }

  // Delete schedule (Admin only)
  Future<bool> deleteSchedule(String scheduleId, String? token) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.scheduleById(scheduleId)}'),
        headers: ApiConfig.getHeaders(token),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }

  // Get schedules by class ID (Admin only)
  Future<List<ScheduleModel>> getSchedulesByClassId(String classId, String day, String? token) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.scheduleById(classId)}?day=$day'),
        headers: ApiConfig.getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['data']?['schedules'] != null) {
          final List<dynamic> schedulesJson = data['data']['schedules'];
          return schedulesJson.map((json) => ScheduleModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch schedules by class: $e');
    }
  }
}
