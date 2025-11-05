import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reportes_unimayor/providers/auth_notifier_provider.dart';
import 'package:reportes_unimayor/services/api_token_device_service.dart';
import 'package:reportes_unimayor/services/base_dio_service.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:reportes_unimayor/utils/local_storage.dart';

final apiAuthServiceProvider = Provider((ref) => ApiAuthService(ref));

class ApiAuthService extends BaseDioService {
  final Ref _ref;
  ApiAuthService(this._ref) : super(_ref);

  Future<String?> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/invitados/login',
        data: {'correo': email, 'contraseña': password},
      );

      if (response.statusCode == 200) {
        await writeStorage('token', response.data['token']);
        await writeStorage('refresh_token', response.data['refreshToken']);

        _ref.read(authNotifierProvider.notifier).login();

        await _ref.read(apiTokenDeviceServiceProvider).setTokenDevice();
        return response.data['token'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> userType() async {
    final String? token = await readStorage('token');

    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      final jwt = JWT.decode(token);
      final payload = jwt.payload;

      final dynamic esBrigadistaValue = payload['EsBrigadista'];

      if (esBrigadistaValue is bool) {
        return esBrigadistaValue;
      }
      if (esBrigadistaValue is String) {
        return esBrigadistaValue.toLowerCase() == 'true';
      }
      if (esBrigadistaValue is int) {
        return esBrigadistaValue == 1;
      }

      return false;
    } catch (e) {
      print('userType: ERROR CRÍTICO al decodificar JWT: $e');
      return false;
    }
  }
}
