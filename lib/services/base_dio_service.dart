import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:io';
// import 'package:dio/io.dart';

class BaseDioService {
  static final String url = dotenv.env['BASE_URL']!;
  static final String baseUrl = '$url/api';

  static final optionsDio = BaseOptions(
    baseUrl: baseUrl,
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
