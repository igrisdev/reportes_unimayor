import 'package:reportes_unimayor/services/base_dio_service.dart';

class ApiReportsService extends BaseDioService {
  Future<String> getReports(String token) async {
    dio.options.headers["Authorization"] = "Bearer $token";

    final response = await dio.get('/reportes');

    print(response.data);

    // if (response.statusCode == 200) {
    // return response.data['token'];
    return '';
    // }
  }
}
