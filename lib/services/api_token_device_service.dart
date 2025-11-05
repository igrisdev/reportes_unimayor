import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reportes_unimayor/services/base_dio_service.dart';

final apiTokenDeviceServiceProvider = Provider(
  (ref) => ApiTokenDeviceService(ref),
);

class ApiTokenDeviceService extends BaseDioService {
  final Ref _ref;
  ApiTokenDeviceService(this._ref) : super(_ref);

  Future<bool> setTokenDevice() async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      if (deviceToken == null) {
        throw Exception('No se pudo obtener el token del dispositivo');
      }

      final response = await dio.post(
        '/dispositivos/registrar',
        data: {'token': deviceToken},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('No se pudo registrar el token del dispositivo');
      }
    } catch (e) {
      throw Exception('No se pudo registrar el token del dispositivo');
    }
  }

  Future<bool> deleteTokenDevice() async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      if (deviceToken == null) {
        throw Exception(
          'No se pudo obtener el token del dispositivo para eliminarlo',
        );
      }
      final response = await dio.delete(
        '/dispositivos/eliminar',
        data: {'token': deviceToken},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
