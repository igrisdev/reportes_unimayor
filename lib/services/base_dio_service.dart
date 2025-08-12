import 'package:dio/dio.dart';
// import 'dart:io';
// import 'package:dio/io.dart';

class BaseDioService {
  static final optionsDio = BaseOptions(
    // baseUrl: 'http://10.0.2.2:5217/api', // desde el emulador android studio
    // baseUrl: 'http://192.168.101.78:5217/api', // desde dispositivo físico
    baseUrl: 'https://qwwwk0hk-5217.use2.devtunnels.ms/api',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  );

  final dio = Dio(optionsDio);

  // BaseDioService() {
  //   dio.httpClientAdapter = DefaultHttpClientAdapter()
  //     ..onHttpClientCreate = (HttpClient client) {
  //       client.badCertificateCallback =
  //           (X509Certificate cert, String host, int port) => true;
  //       return client;
  //     };
  // }
}
