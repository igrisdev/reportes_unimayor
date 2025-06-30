import 'package:reportes_unimayor/services/base_dio_service.dart';

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

  Future<String> typeUser(String token) async {
    // final decodedToken = JwtDecoder.decode(token);
    // final roles = decodedToken['roles'];

    final roles = ['Usuario', 'Brigadista', 'Administrador'];

    if (roles.contains('Usuario')) {
      return 'Usuario';
    } else if (roles.contains('Brigradista')) {
      return 'Brigadista';
    } else if (roles.contains('Administrador')) {
      return 'Administrador';
    } else {
      return 'Usuario';
    }
  }
}
