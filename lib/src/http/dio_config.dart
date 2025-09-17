import 'package:dio/dio.dart';

class DioConfig {
  static late Dio _dio;
  
  static Dio get dio => _dio;
  
  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://viacep.com.br/ws/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}