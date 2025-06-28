import 'package:reportes_unimayor/services/base_dio_service.dart';

class ApiAuthService extends BaseDioService {
  Future<String> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    print(response.data);

    return response.data['token'];
  }
}
