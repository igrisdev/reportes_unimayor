import 'package:dio/dio.dart';

class BaseDioService {
  static final optionsDio = BaseOptions(
    baseUrl: 'https://localhost:7208/api',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  );

  final dio = Dio(optionsDio);
}
