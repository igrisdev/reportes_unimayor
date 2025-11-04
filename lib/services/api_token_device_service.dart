import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reportes_unimayor/services/base_dio_service.dart';

final apiTokenDeviceServiceProvider = Provider(
  (ref) => ApiTokenDeviceService(ref),
);

class ApiTokenDeviceService extends BaseDioService {
  final Ref _ref;
  ApiTokenDeviceService(this._ref) : super(_ref);

  Future<bool> setTokenDevice(String tokenDevice) async {
    try {
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

  Future<bool> deleteTokenDevice(String tokenDevice) async {
    try {
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
