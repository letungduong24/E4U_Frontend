import 'package:dio/dio.dart';
import 'package:e4uflutter/core/config/dio_config.dart';
import 'package:e4uflutter/core/storage/token_storage.dart';
import 'package:e4uflutter/feature/auth/data/model/user_model.dart';

class AuthDatasource{
  final Dio _dio = DioClient().dio;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      await _tokenStorage.writeToken(response.data['data']['token']);
      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Kết nối quá thời gian. Vui lòng thử lại.');
      } else {
        throw Exception(e.response?.data['message'] ?? 'Đăng nhập thất bại');
      }
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Lấy thông tin người dùng thất bại');
    }
  }

}