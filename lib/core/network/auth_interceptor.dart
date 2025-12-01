import 'package:dio/dio.dart';
import 'package:Wetieko/core/services/token_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorageService _tokenStorageService;
  final Dio _dio;

  AuthInterceptor(this._tokenStorageService, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _tokenStorageService.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
     
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
   
    if (err.response?.statusCode == 401 && !_isRetry(err)) {
      try {
        final refreshToken = await _tokenStorageService.getRefreshToken();

        if (refreshToken != null) {
          final refreshResponse = await _dio.post('/auth/refresh', data: {
            'refreshToken': refreshToken,
          });

          final newAccessToken = refreshResponse.data['accessToken'];

          if (newAccessToken != null) {
            // Yeni token'ı kaydet
            await _tokenStorageService.saveToken(newAccessToken, refreshToken);

            // İsteği tekrar dene
            final originalRequest = err.requestOptions;
            originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
            originalRequest.extra['retried'] = true; // Retry işareti

            final retryResponse = await _dio.fetch(originalRequest);
            return handler.resolve(retryResponse);
          }
        }
      } catch (_) {
        await _tokenStorageService.deleteToken(); 
      }
    }

    
    handler.next(err);
  }

  bool _isRetry(DioException err) {
    return err.requestOptions.extra['retried'] == true;
  }
}
