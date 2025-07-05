import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class BaseDioService {
  static final optionsDio = BaseOptions(
    baseUrl:
        'https://10.0.2.2:7208/api', // Asegúrate de que la IP esté correcta
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  );

  final dio = Dio(optionsDio);

  BaseDioService() {
    dio.httpClientAdapter = DefaultHttpClientAdapter()
      ..onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
  }
}
