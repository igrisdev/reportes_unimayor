import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';

class BaseDioService {
  static final String url = dotenv.env['BASE_URL']!;
  static final String baseUrl = '$url/api';

  static final optionsDio = BaseOptions(
    baseUrl: baseUrl,
    // connectTimeout: const Duration(seconds: 5),
    // receiveTimeout: const Duration(seconds: 3),
  );

  final dio = Dio(optionsDio);

  BaseDioService() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await readStorage('token');
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await readStorage('refresh_token');

            if (refreshToken != null) {
              try {
                final response = await dio.post(
                  '/auth/refresh/refresh',
                  data: {'refreshToken': refreshToken},
                );

                final newAccessToken = response.data['token'];
                final newRefreshToken = response.data['refreshToken'];

                await writeStorage('token', newAccessToken);
                await writeStorage('refresh_token', newRefreshToken);

                final retryRequest = e.requestOptions;
                retryRequest.headers['Authorization'] =
                    'Bearer $newAccessToken';

                final cloneResponse = await dio.fetch(retryRequest);
                return handler.resolve(cloneResponse);
              } catch (refreshError) {
                await deleteAllStorage();
                return handler.reject(e);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> logout() async {
    try {
      final refreshToken = await storage.read(key: 'refresh_token');
      if (refreshToken != null) {
        await dio.post(
          '/auth/refresh/logout',
          data: {'refresh_token': refreshToken},
        );
      }
    } catch (e) {
      print("Error en logout: $e");
    } finally {
      await storage.deleteAll();
    }
  }
}
