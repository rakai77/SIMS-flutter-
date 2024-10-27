import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class ApiService {
  static const String baseUrl =
      'https://take-home-test-api.nutech-integrasi.com';
  final Dio _dio;

  ApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 5), // Updated to Duration
            receiveTimeout: const Duration(seconds: 3), // Updated to Duration
          ),
        ) {
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Retrieve token from Hive storage
          final box = Hive.box('authBox');
          final token = box.get('token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); // Continue with the request
        },
      ),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) => print(object),
      ),
    ]);
  }

  Future<Response> getProfile() async {
    return await _dio.get('/profile'); // Use relative path with baseUrl
  }

  Future<Response> getBanners() async {
    return await _dio.get('/banner');
  }

  Future<Response> getBalance() async {
    return await _dio.get('/balance');
  }
}
