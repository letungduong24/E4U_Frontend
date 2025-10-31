import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/feature/schedule/data/model/schedule_model.dart';

class ScheduleDataSource {
  final DioClient _dioClient = DioClient();

  // Get my schedule for a specific day
  Future<List<ScheduleModel>> getMySchedule(String day) async {
    try {
      final response = await _dioClient.dio.get(
        '/schedules/my-schedule',
        queryParameters: {'day': day},
      );

      if (response.statusCode == 200) {
        final data = response.data;
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
  Future<List<ScheduleModel>> getUpcomingSchedules() async {
    try {
      final response = await _dioClient.dio.get('/schedules/upcoming');

      if (response.statusCode == 200) {
        final data = response.data;
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
  Future<ScheduleModel> createSchedule(Map<String, dynamic> scheduleData) async {
    try {
      final response = await _dioClient.dio.post(
        '/schedules',
        data: scheduleData,
      );

      if (response.statusCode == 201) {
        final data = response.data;
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
  Future<ScheduleModel> updateSchedule(String scheduleId, Map<String, dynamic> updates) async {
    try {
      final response = await _dioClient.dio.put(
        '/schedules/$scheduleId',
        data: updates,
      );

      if (response.statusCode == 200) {
        final data = response.data;
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
  Future<bool> deleteSchedule(String scheduleId) async {
    try {
      final response = await _dioClient.dio.delete('/schedules/$scheduleId');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete schedule: $e');
    }
  }

  // Get schedules by class ID (Admin only)
  Future<List<ScheduleModel>> getSchedulesByClassId(String classId, String day) async {
    try {
      final response = await _dioClient.dio.get(
        '/schedules/$classId',
        queryParameters: {'day': day},
      );

      if (response.statusCode == 200) {
        final data = response.data;
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

  // Get all schedules
  Future<List<ScheduleModel>> getAllSchedules() async {
    try {
      final response = await _dioClient.dio.get('/schedules');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data']?['schedules'] != null) {
          final List<dynamic> schedulesJson = data['data']['schedules'];
          return schedulesJson.map((json) => ScheduleModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch all schedules: $e');
    }
  }

  // Get schedule by ID
  Future<ScheduleModel> getScheduleById(String scheduleId) async {
    try {
      final response = await _dioClient.dio.get('/schedules/$scheduleId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data']?['schedule'] != null) {
          return ScheduleModel.fromJson(data['data']['schedule']);
        }
      }
      throw Exception('Schedule not found');
    } catch (e) {
      throw Exception('Failed to fetch schedule: $e');
    }
  }


  // Get schedules by class
  Future<List<ScheduleModel>> getSchedulesByClass(String classCode) async {
    try {
      final response = await _dioClient.dio.get(
        '/schedules/class/$classCode',
      );

      if (response.statusCode == 200) {
        final data = response.data;
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

  // Get schedules by teacher
  Future<List<ScheduleModel>> getSchedulesByTeacher(String teacherId) async {
    try {
      final response = await _dioClient.dio.get(
        '/schedules/teacher/$teacherId',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data']?['schedules'] != null) {
          final List<dynamic> schedulesJson = data['data']['schedules'];
          return schedulesJson.map((json) => ScheduleModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch schedules by teacher: $e');
    }
  }

  // Get schedules by date (Admin only)
  Future<List<ScheduleModel>> getSchedulesByDate(String day) async {
    try {
      final response = await _dioClient.dio.get(
        '/schedules/by-date',
        queryParameters: {'day': day},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data']?['schedules'] != null) {
          final List<dynamic> schedulesJson = data['data']['schedules'];
          return schedulesJson.map((json) => ScheduleModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch schedules by date: $e');
    }
  }
}
