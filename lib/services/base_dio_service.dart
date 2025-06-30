import 'package:dio/dio.dart';

class BaseDioService {
  static final optionsDio = BaseOptions(
    baseUrl: 'http://10.0.2.2:5217/api',
    // baseUrl: 'http://localhost:5217/api', // Descomenta esta si no usas emulador Android
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  );

  final dio = Dio(optionsDio);
}
