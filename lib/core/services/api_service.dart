import 'dart:io';
import 'package:dio/dio.dart';
import 'package:Wetieko/core/network/auth_interceptor.dart';
import 'package:Wetieko/core/network/global_error_interceptor.dart';
import 'package:Wetieko/core/services/token_storage_service.dart';
import 'package:Wetieko/core/network/loading_interceptor.dart';

class ApiService {
  static const String baseUrl = 'https://wetiekoapi.goalmedia.com.tr';

  final Dio _dio;
  final TokenStorageService _tokenStorageService;

  ApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ),
        _tokenStorageService = TokenStorageService() {
    _dio.interceptors.add(AuthInterceptor(_tokenStorageService, _dio));
    _dio.interceptors.add(GlobalErrorInterceptor());
    _dio.interceptors.add(LoadingInterceptor());
  }

  Future<Response> post(String path, dynamic data) async {
    return await _dio.post(
      path,
      data: data,
      options: Options(contentType: 'application/json'),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> put(String path, dynamic data) async {
    return await _dio.put(
      path,
      data: data,
      options: Options(contentType: 'application/json'),
    );
  }

  Future<Response> delete(String path, {Map<String, dynamic>? data}) async {
    return await _dio.delete(
      path,
      data: data,
      options: Options(contentType: 'application/json'),
    );
  }

  /// 🔥 PATCH → Content-Type JSON zorunlu (403’ü çözen fix)
  Future<Response> patch(String path, dynamic data) async {
    return await _dio.patch(
      path,
      data: data,
      options: Options(contentType: 'application/json'),
    );
  }

  Future<Response> postMultipart(String path, Map<String, dynamic> fields) async {
    final formData = FormData.fromMap(fields);
    return await _dio.post(path, data: formData);
  }

  Future<MultipartFile> multipartFile(File file) async {
    final fileName = file.path.split('/').last;
    return MultipartFile.fromFile(file.path, filename: fileName);
  }
}
