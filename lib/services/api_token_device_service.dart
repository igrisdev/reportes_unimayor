import 'package:reportes_unimayor/services/base_dio_service.dart';

class ApiTokenDeviceService extends BaseDioService {
  Future<bool> setTokenDevice(String tokenDevice, String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.post(
        '/dispositivos/registrar',
        data: {'token': tokenDevice},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTokenDevice(String tokenDevice, String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.delete(
        '/dispositivos/eliminar',
        data: {'token': tokenDevice},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error Delete **********************');
      print(e);
      return false;
    }
  }
}
