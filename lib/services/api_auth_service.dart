import 'package:reportes_unimayor/services/base_dio_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class ApiAuthService extends BaseDioService {
  Future<String> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'correoInstitucional': email, 'contraseña': password},
    );

    if (response.statusCode == 200) {
      return response.data['token'];
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  Future<bool> userType(String token) async {
    final jwt = JWT.decode(token);
    final esBrigadista = jwt.payload['EsBrigadista'];

    return bool.parse(esBrigadista.toString()) ?? false;
  }
}
