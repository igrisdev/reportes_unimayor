import 'package:reportes_unimayor/services/base_dio_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class ApiAuthService extends BaseDioService {
  Future<String?> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'correoInstitucional': email, 'contraseña': password},
      );

      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  bool userType(String? token) {
    if (token == null || token.isEmpty) return false;

    try {
      final jwt = JWT.decode(token);
      return bool.parse(jwt.payload['EsBrigadista']);
    } catch (e) {
      return false;
    }
  }
}
