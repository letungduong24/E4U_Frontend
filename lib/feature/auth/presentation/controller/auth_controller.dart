import 'package:get/get.dart';
import 'package:e4uflutter/feature/auth/data/datasource/auth_datasource.dart';
import 'package:e4uflutter/feature/auth/data/repository/auth_repo_impl.dart';
import 'package:e4uflutter/feature/auth/domain/usecase/login_usecase.dart';
import 'package:e4uflutter/feature/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:e4uflutter/feature/auth/domain/usecase/logout_usecase.dart';
import 'package:e4uflutter/feature/auth/domain/entity/user_entity.dart';
import 'package:e4uflutter/core/storage/token_storage.dart';

class AuthController extends GetxController {
  // Observable state - using global GetX state
  static final Rx<UserEntity?> user = Rx<UserEntity?>(null);
  static final RxBool isLoading = false.obs;
  static final RxString error = ''.obs;
  static final RxBool isInitialized = false.obs;

  // Dependencies
  late final AuthDatasource _authDatasource;
  late final TokenStorage _tokenStorage;
  late final AuthRepositoryImpl _authRepository;
  late final LoginUsecase _loginUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final LogoutUsecase _logoutUsecase;

  // Getters
  bool get isAuthenticated => user.value != null;
  String? get userEmail => user.value?.email;
  String? get userRole => user.value?.role;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    _initializeAuthState();
  }

  void _initializeDependencies() {
    _authDatasource = AuthDatasource();
    _tokenStorage = TokenStorage();
    _authRepository = AuthRepositoryImpl(_authDatasource, _tokenStorage);
    _loginUsecase = LoginUsecase(_authRepository);
    _getCurrentUserUsecase = GetCurrentUserUsecase(_authRepository);
    _logoutUsecase = LogoutUsecase(_authRepository);
  }

  Future<void> _initializeAuthState() async {
    try {
      isLoading.value = true;
      final userData = await _getCurrentUserUsecase();
      user.value = userData;
    } catch (e) {
      user.value = null;
    } finally {
      isLoading.value = false;
      isInitialized.value = true;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    error.value = '';
    
    try {
      final userData = await _loginUsecase(email, password);
      user.value = userData;
      isLoading.value = false;
      
      // Navigate to appropriate home based on role
      switch (userData.role) {
        case 'admin':
          Get.offAllNamed('/admin-home');
          break;
        case 'teacher':
          Get.offAllNamed('/teacher-home');
          break;
        case 'student':
        default:
          Get.offAllNamed('/home');
          break;
      }
    } catch (e) {
      isLoading.value = false;
      error.value = "Thông tin đăng nhập không hợp lệ";
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final userData = await _getCurrentUserUsecase();
      user.value = userData;
    } catch (e) {
      user.value = null;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    
    try {
      await _logoutUsecase();
      user.value = null;
      isLoading.value = false;
      
      Get.offAllNamed('/login');
    } catch (e) {
      isLoading.value = false;
      error.value = e.toString();
    }
  }

  void clearError() {
    error.value = '';
  }
}
