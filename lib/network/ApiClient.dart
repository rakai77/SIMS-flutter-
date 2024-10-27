import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'https://take-home-test-api.nutech-integrasi.com';

  final Dio _dio;

  ApiClient()
      : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5), // Updated to Duration
      receiveTimeout: const Duration(seconds: 3), // Updated to Duration
    ),
  );

  // Login API call
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      return response;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      throw Exception(_handleDioError(e));
    }
  }

  // Register API call
  Future<Response> register(String email, String firstName, String lastName, String password) async {
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

  // Handle Dio errors
  String _handleDioError(DioException error) {
    if (error.response != null) {
      return error.response!.data['message'] ?? 'Unknown error occurred';
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timed out. Please try again later.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}
