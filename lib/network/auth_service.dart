import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class AuthService {
  static const String baseUrl = 'https://take-home-test-api.nutech-integrasi.com';

  final Dio _dio;

  final Box _authBox = Hive.box('authBox');

  AuthService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 5), // Updated to Duration
            receiveTimeout: const Duration(seconds: 3), // Updated to Duration
          ),
        ) {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      logPrint: (object) => print(object), // Customize log output (optional)
    ));
  }

  // Login API call
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      String token = response.data['data']['token'];
      print("Token received: $token");
      // Save the token in Hive
      await _saveToken(token);
      return response;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      throw Exception(_handleDioError(e));
    }
  }

  // Register API call
  Future<Response> register(
      String email, String firstName, String lastName, String password) async {
    try {
      final response = await _dio.post('/registration', data: {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
      });
      return response;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> _saveToken(String token) async {
    await _authBox.put('token', token); // Save token in Hive box
  }

  Future<String?> getToken() async {
    return _authBox.get('token'); // Retrieve token from Hive box
  }

  Future<void> logout() async {
    await _authBox.delete('token'); // Remove token from Hive box
  }
}

// Handle Dio errors
String _handleDioError(DioException error) {
  if (error.response != null) {
    // Server responded with an error
    return "Server error: ${error.response?.data['message'] ?? error.response?.statusMessage}";
  } else if (error.type == DioExceptionType.connectionTimeout) {
    return "Connection timeout. Please check your internet connection.";
  } else if (error.type == DioExceptionType.receiveTimeout) {
    return "Receive timeout. The server may be busy. Try again later.";
  } else if (error.type == DioExceptionType.unknown) {
    return "Connection failed. Please check your network.";
  }
  return "An unexpected error occurred.";
}